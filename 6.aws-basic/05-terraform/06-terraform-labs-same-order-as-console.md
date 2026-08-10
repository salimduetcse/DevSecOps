# Terraform Labs — Same Order as Console

| # | Console / CLI Lab | Terraform Folder |
|---|-------------------|------------------|
| 1 | EC2 default VPC | [labs/01-ec2-default-vpc/](labs/01-ec2-default-vpc/) |
| 2 | Custom VPC EC2 | [labs/02-custom-vpc-ec2/](labs/02-custom-vpc-ec2/) |
| 3 | EBS | [labs/03-ebs/](labs/03-ebs/) |
| 4 | S3 | [labs/04-s3/](labs/04-s3/) |
| 5 | RDS | [labs/05-rds/](labs/05-rds/) |
| 6 | ALB + ASG | [labs/06-alb-asg/](labs/06-alb-asg/) |
| 7 | ECS | [labs/07-ecs/](labs/07-ecs/) |

## Every Lab Folder Contains

- `README.md` — architecture, commands, validation, cleanup
- `versions.tf` — provider + profile
- `variables.tf` — inputs
- `main.tf` — resources
- `outputs.tf` — results
- `terraform.tfvars.example` — copy to `terraform.tfvars` (gitignored)

## Standard Workflow

```bash
export AWS_PROFILE=aws-basic-lab
cd labs/01-ec2-default-vpc
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform fmt && terraform validate
terraform plan && terraform apply
terraform destroy
```

## State Warning

> **Never commit `terraform.tfstate`** — see [`.gitignore`](../.gitignore).

## Cost Warning

Same as Console — destroy every lab when finished.

## Cleanup Between Modules

Console (Module 03) and CLI (Module 04) teach the same services manually first. **Run all Console `cleanup.md` files (and the final checklist) before `terraform apply` in Module 05** unless you intend to run parallel stacks and accept duplicate charges.

Each lab folder's `terraform destroy` removes every resource defined in that folder's `.tf` files.
