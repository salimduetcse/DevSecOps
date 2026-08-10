# Provider, Backend, and State

## Learning Goal

Understand **provider**, **resource**, **data source**, **state**, and **backend** - the core Terraform building blocks.

---

## 1. Provider

The **provider** plugin talks to AWS APIs.

```hcl
# versions.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# main.tf
provider "aws" {
  region  = var.aws_region   # ap-southeast-1
  profile = var.aws_profile  # aws-basic-lab
}
```

---

## 2. Resource

A **resource** is something Terraform **creates and manages**.

```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
}
```

Format: `resource "<TYPE>" "<NAME>" { ... }`

---

## 3. Data Source

A **data source** reads **existing** information without creating it.

```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
```

Use data sources for: default VPC, latest AMI, current account ID.

---

## 4. State File

Terraform stores a mapping of your code -> real AWS resource IDs in **`terraform.tfstate`**.

| Why state matters |
|-------------------|
| Knows what it created last apply |
| Plans updates vs creates |
| Tracks dependencies |

> **Warning:** State may contain sensitive values. **Never commit to Git.** Listed in [`.gitignore`](../.gitignore).

---

## 5. Backend

**Backend** = where state is stored.

| Backend | Use |
|---------|-----|
| **local** (default) | `terraform.tfstate` in lab folder - OK for training |
| **s3** (advanced) | Team production - remote state, access control, encryption, and locking |

Labs use **local backend** (no extra config). Default:

```hcl
# Implicit - state file in current directory
```

Production example (reference only):

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "aws-basic/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
```

Minimum production expectations for remote state:

- State stored outside a developer laptop
- Encryption enabled for the state store
- Access restricted to the deployment identity/team
- State locking enabled to prevent concurrent writes
- Versioning/backup strategy for recovery

---

## 6. Resource vs Data Source

| | Resource | Data Source |
|---|----------|-------------|
| Creates? | Yes | No |
| Example | `aws_instance` | `aws_ami` |
| Keyword | `resource` | `data` |

---

## State Security Checklist

- [ ] `*.tfstate` in `.gitignore`
- [ ] Do not share state in Slack/email
- [ ] Use `terraform.tfvars.example` - not real `terraform.tfvars` in Git

---

## Interview Questions

1. **What is Terraform state?** - *JSON mapping of resources Terraform manages.*
2. **Why use data sources?** - *Reference existing AWS objects without hardcoding IDs.*

---

## What We Achieved

- Understood provider, resource, data source, state, backend

**Next:** [05-variable-output-tfvars.md](05-variable-output-tfvars.md)
