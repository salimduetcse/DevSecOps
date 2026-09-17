# Terraform Lab 04 - Blob Storage

## 1. Architecture

Private Storage Account with container, sample blob, versioning enabled, anonymous public access disabled.

## 2. Files

`random_string` ensures a globally unique storage account name (lowercase alphanumeric only).

## 3. Commands

```bash
cd 05-terraform/labs/04-blob-storage
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: set student_name and subscription_id
#   az account show --query id -o tsv
terraform init && terraform apply
```

> **azurerm 4.x:** this lab requires `subscription_id` in `terraform.tfvars` (or env `ARM_SUBSCRIPTION_ID`).

## 4. Expected Output

`storage_account_name`, `container_name`, `list_command` outputs.

## 5. Validation

```bash
terraform output -raw list_command | bash
az storage blob download \
  --account-name $(terraform output -raw storage_account_name) \
  --container-name $(terraform output -raw container_name) \
  --name labs/hello.txt \
  --file - \
  --auth-mode login
```

## 6. Cleanup

```bash
terraform destroy
```

Terraform removes the sample blob, container, and storage account as part of destroy. Appropriate for a disposable training lab, not for production accounts.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| Storage name already taken | `random_string` regenerates on replace; destroy and re-apply |
| Auth for az storage | Use `--auth-mode login` after `az login`, or account key from `az storage account keys list` |

## 8. What We Achieved

- Storage account + blob as code with security defaults

**Next:** [../05-mysql/](../05-mysql/)
