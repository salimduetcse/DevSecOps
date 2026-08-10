# CLI Labs — Same Order as Console

## Overview

Repeat **Module 03 Console labs** using **AWS CLI** in **Git Bash**. Same services, same order, same region.

| # | Console Lab | CLI Guide |
|---|-------------|-----------|
| 1 | IAM (setup) | Lessons 01–04 in this module |
| 2 | EC2 default VPC | [commands/ec2-default-vpc.md](commands/ec2-default-vpc.md) |
| 3 | Custom VPC EC2 | [commands/custom-vpc-ec2.md](commands/custom-vpc-ec2.md) |
| 4 | EBS | [commands/ebs.md](commands/ebs.md) |
| 5 | S3 | [commands/s3.md](commands/s3.md) |
| 6 | RDS | [commands/rds.md](commands/rds.md) |
| 7 | ALB + ASG | [commands/alb-asg.md](commands/alb-asg.md) |
| 8 | ECS | [commands/ecs.md](commands/ecs.md) |

---

## Before Every Lab

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export AWS_PAGER=""

aws sts get-caller-identity --profile aws-basic-lab
```

---

## Lab Rules

1. **One lab at a time** — run cleanup before starting next
2. **Region:** `ap-southeast-1` always
3. **Profile:** `aws-basic-lab` always
4. **SSH:** still use Git Bash + `.pem` for EC2 access
5. **Cost:** same warnings as Console — terminate/delete same day
6. **Naming:** `devops-lab-<yourname>-*`

---

## Each CLI Lab Includes

1. Theory reminder
2. Resource creation commands
3. Validation commands
4. Output explanation
5. Cleanup commands
6. Troubleshooting
7. What we achieved

---

## Suggested Schedule

| Day | Lab | Est. Time |
|-----|-----|-----------|
| 1 | Setup + EC2 default VPC | 2–3 hrs |
| 2 | Custom VPC | 3–4 hrs |
| 3 | EBS + S3 | 2–3 hrs |
| 4 | RDS | 2–3 hrs |
| 5 | ALB + ASG | 3–4 hrs |
| 6 | ECS | 3–4 hrs |

---

## Console vs CLI

| Task | Console | CLI |
|------|---------|-----|
| Learn visually | ✅ Best | Secondary |
| Automation / CI/CD | Manual | ✅ Best |
| Repeatability | Click-heavy | ✅ Scriptable |
| This course | Module 03 first | Module 04 second |

Module 05 **Terraform** automates the same flow again.

---

## Cost Warning

CLI labs create **real resources**. Every command guide ends with **cleanup commands**. If cleanup fails, use matching [03-console-labs cleanup](../03-console-labs/) as backup.

## Cleanup Between Modules (Console → CLI → Terraform)

The same services are taught three times. **Do not start Module 04 CLI labs while Console lab resources are still running** — you will duplicate cost.

1. Finish a Console sub-lab → run its `cleanup.md`
2. Before starting Module 04, verify zero lab resources (or run [final-cleanup-checklist.md](../06-capstone-project/final-cleanup-checklist.md))
3. Repeat before Module 05 Terraform

**Exception (Console only):** Defer [Lab 02 cleanup](../03-console-labs/02-ec2-default-vpc/cleanup.md) until after [Lab 04 EBS](../03-console-labs/04-ebs/cleanup.md) — Lab 04 reuses that EC2.

---

## What We Achieved

- Mapped Console lab order to CLI command guides
- Ready to start hands-on CLI labs

**Start here:** [commands/ec2-default-vpc.md](commands/ec2-default-vpc.md)
