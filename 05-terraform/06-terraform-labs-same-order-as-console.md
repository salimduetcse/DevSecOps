# Terraform Labs — Same Order as Portal

| # | Portal / CLI Lab | Terraform Folder |
|---|------------------|------------------|
| 1 | VM lab network | [labs/01-vm-default-vnet/](labs/01-vm-default-vnet/) |
| 2 | Custom VNet VM | [labs/02-custom-vnet-vm/](labs/02-custom-vnet-vm/) |
| 3 | Managed Disks | [labs/03-managed-disks/](labs/03-managed-disks/) |
| 4 | Blob Storage | [labs/04-blob-storage/](labs/04-blob-storage/) |
| 5 | MySQL | [labs/05-mysql/](labs/05-mysql/) |
| 6 | LB + VMSS | [labs/06-lb-vmss/](labs/06-lb-vmss/) |
| 7 | Container Apps | [labs/07-container-apps/](labs/07-container-apps/) |

## Every Lab Folder Contains

- `README.md` — architecture, commands, validation, cleanup
- `versions.tf` — provider + features
- `variables.tf` — inputs
- `main.tf` — resources
- `outputs.tf` — results
- `terraform.tfvars.example` — copy to `terraform.tfvars` (gitignored)

## Standard Workflow

```bash
az account show
cd labs/01-vm-default-vnet
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform fmt && terraform validate
terraform plan && terraform apply
terraform destroy
```

## State Warning

> **Never commit `terraform.tfstate`** — see [`.gitignore`](../.gitignore).

## Cost Warning

Same as Portal — destroy every lab when finished.

## Cleanup Between Modules

Portal (Module 03) and Azure CLI (Module 04) teach the same services manually first. **Delete Portal/CLI resources before `terraform apply` in Module 05** unless you intend to run parallel stacks and accept duplicate charges.

Each lab folder's `terraform destroy` removes every resource defined in that folder's `.tf` files (including the lab Resource Group).
