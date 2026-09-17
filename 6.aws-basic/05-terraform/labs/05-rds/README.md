# Terraform Lab 05 — RDS

> **Cost warning:** RDS bills hourly. `terraform destroy` same day.

## 1. Architecture

EC2 client SG → RDS MySQL (private) on port 3306.

## 2. Files

`db_password` is **sensitive** — use `TF_VAR_db_password` or local `terraform.tfvars` (gitignored).

## 3. Commands

```bash
cd 05-terraform/labs/05-rds
cp terraform.tfvars.example terraform.tfvars
# Edit password — or: export TF_VAR_db_password='LabPass123!'
terraform init && terraform apply
```

Wait ~10 minutes for RDS.

## 4. Expected Output

`db_endpoint`, `client_public_ip`, `mysql_test_command`

## 5. Validation

```bash
ssh -i *.pem ec2-user@$(terraform output -raw client_public_ip) \
  'sudo dnf install -y mariadb105 && mysql -h '"$(terraform output -raw db_endpoint)"' -u admin -p'
```

## 6. Cleanup

```bash
terraform destroy
```

Removes RDS instance, DB subnet group, EC2 client, security groups, and key pair. `skip_final_snapshot = true` is set in code — no final snapshot left behind.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| RDS slow | Normal 10–15 min first create |
| Connection timeout | SG must allow client SG on 3306 |

## 8. What We Achieved

- RDS + EC2 client wired with security groups in Terraform

**Next:** [../06-alb-asg/](../06-alb-asg/)
