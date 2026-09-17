# Module 05 — Terraform

## What This Module Teaches

Infrastructure as Code with Terraform after Portal and Azure CLI. Same Azure services, automated in `.tf` files.

## Learning Objectives

- Explain IaC and why Terraform follows Portal/Azure CLI
- Use provider, resource, data source, variable, output, state
- Run init → fmt → validate → plan → apply → destroy
- Build VM through Container Apps labs with Azure CLI auth and region `southeastasia`

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

in each lab folder. Verify in Azure Portal if destroy fails.

**Before starting Terraform labs:** ensure Portal and Azure CLI lab resources are deleted. Run [final-cleanup-checklist.md](../06-capstone-project/final-cleanup-checklist.md) if unsure — duplicate stacks triple your bill.

`terraform destroy` removes all resources in that lab's state file, including resource groups, managed disks/snapshots (Lab 03), MySQL Flexible Server (Lab 05), VM Scale Sets (Lab 06), and ACR + Container Apps (Lab 07).

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
| VM (lab network) | [labs/01-vm-default-vnet/](labs/01-vm-default-vnet/) |
| Custom VNet VM | [labs/02-custom-vnet-vm/](labs/02-custom-vnet-vm/) |
| Managed Disks | [labs/03-managed-disks/](labs/03-managed-disks/) |
| Blob Storage | [labs/04-blob-storage/](labs/04-blob-storage/) |
| MySQL | [labs/05-mysql/](labs/05-mysql/) |
| LB / VMSS | [labs/06-lb-vmss/](labs/06-lb-vmss/) |
| Container Apps | [labs/07-container-apps/](labs/07-container-apps/) |
