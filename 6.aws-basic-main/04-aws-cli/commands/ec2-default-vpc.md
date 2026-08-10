# CLI Lab — EC2 Default VPC

Repeat [Console lab 02](../../03-console-labs/02-ec2-default-vpc/README.md) using AWS CLI in Git Bash.

---

## 1. Theory Reminder

- **EC2** = virtual server in a **VPC**
- **Default VPC** has internet gateway and public subnets pre-configured
- **Security group** = firewall — use **My IP** for SSH, not `0.0.0.0/0`
- **Key pair** = SSH authentication

---

## 2. Setup Variables

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export AWS_PAGER=""
export YOURNAME="<yourname>"
export KEY_NAME="devops-lab-${YOURNAME}-cli-key"
export SG_NAME="devops-lab-${YOURNAME}-cli-ec2-sg"
export INSTANCE_NAME="devops-lab-${YOURNAME}-cli-web"
export MY_IP=$(curl -s https://checkip.amazonaws.com)/32

echo "My IP: $MY_IP"
aws sts get-caller-identity --profile aws-basic-lab
```

---

## 3. Resource Creation Commands

### 3.1 Get default VPC and subnet

```bash
export VPC_ID=$(aws ec2 describe-vpcs \
  --filters Name=isDefault,Values=true \
  --query "Vpcs[0].VpcId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=${VPC_ID}" "Name=default-for-az,Values=true" \
  --query "Subnets[0].SubnetId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

echo "VPC: $VPC_ID  Subnet: $SUBNET_ID"
```

### 3.2 Create key pair (saves .pem locally)

```bash
aws ec2 create-key-pair \
  --key-name "$KEY_NAME" \
  --key-type rsa \
  --key-format pem \
  --query KeyMaterial --output text \
  --profile aws-basic-lab --region ap-southeast-1 > "${KEY_NAME}.pem"

chmod 400 "${KEY_NAME}.pem"
ls -la "${KEY_NAME}.pem"
```

### 3.3 Create security group

```bash
export SG_ID=$(aws ec2 create-security-group \
  --group-name "$SG_NAME" \
  --description "CLI lab SG SSH and HTTP from My IP" \
  --vpc-id "$VPC_ID" \
  --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

echo "Security Group: $SG_ID"
```

### 3.4 Add inbound rules (SSH + HTTP from My IP only)

```bash
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp --port 22 --cidr "$MY_IP" \
  --profile aws-basic-lab --region ap-southeast-1

aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp --port 80 --cidr "$MY_IP" \
  --profile aws-basic-lab --region ap-southeast-1
```

> **Security:** We use `$MY_IP/32` — not `0.0.0.0/0` for SSH.

### 3.5 Get latest Amazon Linux 2023 AMI

```bash
export AMI_ID=$(aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

echo "AMI: $AMI_ID"
```

### 3.6 Launch instance

```bash
export INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type t3.micro \
  --key-name "$KEY_NAME" \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SG_ID" \
  --associate-public-ip-address \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}},{Key=Project,Value=aws-basic-lab}]" \
  --query "Instances[0].InstanceId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

echo "Instance ID: $INSTANCE_ID"
```

### 3.7 Wait until running

```bash
aws ec2 wait instance-running \
  --instance-ids "$INSTANCE_ID" \
  --profile aws-basic-lab --region ap-southeast-1

export PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

echo "Public IP: $PUBLIC_IP"
```

### 3.8 SSH and install nginx

```bash
ssh -i "${KEY_NAME}.pem" -o StrictHostKeyChecking=accept-new ec2-user@"$PUBLIC_IP" << 'EOF'
sudo dnf install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>CLI Lab EC2 — devops-lab</h1>" | sudo tee /usr/share/nginx/html/index.html
curl -s localhost | head -5
EOF
```

---

## 4. Validation Commands

```bash
# Instance state
aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].{State:State.Name,IP:PublicIpAddress,Type:InstanceType}" \
  --output table \
  --profile aws-basic-lab --region ap-southeast-1

# Security group rules
aws ec2 describe-security-groups \
  --group-ids "$SG_ID" \
  --query "SecurityGroups[0].IpPermissions" \
  --profile aws-basic-lab --region ap-southeast-1

# HTTP test from laptop (Git Bash)
curl -s "http://${PUBLIC_IP}" | head -5
```

### Output explanation

| Output | Meaning |
|--------|---------|
| `State: running` | Instance is up |
| `PublicIpAddress` | SSH and browser target |
| SG `IpPermissions` port 22 | SSH allowed from your IP CIDR |
| curl HTML | nginx responding on port 80 |

---

## 5. Cleanup Commands

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1

# Terminate instance
aws ec2 terminate-instances \
  --instance-ids "$INSTANCE_ID" \
  --profile aws-basic-lab --region ap-southeast-1

aws ec2 wait instance-terminated \
  --instance-ids "$INSTANCE_ID" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete security group
aws ec2 delete-security-group \
  --group-id "$SG_ID" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete key pair (AWS side)
aws ec2 delete-key-pair \
  --key-name "$KEY_NAME" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete local pem
rm -f "${KEY_NAME}.pem"

# Verify no instance
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${INSTANCE_NAME}" \
  --query "Reservations[].Instances[].State.Name" \
  --profile aws-basic-lab --region ap-southeast-1
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `InvalidGroup.Duplicate` | SG name exists — use new name or delete old SG |
| SSH timeout | Update SG with new `MY_IP`; check instance running |
| No public IP | Add `--associate-public-ip-address` on run-instances |
| `UnauthorizedOperation` | Check IAM permissions |
| AMI empty | Verify region `ap-southeast-1` |

---

## 7. What We Achieved

- Created key pair, security group, and EC2 instance via CLI
- Installed nginx over SSH
- Validated with `describe-instances` and `curl`
- Cleaned up all resources with CLI commands

**Next:** [custom-vpc-ec2.md](custom-vpc-ec2.md)
