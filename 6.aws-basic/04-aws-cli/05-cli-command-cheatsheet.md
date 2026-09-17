# AWS CLI Command Cheatsheet

Quick reference for **profile `aws-basic-lab`** and **region `ap-southeast-1`**.

---

## Global Options (Every Command)

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1

# Or per command:
aws <service> <operation> --profile aws-basic-lab --region ap-southeast-1
```

---

## Identity and Account

```bash
aws sts get-caller-identity --profile aws-basic-lab

aws iam get-user --profile aws-basic-lab

aws configure list --profile aws-basic-lab
```

---

## EC2

```bash
# List instances
aws ec2 describe-instances --profile aws-basic-lab --region ap-southeast-1 \
  --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,IP:PublicIpAddress}" \
  --output table

# Latest Amazon Linux 2023 AMI
aws ec2 describe-images --profile aws-basic-lab --region ap-southeast-1 \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" --output text

# Run instance
aws ec2 run-instances --profile aws-basic-lab --region ap-southeast-1 \
  --image-id <ami-id> --instance-type t3.micro --key-name <key-name> \
  --security-group-ids <sg-id> --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=my-instance}]'

# Terminate
aws ec2 terminate-instances --profile aws-basic-lab --region ap-southeast-1 --instance-ids <instance-id>
```

---

## VPC

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --profile aws-basic-lab --region ap-southeast-1
aws ec2 describe-vpcs --profile aws-basic-lab --region ap-southeast-1 --output table
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone ap-southeast-1a
aws ec2 create-internet-gateway --profile aws-basic-lab --region ap-southeast-1
aws ec2 attach-internet-gateway --internet-gateway-id <igw-id> --vpc-id <vpc-id>
```

---

## EBS

```bash
aws ec2 create-volume --size 8 --volume-type gp3 --availability-zone ap-southeast-1a \
  --profile aws-basic-lab --region ap-southeast-1
aws ec2 attach-volume --volume-id <vol-id> --instance-id <i-id> --device /dev/sdf
aws ec2 create-snapshot --volume-id <vol-id> --profile aws-basic-lab --region ap-southeast-1
```

---

## S3

```bash
aws s3 mb s3://<bucket-name> --profile aws-basic-lab --region ap-southeast-1
aws s3 cp ./hello.txt s3://<bucket-name>/labs/hello.txt --profile aws-basic-lab
aws s3 ls s3://<bucket-name>/ --profile aws-basic-lab
aws s3 rb s3://<bucket-name> --force --profile aws-basic-lab
```

---

## RDS

```bash
aws rds describe-db-instances --profile aws-basic-lab --region ap-southeast-1 --output table
aws rds create-db-snapshot --db-instance-identifier <db-id> --db-snapshot-identifier <snap-name> \
  --profile aws-basic-lab --region ap-southeast-1
aws rds delete-db-instance --db-instance-identifier <db-id> --skip-final-snapshot \
  --profile aws-basic-lab --region ap-southeast-1
```

---

## ELB (ALB)

```bash
aws elbv2 describe-load-balancers --profile aws-basic-lab --region ap-southeast-1
aws elbv2 describe-target-health --target-group-arn <tg-arn> --profile aws-basic-lab --region ap-southeast-1
```

---

## ECS / ECR

```bash
aws ecs list-clusters --profile aws-basic-lab --region ap-southeast-1
aws ecs describe-services --cluster <cluster> --services <service> --profile aws-basic-lab --region ap-southeast-1
aws ecr get-login-password --region ap-southeast-1 --profile aws-basic-lab | \
  docker login --username AWS --password-stdin <account>.dkr.ecr.ap-southeast-1.amazonaws.com
```

---

## Useful Modifiers

| Flag | Purpose |
|------|---------|
| `--query` | JMESPath filter |
| `--output table` | Readable table |
| `--output text` | Script-friendly |
| `--dry-run` | Permission check without action |
| `--filters` | Filter describe results |

---

## Get Your Public IP (Security Groups)

```bash
export MY_IP=$(curl -s https://checkip.amazonaws.com)/32
echo $MY_IP
```

---

## Common CLI Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `Unable to locate credentials` | No profile | `aws configure --profile aws-basic-lab` |
| `InvalidClientTokenId` | Bad access key | Recreate key in IAM |
| `AccessDeniedException` | IAM policy | Check admin group / permissions |
| `InvalidParameterValue` | Wrong AZ/AMI | Verify region `ap-southeast-1` |
| `DependencyViolation` | Delete order wrong | Terminate EC2 before SG/VPC |
| `BucketAlreadyExists` | S3 name taken | Use unique bucket suffix |
| `DryRunOperation` | Dry run success | You have permission to run command |
| `UnauthorizedOperation` | Missing ec2:RunInstances | IAM policy issue |
| Wrong region resources | Default region mismatch | Always `--region ap-southeast-1` |
| `aws: command not found` | PATH | Reinstall CLI; fix PATH in Git Bash |
| JSON quoting in Git Bash | Shell escaping | Use single quotes around JSON |

### Debug mode

```bash
aws ec2 describe-instances --profile aws-basic-lab --region ap-southeast-1 --debug 2>&1 | less
```

### Disable pager

```bash
export AWS_PAGER=""
```

---

## Security Reminder

- Never commit `~/.aws/credentials`
- Never put secrets in shell scripts in Git
- Use `.gitignore` for `*.pem`, `.aws/`, `*.csv`

---

## What We Achieved

- Quick reference for all major services
- Troubleshooting guide for common CLI errors

**Next:** [06-cli-labs-same-order-as-console.md](06-cli-labs-same-order-as-console.md)
