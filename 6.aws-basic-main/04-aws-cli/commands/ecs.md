# CLI Lab — ECS

Repeat [Console lab 08](../../03-console-labs/08-ecs/README.md) using AWS CLI + Docker in Git Bash.

> **Cost warning:** Fargate + ALB — delete same day.

---

## 1. Theory Reminder

- **ECR** stores Docker images
- **ECS cluster** (Fargate) runs **tasks** defined by **task definition**
- **Service** keeps tasks running; **ALB** routes HTTP traffic

---

## 2. Setup Variables

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export YOURNAME="<yourname>"
export CLUSTER="devops-lab-${YOURNAME}-cli-cluster"
export SERVICE="devops-lab-${YOURNAME}-cli-service"
export TASK_FAMILY="devops-lab-${YOURNAME}-cli-task"
export ECR_REPO="devops-lab-${YOURNAME}-cli-app"
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile aws-basic-lab)
export ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
export LOG_GROUP="/ecs/devops-lab-${YOURNAME}-cli"
```

---

## 3. Resource Creation Commands

### 3.1 Create ECR repository

```bash
aws ecr create-repository \
  --repository-name "$ECR_REPO" \
  --image-scanning-configuration scanOnPush=false \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.2 Build and push image (local Docker)

```bash
mkdir -p /tmp/ecs-cli-lab && cd /tmp/ecs-cli-lab
echo '<h1>ECS CLI Lab — devops-lab</h1>' > index.html
cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF

docker build -t "${ECR_REPO}:latest" .

aws ecr get-login-password --region ap-southeast-1 --profile aws-basic-lab | \
  docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

docker tag "${ECR_REPO}:latest" "${ECR_URI}:latest"
docker push "${ECR_URI}:latest"
```

### 3.3 Create ECS cluster

```bash
aws ecs create-cluster \
  --cluster-name "$CLUSTER" \
  --capacity-providers FARGATE FARGATE_SPOT \
  --default-capacity-provider-strategy capacityProvider=FARGATE,weight=1 \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.4 Network — default VPC

```bash
export VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true \
  --query "Vpcs[0].VpcId" --output text --profile aws-basic-lab --region ap-southeast-1)
export SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${VPC_ID}" \
  --query "Subnets[0:2].SubnetId" --output text --profile aws-basic-lab --region ap-southeast-1)
export SUBNET1=$(echo $SUBNETS | awk '{print $1}')
export SUBNET2=$(echo $SUBNETS | awk '{print $2}')

export ALB_SG=$(aws ec2 create-security-group --group-name "devops-lab-${YOURNAME}-cli-ecs-alb-sg" \
  --description "ECS ALB" --vpc-id "$VPC_ID" --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)
aws ec2 authorize-security-group-ingress --group-id "$ALB_SG" --protocol tcp --port 80 --cidr 0.0.0.0/0 \
  --profile aws-basic-lab --region ap-southeast-1

export ECS_SG=$(aws ec2 create-security-group --group-name "devops-lab-${YOURNAME}-cli-ecs-sg" \
  --description "ECS tasks" --vpc-id "$VPC_ID" --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)
aws ec2 authorize-security-group-ingress --group-id "$ECS_SG" --protocol tcp --port 80 --source-group "$ALB_SG" \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.5 Create IAM role for task execution (if missing)

```bash
# Check if ecsTaskExecutionRole exists
aws iam get-role --role-name ecsTaskExecutionRole --profile aws-basic-lab 2>/dev/null || \
  echo "Create ecsTaskExecutionRole in Console: IAM → Roles → ECS task execution role"

export EXEC_ROLE_ARN=$(aws iam get-role --role-name ecsTaskExecutionRole \
  --query Role.Arn --output text --profile aws-basic-lab)
```

### 3.6 Register task definition

```bash
cat > /tmp/task-def.json << EOF
{
  "family": "${TASK_FAMILY}",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "${EXEC_ROLE_ARN}",
  "containerDefinitions": [
    {
      "name": "web",
      "image": "${ECR_URI}:latest",
      "essential": true,
      "portMappings": [{"containerPort": 80, "protocol": "tcp"}]
    }
  ]
}
EOF

aws ecs register-task-definition \
  --cli-input-json file:///tmp/task-def.json \
  --profile aws-basic-lab --region ap-southeast-1

rm -f /tmp/task-def.json
```

### 3.7 ALB + target group

```bash
export TG_ARN=$(aws elbv2 create-target-group \
  --name "devops-lab-${YOURNAME}-cli-ecs-tg" \
  --protocol HTTP --port 80 --vpc-id "$VPC_ID" \
  --target-type ip --health-check-path / \
  --query TargetGroups[0].TargetGroupArn --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export ALB_ARN=$(aws elbv2 create-load-balancer \
  --name "devops-lab-${YOURNAME}-cli-ecs-alb" \
  --subnets "$SUBNET1" "$SUBNET2" \
  --security-groups "$ALB_SG" \
  --scheme internet-facing --type application \
  --query LoadBalancers[0].LoadBalancerArn --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export LISTENER_ARN=$(aws elbv2 create-listener \
  --load-balancer-arn "$ALB_ARN" \
  --protocol HTTP --port 80 \
  --default-actions Type=forward,TargetGroupArn="$TG_ARN" \
  --query Listeners[0].ListenerArn --output text \
  --profile aws-basic-lab --region ap-southeast-1)
```

### 3.8 Create ECS service

```bash
aws ecs create-service \
  --cluster "$CLUSTER" \
  --service-name "$SERVICE" \
  --task-definition "$TASK_FAMILY" \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[${SUBNET1},${SUBNET2}],securityGroups=[${ECS_SG}],assignPublicIp=ENABLED}" \
  --load-balancers "targetGroupArn=${TG_ARN},containerName=web,containerPort=80" \
  --health-check-grace-period-seconds 60 \
  --profile aws-basic-lab --region ap-southeast-1

echo "Wait 3-5 minutes for tasks healthy..."
sleep 240
```

### 3.9 Test

```bash
export ALB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ALB_ARN" \
  --query "LoadBalancers[0].DNSName" --output text --profile aws-basic-lab --region ap-southeast-1)

curl -s "http://${ALB_DNS}" | head -5
```

---

## 4. Validation Commands

```bash
aws ecs describe-services --cluster "$CLUSTER" --services "$SERVICE" \
  --query "services[0].{Status:status,Running:runningCount,Desired:desiredCount}" \
  --output table --profile aws-basic-lab --region ap-southeast-1

aws elbv2 describe-target-health --target-group-arn "$TG_ARN" \
  --query "TargetHealthDescriptions[].TargetHealth.State" \
  --output text --profile aws-basic-lab --region ap-southeast-1

aws ecr describe-images --repository-name "$ECR_REPO" \
  --query "imageDetails[0].imageTags" --profile aws-basic-lab --region ap-southeast-1
```

| Output | Expected |
|--------|----------|
| `runningCount` | `2` |
| Target health | `healthy healthy` |
| curl | HTML from container |

---

## 5. Cleanup Commands

```bash
# Scale down and delete service
aws ecs update-service --cluster "$CLUSTER" --service "$SERVICE" --desired-count 0 \
  --profile aws-basic-lab --region ap-southeast-1
sleep 60

aws ecs delete-service --cluster "$CLUSTER" --service "$SERVICE" --force \
  --profile aws-basic-lab --region ap-southeast-1

# Delete ALB
aws elbv2 delete-load-balancer --load-balancer-arn "$ALB_ARN" --profile aws-basic-lab --region ap-southeast-1
sleep 30
aws elbv2 delete-target-group --target-group-arn "$TG_ARN" --profile aws-basic-lab --region ap-southeast-1

# Delete cluster
aws ecs delete-cluster --cluster "$CLUSTER" --profile aws-basic-lab --region ap-southeast-1

# Deregister task definitions (list revisions)
for REV in $(aws ecs list-task-definitions --family-prefix "$TASK_FAMILY" \
  --query "taskDefinitionArns[]" --output text --profile aws-basic-lab --region ap-southeast-1); do
  aws ecs deregister-task-definition --task-definition "$REV" --profile aws-basic-lab --region ap-southeast-1
done

# Delete ECR images and repo
aws ecr batch-delete-image --repository-name "$ECR_REPO" \
  --image-ids imageTag=latest --profile aws-basic-lab --region ap-southeast-1
aws ecr delete-repository --repository-name "$ECR_REPO" --force \
  --profile aws-basic-lab --region ap-southeast-1

# Delete CloudWatch log group (if logging was enabled in task definition)
aws logs delete-log-group --log-group-name "$LOG_GROUP" \
  --profile aws-basic-lab --region ap-southeast-1 2>/dev/null || true

# Delete SGs
aws ec2 delete-security-group --group-id "$ECS_SG" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-security-group --group-id "$ALB_SG" --profile aws-basic-lab --region ap-southeast-1
```

> Backup: [03-console-labs/08-ecs/cleanup.md](../../03-console-labs/08-ecs/cleanup.md)

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `CannotPullContainerError` | Check execution role ECR permissions |
| Tasks unhealthy | SG must allow ALB → ECS on 80 |
| `AssignPublicIp=ENABLED` needed | Fargate in default VPC without NAT |
| Docker login fail | Run `aws configure --profile aws-basic-lab` |
| exec role missing | Create **ecsTaskExecutionRole** in IAM Console |

---

## 7. What We Achieved

- ECR push, ECS Fargate cluster, task definition, service, and ALB via CLI
- Validated running tasks and HTTP endpoint
- Complete cleanup of container stack (service, ALB, ECR, log group, security groups)

**CLI module complete!** Next: [05-terraform](../../05-terraform/README.md)
