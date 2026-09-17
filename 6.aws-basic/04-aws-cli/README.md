# Module 04 — AWS CLI

## What This Module Teaches

Install and configure the AWS CLI, create access keys safely, and repeat the same labs from Module 03 using command-line workflows.

## Learning Objectives

- Install AWS CLI v2 on Windows (Git Bash)
- Create and manage access keys without exposing secrets in Git
- Configure named profiles and default region (`ap-southeast-1`)
- Map Console actions to CLI commands for EC2, VPC, EBS, S3, RDS, ALB/ASG, ECS

## Lab Outcome

A working CLI profile and command guides that reproduce each console lab. Students can operate AWS from the terminal.

## Estimated Time

10–12 hours (setup + all command labs)

## Cost Warning

**Same as Module 03** — CLI creates the same billable resources. Run cleanup after each command lab. Never paste real access keys into committed files; use placeholders like `AKIAEXAMPLE` and environment variables locally.

## Cleanup Reminder

Each command guide includes **cleanup commands**. Backup: matching console lab [cleanup.md](../03-console-labs/) files. Destroy resources before the next lab.

**Before starting Module 04:** finish all Console lab cleanups (see [06-cli-labs-same-order-as-console.md](06-cli-labs-same-order-as-console.md)). **Before Module 05 Terraform:** run [final-cleanup-checklist.md](../06-capstone-project/final-cleanup-checklist.md) to avoid paying for duplicate stacks.

## Profile and Region

| Setting | Value |
|---------|-------|
| Profile | `aws-basic-lab` |
| Region | `ap-southeast-1` |
| Terminal | **Git Bash** (not PowerShell) |

## Security

- Credentials in `~/.aws/credentials` and `~/.aws/config` only
- Never commit keys — see `.gitignore` in [01-cli-prerequisites.md](01-cli-prerequisites.md)

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-cli-prerequisites.md](01-cli-prerequisites.md) | Prerequisites |
| 2 | [02-install-aws-cli-windows-gitbash.md](02-install-aws-cli-windows-gitbash.md) | Install CLI |
| 3 | [03-create-access-key.md](03-create-access-key.md) | Access keys |
| 4 | [04-aws-configure-profile.md](04-aws-configure-profile.md) | Configure profile |
| 5 | [05-cli-command-cheatsheet.md](05-cli-command-cheatsheet.md) | Cheatsheet |
| 6 | [06-cli-labs-same-order-as-console.md](06-cli-labs-same-order-as-console.md) | Labs overview |

## Command Guides

| Lab | File |
|-----|------|
| EC2 Default VPC | [commands/ec2-default-vpc.md](commands/ec2-default-vpc.md) |
| Custom VPC EC2 | [commands/custom-vpc-ec2.md](commands/custom-vpc-ec2.md) |
| EBS | [commands/ebs.md](commands/ebs.md) |
| S3 | [commands/s3.md](commands/s3.md) |
| RDS | [commands/rds.md](commands/rds.md) |
| ALB + ASG | [commands/alb-asg.md](commands/alb-asg.md) |
| ECS | [commands/ecs.md](commands/ecs.md) |
