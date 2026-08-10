# Module 05 — Terraform

## What This Module Teaches

Infrastructure as Code with Terraform after Console and CLI. Same AWS services, automated in `.tf` files.

## Learning Objectives

- Explain IaC and why Terraform follows Console/CLI
- Use provider, resource, data source, variable, output, state
- Run init → fmt → validate → plan → apply → destroy
- Build EC2 through ECS labs with profile `aws-basic-lab` and region `ap-southeast-1`

## Lab Outcome

Seven Terraform lab folders with working starter code and documented workflow.

## Estimated Time

12–15 hours

## Cost Warning

`terraform apply` creates billable resources. **`terraform destroy` every lab.**

## State Warning

> `terraform.tfstate` may contain sensitive data. **Do not commit to Git.** Use root [`.gitignore`](../.gitignore).

## Cleanup Reminder

```bash
terraform destroy
```

in each lab folder. Verify in AWS Console if destroy fails.

**Before starting Terraform labs:** ensure Console and CLI lab resources are deleted. Run [final-cleanup-checklist.md](../06-capstone-project/final-cleanup-checklist.md) if unsure — duplicate stacks triple your bill.

`terraform destroy` removes all resources in that lab's state file, including IAM roles (Lab 07 ECS), DB subnet groups (Lab 05 RDS), and ECR repositories (`force_delete = true` on Lab 07).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-terraform-theory.md](01-terraform-theory.md) | IaC, why Terraform |
| 2 | [02-install-terraform-windows-gitbash.md](02-install-terraform-windows-gitbash.md) | Install |
| 3 | [03-provider-backend-state.md](03-provider-backend-state.md) | Provider, state, backend |
| 4 | [04-terraform-workflow.md](04-terraform-workflow.md) | init/plan/apply/destroy |
| 5 | [05-variable-output-tfvars.md](05-variable-output-tfvars.md) | Variables & outputs |
| 6 | [06-terraform-labs-same-order-as-console.md](06-terraform-labs-same-order-as-console.md) | Lab index |

## Terraform Labs

| Lab | Folder |
|-----|--------|
| EC2 | [labs/01-ec2-default-vpc/](labs/01-ec2-default-vpc/) |
| VPC | [labs/02-custom-vpc-ec2/](labs/02-custom-vpc-ec2/) |
| EBS | [labs/03-ebs/](labs/03-ebs/) |
| S3 | [labs/04-s3/](labs/04-s3/) |
| RDS | [labs/05-rds/](labs/05-rds/) |
| ALB/ASG | [labs/06-alb-asg/](labs/06-alb-asg/) |
| ECS | [labs/07-ecs/](labs/07-ecs/) |
