# CLI Lab - ALB and Auto Scaling

Repeat [Console lab 07](../../03-console-labs/07-load-balancer-auto-scaling/README.md) using AWS CLI.

> **Cost warning:** ALB + 2x EC2 - delete same day.

---

## 1. Theory Reminder

- **AMI** -> **Launch template** -> **ASG** -> registers with **Target group**
- **ALB** listener HTTP:80 forwards to target group
- **ALB SG:** HTTP from internet; **App SG:** HTTP only from ALB SG

---

## 2. Setup Variables

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export YOURNAME="<yourname>"
export MY_IP=$(curl -s https://checkip.amazonaws.com)/32
export VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true \
  --query "Vpcs[0].VpcId" --output text --profile aws-basic-lab --region ap-southeast-1)
export SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${VPC_ID}" \
  --query "Subnets[0:2].SubnetId" --output text --profile aws-basic-lab --region ap-southeast-1)
export SUBNET1=$(echo $SUBNETS | awk '{print $1}')
export SUBNET2=$(echo $SUBNETS | awk '{print $2}')
```

---

## 3. Resource Creation Commands

### 3.1 Security groups

```bash
export ALB_SG=$(aws ec2 create-security-group --group-name "devops-lab-${YOURNAME}-cli-alb-sg" \
  --description "ALB HTTP public" --vpc-id "$VPC_ID" --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)
aws ec2 authorize-security-group-ingress --group-id "$ALB_SG" --protocol tcp --port 80 --cidr 0.0.0.0/0 \
  --profile aws-basic-lab --region ap-southeast-1

export APP_SG=$(aws ec2 create-security-group --group-name "devops-lab-${YOURNAME}-cli-app-sg" \
  --description "App from ALB only" --vpc-id "$VPC_ID" --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)
aws ec2 authorize-security-group-ingress --group-id "$APP_SG" --protocol tcp --port 80 --source-group "$ALB_SG" \
  --profile aws-basic-lab --region ap-southeast-1

export BASE_SG=$(aws ec2 create-security-group --group-name "devops-lab-${YOURNAME}-cli-base-sg" \
  --description "Temporary base-instance SSH for lab only" --vpc-id "$VPC_ID" --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)
aws ec2 authorize-security-group-ingress --group-id "$BASE_SG" --protocol tcp --port 22 --cidr 0.0.0.0/0 \
  --profile aws-basic-lab --region ap-southeast-1
```

> **Lab-only exception:** `BASE_SG` opens SSH on `0.0.0.0/0` so students can complete the bootstrap and AMI flow reliably in a shared training setup. Do not use this in production; restrict SSH to `MY_IP` or use SSM Session Manager.

### 3.2 Base instance + AMI

```bash
export KEY_NAME="devops-lab-${YOURNAME}-cli-alb-key"
aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --key-format pem \
  --query KeyMaterial --output text --profile aws-basic-lab --region ap-southeast-1 > "${KEY_NAME}.pem"
chmod 400 "${KEY_NAME}.pem"

export AMI_ID=$(aws ec2 describe-images --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export BASE_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --instance-type t3.micro \
  --key-name "$KEY_NAME" --subnet-id "$SUBNET1" --security-group-ids "$APP_SG" "$BASE_SG" \
  --associate-public-ip-address \
  --query "Instances[0].InstanceId" --output text --profile aws-basic-lab --region ap-southeast-1)
aws ec2 wait instance-running --instance-ids "$BASE_ID" --profile aws-basic-lab --region ap-southeast-1

export BASE_IP=$(aws ec2 describe-instances --instance-ids "$BASE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

ssh -i "${KEY_NAME}.pem" ec2-user@"$BASE_IP" 'sudo dnf install -y nginx && sudo systemctl start nginx && echo ALB-CLI-LAB | sudo tee /usr/share/nginx/html/index.html'

export GOLDEN_AMI=$(aws ec2 create-image --instance-id "$BASE_ID" --name "devops-lab-${YOURNAME}-cli-nginx-ami" \
  --query ImageId --output text --profile aws-basic-lab --region ap-southeast-1)
aws ec2 wait image-available --image-ids "$GOLDEN_AMI" --profile aws-basic-lab --region ap-southeast-1

aws ec2 terminate-instances --instance-ids "$BASE_ID" --profile aws-basic-lab --region ap-southeast-1
aws ec2 wait instance-terminated --instance-ids "$BASE_ID" --profile aws-basic-lab --region ap-southeast-1
```

### 3.3 Launch template

```bash
aws ec2 create-launch-template \
  --launch-template-name "devops-lab-${YOURNAME}-cli-lt" \
  --version-description "CLI lab v1" \
  --launch-template-data "{\"ImageId\":\"${GOLDEN_AMI}\",\"InstanceType\":\"t3.micro\",\"KeyName\":\"${KEY_NAME}\",\"SecurityGroupIds\":[\"${APP_SG}\"]}" \
  --profile aws-basic-lab --region ap-southeast-1
```

> **Note:** nginx is already baked into the AMI, so additional UserData is not required in this lab.

### 3.4 Target group + ALB

```bash
export TG_ARN=$(aws elbv2 create-target-group \
  --name "devops-lab-${YOURNAME}-cli-tg" \
  --protocol HTTP --port 80 --vpc-id "$VPC_ID" \
  --health-check-path / --target-type instance \
  --query TargetGroups[0].TargetGroupArn --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export ALB_ARN=$(aws elbv2 create-load-balancer \
  --name "devops-lab-${YOURNAME}-cli-alb" \
  --subnets "$SUBNET1" "$SUBNET2" \
  --security-groups "$ALB_SG" \
  --scheme internet-facing --type application \
  --query LoadBalancers[0].LoadBalancerArn --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws elbv2 create-listener \
  --load-balancer-arn "$ALB_ARN" \
  --protocol HTTP --port 80 \
  --default-actions Type=forward,TargetGroupArn="$TG_ARN" \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.5 Auto Scaling Group

```bash
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name "devops-lab-${YOURNAME}-cli-asg" \
  --launch-template "LaunchTemplateName=devops-lab-${YOURNAME}-cli-lt,Version=\$Latest" \
  --min-size 2 --max-size 2 --desired-capacity 2 \
  --vpc-zone-identifier "${SUBNET1},${SUBNET2}" \
  --target-group-arns "$TG_ARN" \
  --health-check-type ELB --health-check-grace-period 120 \
  --tags "Key=Name,Value=devops-lab-${YOURNAME}-cli-asg-instance,PropagateAtLaunch=true" \
  --profile aws-basic-lab --region ap-southeast-1

echo "Wait 3-5 min for healthy targets..."
sleep 180
```

### 3.6 Test ALB DNS

```bash
export ALB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ALB_ARN" \
  --query "LoadBalancers[0].DNSName" --output text --profile aws-basic-lab --region ap-southeast-1)

curl -s "http://${ALB_DNS}" | head -5
```

---

## 4. Validation Commands

```bash
aws elbv2 describe-target-health --target-group-arn "$TG_ARN" \
  --profile aws-basic-lab --region ap-southeast-1 \
  --query "TargetHealthDescriptions[].{Id:Target.Id,Health:TargetHealth.State}" --output table

aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names "devops-lab-${YOURNAME}-cli-asg" \
  --query "AutoScalingGroups[0].{Desired:DesiredCapacity,Instances:Instances[*].InstanceId}" \
  --profile aws-basic-lab --region ap-southeast-1
```

| Output | Expected |
|--------|----------|
| Target health | `healthy` |
| Desired capacity | `2` |
| curl ALB DNS | nginx content |

---

## 5. Cleanup Commands

```bash
# Delete ASG with instances
aws autoscaling delete-auto-scaling-group \
  --auto-scaling-group-name "devops-lab-${YOURNAME}-cli-asg" \
  --force-delete --profile aws-basic-lab --region ap-southeast-1
sleep 60

# Delete ALB, then target group
aws elbv2 delete-load-balancer --load-balancer-arn "$ALB_ARN" --profile aws-basic-lab --region ap-southeast-1
sleep 30
aws elbv2 delete-target-group --target-group-arn "$TG_ARN" --profile aws-basic-lab --region ap-southeast-1

# Delete launch template
aws ec2 delete-launch-template --launch-template-name "devops-lab-${YOURNAME}-cli-lt" \
  --profile aws-basic-lab --region ap-southeast-1

# Capture snapshot before deregistering the AMI
export SNAP=$(aws ec2 describe-images --image-ids "$GOLDEN_AMI" \
  --query "Images[0].BlockDeviceMappings[0].Ebs.SnapshotId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

# Deregister AMI + delete snapshot
aws ec2 deregister-image --image-id "$GOLDEN_AMI" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-snapshot --snapshot-id "$SNAP" --profile aws-basic-lab --region ap-southeast-1

# Delete SGs
aws ec2 delete-security-group --group-id "$BASE_SG" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-security-group --group-id "$APP_SG" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-security-group --group-id "$ALB_SG" --profile aws-basic-lab --region ap-southeast-1

# Delete key pair and local key
aws ec2 delete-key-pair --key-name "$KEY_NAME" --profile aws-basic-lab --region ap-southeast-1
rm -f "${KEY_NAME}.pem"
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Unhealthy targets | App SG must allow ALB SG on port 80 |
| ALB 503 | No healthy targets - wait or fix nginx |
| ASG not launching | Check launch template and subnet |
| Cannot SSH to base instance | Confirm `BASE_SG` exists and instance has a public IP |
| JSON escape in launch template | Use file:// with JSON file if needed |

---

## 7. What We Achieved

- Built AMI, launch template, ALB, target group, and ASG via CLI
- Tested HTTP via ALB DNS
- Included cleanup for AMI snapshot, SGs, and key material

**Next:** [ecs.md](ecs.md)
