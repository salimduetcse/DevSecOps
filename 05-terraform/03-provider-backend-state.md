# Provider, Backend, and State

## Learning Goal

Understand **provider**, **resource**, **data source**, **state**, and **backend** - the core Terraform building blocks.

---

## 1. Provider

The **provider** plugin talks to Azure Resource Manager APIs.

```hcl
# versions.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# main.tf / versions.tf
provider "azurerm" {
  features {}
  # Auth: Azure CLI (`az login`) or env vars (ARM_CLIENT_ID, ...)
}
```

`features {}` is required even when empty — it enables provider feature flags.

---

## 2. Resource

A **resource** is something Terraform **creates and manages**.

```hcl
resource "azurerm_linux_virtual_machine" "web" {
  name                = "${local.name_prefix}-web"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = var.vm_size
  # ...
}
```

Format: `resource "<TYPE>" "<NAME>" { ... }`

---

## 3. Data Source

A **data source** reads **existing** information without creating it.

```hcl
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}
```

Use data sources for: current subscription/tenant, existing resource groups (advanced labs), shared images.

Unlike AWS default VPC, Azure labs in this module **create a Resource Group and VNet per lab** — no shared "default network" data source.

---

## 4. State File

Terraform stores a mapping of your code -> real Azure resource IDs in **`terraform.tfstate`**.

| Why state matters |
|-------------------|
| Knows what it created last apply |
| Plans updates vs creates |
| Tracks dependencies |

> **Warning:** State may contain sensitive values. **Never commit to Git.** Listed in [`.gitignore`](../.gitignore).

---

## 5. Backend

**Backend** = where state is stored.

| Backend | Use |
|---------|-----|
| **local** (default) | `terraform.tfstate` in lab folder - OK for training |
| **azurerm** (advanced) | Team production — Blob Storage remote state, access control, encryption, and locking |

Labs use **local backend** (no extra config). Default:

```hcl
# Implicit - state file in current directory
```

Production example (reference only — Blob remote state as a future topic):

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestore"
    container_name       = "tfstate"
    key                  = "azure-basic/terraform.tfstate"
  }
}
```

Minimum production expectations for remote state:

- State stored outside a developer laptop (Azure Blob)
- Encryption enabled for the state store
- Access restricted to the deployment identity/team
- State locking enabled to prevent concurrent writes
- Versioning/backup strategy for recovery

---

## 6. Resource vs Data Source

| | Resource | Data Source |
|---|----------|-------------|
| Creates? | Yes | No |
| Example | `azurerm_linux_virtual_machine` | `azurerm_client_config` |
| Keyword | `resource` | `data` |

---

## State Security Checklist

- [ ] `*.tfstate` in `.gitignore`
- [ ] Do not share state in Slack/email
- [ ] Use `terraform.tfvars.example` - not real `terraform.tfvars` in Git

---

## Interview Questions

1. **What is Terraform state?** - *JSON mapping of resources Terraform manages.*
2. **Why use data sources?** - *Reference existing Azure objects without hardcoding IDs.*

---

## What We Achieved

- Understood provider, resource, data source, state, backend

**Next:** [04-terraform-workflow.md](04-terraform-workflow.md)
