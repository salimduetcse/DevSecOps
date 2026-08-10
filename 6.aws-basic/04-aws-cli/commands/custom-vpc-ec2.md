# CLI Lab — Custom VPC EC2

Repeat [Console lab 03](../../03-console-labs/03-custom-vpc-ec2/README.md) using AWS CLI.

---

## 1. Theory Reminder

- **Custom VPC** with CIDR `10.0.0.0/16`
- **Public subnet** `10.0.1.0/24` + **Internet Gateway** + route `0.0.0.0/0`
- **Security group** with SSH from My IP
- **No NAT Gateway** (costly — skip)

---

## 2. Setup Variables

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export AWS_PAGER=""
export YOURNAME="<yourname>"
export VPC_CIDR="10.0.0.0/16"
export PUB_CIDR="10.0.1.0/24"
export AZ="ap-southeast-1a"
export KEY_NAME="devops-lab-${YOURNAME}-vpc-cli-key"
export SG_NAME="devops-lab-${YOURNAME}-vpc-cli-sg"
export MY_IP=$(curl -s https://checkip.amazonaws.com)/32
```

---

## 3. Resource Creation Commands

### 3.1 Create VPC

```bash
export VPC_ID=$(aws ec2 create-vpc \
  --cidr-block "$VPC_CIDR" \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-cli-vpc}]" \
  --query Vpc.VpcId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-support

echo "VPC: $VPC_ID"
```

### 3.2 Create public subnet

```bash
export SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block "$PUB_CIDR" \
  --availability-zone "$AZ" \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-public-1a}]" \
  --query Subnet.SubnetId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 modify-subnet-attribute --subnet-id "$SUBNET_ID" --map-public-ip-on-launch

echo "Subnet: $SUBNET_ID"
```

### 3.3 Internet Gateway

```bash
export IGW_ID=$(aws ec2 create-internet-gateway \
  --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-cli-igw}]" \
  --query InternetGateway.InternetGatewayId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 attach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID" \
  --profile aws-basic-lab --region ap-southeast-1

echo "IGW: $IGW_ID"
```

### 3.4 Route table

```bash
export RT_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-public-rt}]" \
  --query RouteTable.RouteTableId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 create-route \
  --route-table-id "$RT_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID" \
  --profile aws-basic-lab --region ap-southeast-1

aws ec2 associate-route-table \
  --route-table-id "$RT_ID" \
  --subnet-id "$SUBNET_ID" \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.5 Security group

```bash
export SG_ID=$(aws ec2 create-security-group \
  --group-name "$SG_NAME" \
  --description "CLI custom VPC lab" \
  --vpc-id "$VPC_ID" \
  --query GroupId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 22 --cidr "$MY_IP" \
  --profile aws-basic-lab --region ap-southeast-1
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 80 --cidr "$MY_IP" \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.6 Key pair + launch EC2

```bash
aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --key-format pem \
  --query KeyMaterial --output text --profile aws-basic-lab --region ap-southeast-1 > "${KEY_NAME}.pem"
chmod 400 "${KEY_NAME}.pem"

export AMI_ID=$(aws ec2 describe-images --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" --instance-type t3.micro --key-name "$KEY_NAME" \
  --subnet-id "$SUBNET_ID" --security-group-ids "$SG_ID" \
  --associate-public-ip-address \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-vpc-cli-web}]" \
  --query "Instances[0].InstanceId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --profile aws-basic-lab --region ap-southeast-1

export PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text \
  --profile aws-basic-lab --region ap-southeast-1)
```

### 3.7 nginx

```bash
ssh -i "${KEY_NAME}.pem" ec2-user@"$PUBLIC_IP" 'sudo dnf install -y nginx && sudo systemctl start nginx && curl -s localhost | head -3'
curl -s "http://${PUBLIC_IP}" | head -5
```

---

## 4. Validation Commands

```bash
aws ec2 describe-vpcs --vpc-ids "$VPC_ID" \
  --query "Vpcs[0].{ID:VpcId,CIDR:CidrBlock}" --output table \
  --profile aws-basic-lab --region ap-southeast-1

aws ec2 describe-route-tables --route-table-ids "$RT_ID" \
  --query "RouteTables[0].Routes" --profile aws-basic-lab --region ap-southeast-1

aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].{VpcId:VpcId,SubnetId:SubnetId,IP:PublicIpAddress}" \
  --output table --profile aws-basic-lab --region ap-southeast-1
```

| Field | Expected |
|-------|----------|
| VPC CIDR | `10.0.0.0/16` |
| Route | `0.0.0.0/0` → `igw-...` |
| Instance VPC | Your custom VPC ID |

---

## 5. Cleanup Commands

```bash
# Terminate EC2
aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" --profile aws-basic-lab --region ap-southeast-1
aws ec2 wait instance-terminated --instance-ids "$INSTANCE_ID" --profile aws-basic-lab --region ap-southeast-1

# Delete SG
aws ec2 delete-security-group --group-id "$SG_ID" --profile aws-basic-lab --region ap-southeast-1

# Delete key
aws ec2 delete-key-pair --key-name "$KEY_NAME" --profile aws-basic-lab --region ap-southeast-1
rm -f "${KEY_NAME}.pem"

# Disassociate and delete route table (get association id first)
export ASSOC_ID=$(aws ec2 describe-route-tables --route-table-ids "$RT_ID" \
  --query "RouteTables[0].Associations[?SubnetId=='${SUBNET_ID}'].RouteTableAssociationId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)
aws ec2 disassociate-route-table --association-id "$ASSOC_ID" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-route-table --route-table-id "$RT_ID" --profile aws-basic-lab --region ap-southeast-1

# Delete subnet
aws ec2 delete-subnet --subnet-id "$SUBNET_ID" --profile aws-basic-lab --region ap-southeast-1

# Detach and delete IGW
aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID" \
  --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete VPC
aws ec2 delete-vpc --vpc-id "$VPC_ID" --profile aws-basic-lab --region ap-southeast-1
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `DependencyViolation` on VPC | Delete EC2, IGW, subnets, RT first |
| No internet on instance | Check IGW route and `map-public-ip-on-launch` |
| Cannot delete IGW | Detach from VPC first |

---

## 7. What We Achieved

- Built custom VPC stack entirely via CLI
- Launched EC2, tested nginx, validated routing
- Deleted all resources in correct order

**Next:** [ebs.md](ebs.md)
