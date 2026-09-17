# Terraform Lab 05 — MySQL Flexible Server

> **Cost warning:** MySQL Flexible Server bills hourly. `terraform destroy` same day.

## 1. Architecture

VM client → MySQL Flexible Server (public access) on port 3306, guarded by firewall rules.

## 2. Files

`db_password` is **sensitive** — use `TF_VAR_db_password` or local `terraform.tfvars` (gitignored).

## 3. Commands

```bash
cd 05-terraform/labs/05-mysql
cp terraform.tfvars.example terraform.tfvars
# Edit password — or: export TF_VAR_db_password='LabPass123!'
terraform init && terraform apply
```

Wait ~10 minutes for MySQL Flexible Server.

## 4. Expected Output

`db_fqdn`, `client_public_ip`, `mysql_test_command`

## 5. Validation

```bash
ssh -i *.pem azureuser@$(terraform output -raw client_public_ip) \
  'sudo apt-get update -y && sudo apt-get install -y mysql-client && mysql -h '"$(terraform output -raw db_fqdn)"' -u adminuser -p'
```

## 6. Cleanup

```bash
terraform destroy
```

Removes MySQL Flexible Server, database, firewall rules, VM client, and Resource Group. Destroy the same day to avoid unexpected cost.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| MySQL slow | Normal 10–15 min first create |
| Connection timeout | Firewall must allow client Public IP on 3306 |
| Password policy | 8+ chars with upper, lower, number, special |

## 8. What We Achieved

- MySQL Flexible Server + VM client wired with firewall rules in Terraform

**Next:** [../06-lb-vmss/](../06-lb-vmss/)
