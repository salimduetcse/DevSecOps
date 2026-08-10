# Lab Naming Convention

## Learning Goal

Use **consistent names and tags** so you (and your instructor) can find, manage, and **delete** lab resources quickly.

---

## Naming Pattern

```
devops-lab-<yourname>-<resource-type>
```

Replace `<yourname>` with a short lowercase identifier (e.g. `faizul`, `sara`, `student01`).

### Examples

| Resource | Name |
|----------|------|
| IAM user | `devops-lab-faizul-user` |
| EC2 instance | `devops-lab-faizul-web` |
| Security group | `devops-lab-faizul-ec2-sg` |
| VPC | `devops-lab-faizul-vpc` |
| S3 bucket | `devops-lab-faizul-bucket-2026a` (must be globally unique) |
| RDS | `devops-lab-faizul-mysql` |
| ECS cluster | `devops-lab-faizul-cluster` |

### Terraform / CLI suffix

Automation labs may add suffixes:

```
devops-lab-faizul-tf-web      # Terraform EC2 lab
devops-lab-faizul-cli-key     # CLI lab key pair
```

---

## Required Tags

Apply to every resource that supports tags:

| Key | Value | Purpose |
|-----|-------|---------|
| `Project` | `aws-basic` or `aws-basic-lab` | Filter all course resources |
| `Owner` | `<yourname>` | Who owns this resource |
| `Environment` | `training` | Not production |

### Console tagging

At resource creation, add tags in the **Tags** section.

### Terraform tagging

This course uses `default_tags` in the provider block:

```hcl
default_tags {
  tags = {
    Project     = "aws-basic"
    Owner       = "devops-student"
    Environment = "training"
  }
}
```

Override `Owner` in `terraform.tfvars` with your name where variables allow.

---

## Placeholder Values in Docs

Course materials use placeholders — **never copy real secrets from examples**.

| Placeholder | Replace with |
|-------------|--------------|
| `<yourname>` | Your short name |
| `<yourname>-user` | Your IAM username |
| `<PUBLIC_IP>` | EC2 public IP from Console |
| `<ACCOUNT_ID>` | 12-digit AWS account ID |
| `AKIAIOSFODNN7EXAMPLE` | Fake access key (AWS docs example) |
| `YOUR_PUBLIC_IP/32` | Your IP from `curl https://checkip.amazonaws.com` |
| `<your-bucket-name>` | Globally unique S3 bucket name |
| `<your-strong-password>` | Local password — not in Git |

---

## S3 Bucket Naming Rules

S3 bucket names are **globally unique** across all AWS customers.

| Rule | Example |
|------|---------|
| Lowercase only | `devops-lab-faizul-bucket` |
| Add random suffix | `devops-lab-faizul-bucket-x7k2` |
| 3–63 characters | Keep reasonable length |
| No underscores | Use hyphens |

Get your public IP for security groups:

```bash
curl -s https://checkip.amazonaws.com
# Use as 203.0.113.45/32 in SG rules
```

---

## IAM Naming

| Item | Convention |
|------|------------|
| Lab user | `devops-lab-<yourname>-user` |
| Admin group | `devops-lab-admin-group` (shared in training account) |
| CLI profile | `aws-basic-lab` (in `~/.aws/config`) |

---

## Key Pair and Local Files

| File | Store location | Git? |
|------|----------------|------|
| `devops-lab-<yourname>-key.pem` | `~/.ssh/` or lab folder | **Never** |
| `terraform.tfstate` | Lab folder | **Never** |
| `terraform.tfvars` | Lab folder | **Never** |
| `terraform.tfvars.example` | Repo | Yes (no secrets) |

---

## Finding Your Resources in Console

1. Use service search filter: `devops-lab`
2. Or filter by tag: `Project = aws-basic`
3. Always check region **`ap-southeast-1`** (top right)

```bash
# CLI example — list your tagged instances
aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=aws-basic" \
  --query "Reservations[].Instances[].{Name:Tags[?Key=='Name']|[0].Value,Id:InstanceId,State:State.Name}" \
  --output table \
  --profile aws-basic-lab \
  --region ap-southeast-1
```

---

## Cleanup Naming Reminder

Before deleting, confirm the name matches **your** prefix:

- ✅ `devops-lab-faizul-web` — yours
- ❌ `devops-lab-otherstudent-web` — not yours

When in doubt, check tag `Owner`.

---

## Interview-Style Questions

1. **Why use a naming convention?**
   - *Find and delete resources quickly; avoid orphan costs.*

2. **Why tag resources?**
   - *Cost allocation, ownership, and bulk filtering.*

3. **Why S3 bucket needs unique name?**
   - *S3 namespace is global across all AWS accounts.*

---

## References to Verify

- [AWS Tagging Best Practices](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/welcome.html)
- [S3 Bucket Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

---

**Module 00 complete.** Continue to [01-cloud-fundamentals](../01-cloud-fundamentals/README.md).
