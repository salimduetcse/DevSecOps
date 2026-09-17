# Terraform Theory

## Learning Goal

Understand **Infrastructure as Code (IaC)** and why Terraform is the third step after Azure Portal and Azure CLI.

---

## 1. What Is Infrastructure as Code?

**Infrastructure as Code (IaC)** means you define servers, networks, databases, and storage in **files** instead of clicking in a portal.

| Manual approach | IaC approach |
|-----------------|--------------|
| Click VM create wizard | Write `azurerm_linux_virtual_machine` in `.tf` file |
| Forget what you built | Git tracks every change |
| Hard to reproduce | `terraform apply` rebuilds same stack |

Your infrastructure becomes **versioned**, **reviewable**, and **repeatable** — like application code.

---

## 2. Why Terraform?

| Benefit | Explanation |
|---------|-------------|
| **Multi-cloud syntax** | Same workflow for Azure, AWS, GCP (with different providers) |
| **Declarative** | You describe *desired state*; Terraform figures out create/update/delete |
| **Plan before change** | `terraform plan` shows what will happen |
| **Large community** | Modules, docs, hiring demand |
| **DevOps standard** | Pairs with CI/CD pipelines |

---

## 3. Terraform vs Azure Portal vs Azure CLI

| | Portal | CLI | Terraform |
|---|--------|-----|-----------|
| **Best for learning** | ✅ Visual | ✅ Commands | After basics |
| **Speed one-off test** | Fast | Fast | Slower first time |
| **Repeatability** | Low | Medium (scripts) | ✅ High |
| **Team review** | Hard | Medium | ✅ Pull requests on `.tf` |
| **Drift detection** | Manual | Manual | `plan` shows drift |
| **State tracking** | None | None | ✅ `tfstate` |

**This course order:** Portal (what) → Azure CLI (how commands work) → Terraform (automate properly).

---

## 4. Core Concepts Preview

| Concept | One-line meaning |
|---------|------------------|
| **Provider** | Plugin for Azure (`hashicorp/azurerm`) |
| **Resource** | Thing to create (`azurerm_linux_virtual_machine`, `azurerm_storage_account`) |
| **Data source** | Read existing info (`azurerm_client_config`, image lookup) |
| **Variable** | Input parameters (`location`, `vm_size`) |
| **Output** | Values after apply (`public_ip`) |
| **State** | Terraform's record of what it manages |
| **Backend** | Where state file is stored (local default) |

Detailed in [03-provider-backend-state.md](03-provider-backend-state.md) and [05-variable-output-tfvars.md](05-variable-output-tfvars.md).

---

## 5. Terraform Workflow Preview

```bash
terraform init      # Download provider
terraform fmt       # Format .tf files
terraform validate  # Check syntax
terraform plan      # Preview changes
terraform apply     # Create/update resources
terraform destroy   # Delete resources
```

Full workflow: [04-terraform-workflow.md](04-terraform-workflow.md).

---

## 6. This Course Settings

| Setting | Value |
|---------|-------|
| Provider | Azure (`hashicorp/azurerm` ~> 3.0) |
| Auth | Azure CLI (`az login`) |
| Location | `southeastasia` |
| Tags | `Project=azure-basic`, `Owner=<student_name>`, `Environment=training` |

---

## 7. State File Warning

> **Terraform state (`terraform.tfstate`) can contain sensitive data** — IP addresses, resource IDs, and sometimes secrets. **Do not commit `terraform.tfstate` to Git.** Use root [`.gitignore`](../.gitignore).

---

## 8. Cost Warning

`terraform apply` creates **real Azure resources** with real costs. Always `terraform destroy` when finished. Same Free trial / budget rules as Portal labs.

---

## Interview Questions

1. **What is IaC?** — *Managing infrastructure through machine-readable definition files.*
2. **Why Terraform after CLI?** — *CLI is imperative one-offs; Terraform is declarative and repeatable.*
3. **Is Terraform state safe in Git?** — *No — can contain sensitive metadata; use remote backend + encryption in production.*

---

## What We Achieved

- Understood IaC and Terraform's role in DevOps
- Compared Portal, Azure CLI, and Terraform

**Next:** [02-install-terraform-windows-gitbash.md](02-install-terraform-windows-gitbash.md)
