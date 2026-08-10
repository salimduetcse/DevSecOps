# CLI Lab — RDS

Repeat [Console lab 06](../../03-console-labs/06-rds/README.md) using AWS CLI.

> **Cost warning:** RDS bills hourly. Delete same day. Use `db.t3.micro` or `db.t4g.micro`.

---

## 1. Theory Reminder

- **RDS** = managed MySQL/PostgreSQL
- **Not publicly accessible** — EC2 in same VPC connects via **security group**
- SG rule: port 3306 from **EC2 security group** (not 0.0.0.0/0)

---

## 2. Setup Variables

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export YOURNAME="<yourname>"
export DB_ID="devops-lab-${YOURNAME}-cli-mysql"
export DB_USER="admin"
export DB_PASS="<your-strong-password>"
export DB_NAME="devopslab"
export MY_IP=$(curl -s https://checkip.amazonaws.com)/32
```

---

## 3. Resource Creation Commands

### 3.1 Network — default VPC

```bash
export VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true \
  --query "Vpcs[0].VpcId" --output text --profile aws-basic-lab --region ap-southeast-1)

export SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${VPC_ID}" \
  --query "Subnets[*].SubnetId" --output text --profile aws-basic-lab --region ap-southeast-1)
```

### 3.2 DB subnet group

```bash
aws rds create-db-subnet-group \
  --db-subnet-group-name "devops-lab-${YOURNAME}-cli-subnet-grp" \
  --db-subnet-group-description "CLI lab subnet group" \
  --subnet-ids $SUBNET_IDS \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.3 Security groups

```bash
export CLIENT_SG=$(aws ec2 create-security-group \
  --group-name "devops-lab-${YOURNAME}-cli-rds-client-sg" \
  --description "EC2 client for RDS CLI lab" --vpc-id "$VPC_ID" \
  --query GroupId --output text --profile aws-basic-lab --region ap-southeast-1)

aws ec2 authorize-security-group-ingress --group-id "$CLIENT_SG" \
  --protocol tcp --port 22 --cidr "$MY_IP" --profile aws-basic-lab --region ap-southeast-1

export RDS_SG=$(aws ec2 create-security-group \
  --group-name "devops-lab-${YOURNAME}-cli-rds-sg" \
  --description "RDS MySQL from client SG only" --vpc-id "$VPC_ID" \
  --query GroupId --output text --profile aws-basic-lab --region ap-southeast-1)

aws ec2 authorize-security-group-ingress --group-id "$RDS_SG" \
  --protocol tcp --port 3306 --source-group "$CLIENT_SG" \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.4 Launch EC2 client

```bash
export SUBNET_ID=$(echo $SUBNET_IDS | awk '{print $1}')
export AMI_ID=$(aws ec2 describe-images --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

export KEY_NAME="devops-lab-${YOURNAME}-cli-rds-key"
aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type rsa --key-format pem \
  --query KeyMaterial --output text --profile aws-basic-lab --region ap-southeast-1 > "${KEY_NAME}.pem"
chmod 400 "${KEY_NAME}.pem"

export CLIENT_INSTANCE=$(aws ec2 run-instances --image-id "$AMI_ID" --instance-type t3.micro \
  --key-name "$KEY_NAME" --subnet-id "$SUBNET_ID" --security-group-ids "$CLIENT_SG" \
  --associate-public-ip-address \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-cli-rds-client}]" \
  --query "Instances[0].InstanceId" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 wait instance-running --instance-ids "$CLIENT_INSTANCE" --profile aws-basic-lab --region ap-southeast-1
```

### 3.5 Create RDS MySQL

```bash
aws rds create-db-instance \
  --db-instance-identifier "$DB_ID" \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username "$DB_USER" \
  --master-user-password "$DB_PASS" \
  --allocated-storage 20 \
  --db-name "$DB_NAME" \
  --vpc-security-group-ids "$RDS_SG" \
  --db-subnet-group-name "devops-lab-${YOURNAME}-cli-subnet-grp" \
  --no-publicly-accessible \
  --backup-retention-period 0 \
  --no-deletion-protection \
  --tags Key=Project,Value=aws-basic-lab Key=Owner,Value="$YOURNAME" \
  --profile aws-basic-lab --region ap-southeast-1

echo "Waiting for RDS (10-15 min)..."
aws rds wait db-instance-available --db-instance-identifier "$DB_ID" \
  --profile aws-basic-lab --region ap-southeast-1

export DB_ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].Endpoint.Address" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

echo "RDS Endpoint: $DB_ENDPOINT"
```

### 3.6 Connect from EC2

```bash
export CLIENT_IP=$(aws ec2 describe-instances --instance-ids "$CLIENT_INSTANCE" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

ssh -i "${KEY_NAME}.pem" ec2-user@"$CLIENT_IP" << EOF
sudo dnf install -y mariadb105
mysql -h ${DB_ENDPOINT} -u ${DB_USER} -p'${DB_PASS}' -e "SHOW DATABASES;"
mysql -h ${DB_ENDPOINT} -u ${DB_USER} -p'${DB_PASS}' ${DB_NAME} -e \
  "CREATE TABLE cli_test (id INT PRIMARY KEY, msg VARCHAR(50)); INSERT INTO cli_test VALUES (1,'CLI RDS works'); SELECT * FROM cli_test;"
EOF
```

---

## 4. Validation Commands

```bash
aws rds describe-db-instances --db-instance-identifier "$DB_ID" \
  --query "DBInstances[0].{Status:DBInstanceStatus,Endpoint:Endpoint.Address,Public:PubliclyAccessible}" \
  --output table --profile aws-basic-lab --region ap-southeast-1
```

| Field | Expected |
|-------|----------|
| `Status` | `available` |
| `Public` | `False` |

### Snapshot

```bash
export SNAP_ID="devops-lab-${YOURNAME}-cli-rds-snap"

aws rds create-db-snapshot \
  --db-instance-identifier "$DB_ID" \
  --db-snapshot-identifier "$SNAP_ID" \
  --profile aws-basic-lab --region ap-southeast-1

aws rds wait db-snapshot-completed --db-snapshot-identifier "$SNAP_ID" \
  --profile aws-basic-lab --region ap-southeast-1
```

---

## 5. Cleanup Commands

```bash
# Delete RDS (no final snapshot for training)
aws rds delete-db-instance \
  --db-instance-identifier "$DB_ID" \
  --skip-final-snapshot \
  --profile aws-basic-lab --region ap-southeast-1

aws rds wait db-instance-deleted --db-instance-identifier "$DB_ID" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete manual snapshot if created
aws rds delete-db-snapshot --db-snapshot-identifier "$SNAP_ID" \
  --profile aws-basic-lab --region ap-southeast-1 2>/dev/null

# Terminate EC2
aws ec2 terminate-instances --instance-ids "$CLIENT_INSTANCE" --profile aws-basic-lab --region ap-southeast-1
aws ec2 wait instance-terminated --instance-ids "$CLIENT_INSTANCE" --profile aws-basic-lab --region ap-southeast-1

# Delete SGs
aws ec2 delete-security-group --group-id "$RDS_SG" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-security-group --group-id "$CLIENT_SG" --profile aws-basic-lab --region ap-southeast-1

# Delete subnet group
aws rds delete-db-subnet-group --db-subnet-group-name "devops-lab-${YOURNAME}-cli-subnet-grp" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete key
aws ec2 delete-key-pair --key-name "$KEY_NAME" --profile aws-basic-lab --region ap-southeast-1
rm -f "${KEY_NAME}.pem"
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Connection timeout | Check RDS SG allows client SG on 3306 |
| `InvalidParameterCombination` | Engine version — omit or specify supported version |
| Long create time | Normal 10–15 minutes |
| Password special chars | Escape in shell or use simpler lab password |

---

## 7. What We Achieved

- Created RDS MySQL, subnet group, and SG-to-SG access via CLI
- Connected from EC2 and ran SQL
- Snapshot and full cleanup

**Next:** [alb-asg.md](alb-asg.md)
