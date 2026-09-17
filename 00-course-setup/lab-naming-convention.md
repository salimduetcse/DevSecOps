# Lab Naming Convention

## Learning Goal

Use **consistent names and tags** so you (and your instructor) can find, manage, and **delete** lab resources quickly.

---

## Naming Pattern

```
devops-lab-<yourname>-<resource-type>
```

Replace `<yourname>` with a short lowercase identifier (e.g. `faizul`, `sara`, `student01`).

### Examples

| Resource | Name |
|----------|------|
| Entra lab user | `devops-lab-faizul-user` |
| Resource group | `devops-lab-faizul-rg` |
| VM | `devops-lab-faizul-web` |
| NSG | `devops-lab-faizul-vm-nsg` |
| VNet | `devops-lab-faizul-vnet` |
| Storage account | `devopslabfaizulst2026a` (globally unique, lowercase alphanumeric only) |
| MySQL Flexible Server | `devops-lab-faizul-mysql` |
| Container Apps environment | `devops-lab-faizul-cae` |

### Terraform / CLI suffix

Automation labs may add suffixes:

```
devops-lab-faizul-tf-web      # Terraform VM lab
devops-lab-faizul-cli-key     # CLI lab key name
```

---

## Required Tags

Apply to every resource that supports tags:

| Key | Value | Purpose |
|-----|-------|---------|
| `Project` | `azure-basic` | Filter all course resources |
| `Owner` | `<yourname>` | Who owns this resource |
| `Environment` | `training` | Not production |

### Portal tagging

At resource creation, add tags in the **Tags** blade.

### Terraform tagging

This course uses provider or resource-level common tags:

```hcl
tags = {
  Project     = "azure-basic"
  Owner       = "devops-student"
  Environment = "training"
}
```

Override `Owner` in `terraform.tfvars` with your name where variables allow.

---

## Placeholder Values in Docs

Course materials use placeholders — **never copy real secrets from examples**.

| Placeholder | Replace with |
|-------------|--------------|
| `<yourname>` | Your short name |
| `<yourname>-user` | Your Entra lab username |
| `<PUBLIC_IP>` | VM public IP from Portal |
| `<SUBSCRIPTION_ID>` | Azure subscription GUID |
| `<TENANT_ID>` | Microsoft Entra tenant ID |
| `YOUR_PUBLIC_IP/32` | Your IP from `curl https://ifconfig.me` |
| `<your-storage-account>` | Globally unique storage account name |
| `<your-strong-password>` | Local password — not in Git |

---

## Storage Account Naming Rules

Storage account names are **globally unique** across all Azure customers.

| Rule | Example |
|------|---------|
| Lowercase letters and numbers only | `devopslabfaizulst` |
| No hyphens | Unlike most other Azure names |
| 3–24 characters | Keep short |
| Add random suffix | `devopslabfaizulstx7k2` |

Get your public IP for NSG rules:

```bash
curl -s https://ifconfig.me
# Use as 203.0.113.45/32 in NSG rules
```

---

## Identity and RBAC Naming

| Item | Convention |
|------|------------|
| Lab user | `devops-lab-<yourname>-user` |
| Lab resource group | `devops-lab-<yourname>-rg` |
| Daily role | Contributor on lab RG |
| CLI / Terraform | Logged-in user or service principal for Module 04/05 |

---

## Key Pair and Local Files

| File | Store location | Git? |
|------|----------------|------|
| `devops-lab-<yourname>-key.pem` | `~/.ssh/` or lab folder | **Never** |
| `terraform.tfstate` | Lab folder | **Never** |
| `terraform.tfvars` | Lab folder | **Never** |
| `terraform.tfvars.example` | Repo | Yes (no secrets) |

---

## Finding Your Resources in Portal

1. Filter resources by name: `devops-lab`
2. Or filter by tag: `Project = azure-basic`
3. Open your resource group: `devops-lab-<yourname>-rg`
4. Always check region **`southeastasia`**

```bash
# CLI example — list your tagged resources in the lab RG
az resource list \
  --resource-group devops-lab-<yourname>-rg \
  --query "[?tags.Project=='azure-basic'].{Name:name,Type:type,Location:location}" \
  --output table
```

---

## Cleanup Naming Reminder

Before deleting, confirm the name matches **your** prefix:

- ✅ `devops-lab-faizul-web` — yours
- ❌ `devops-lab-otherstudent-web` — not yours

When in doubt, check tag `Owner`. Deleting **your** resource group removes the whole lab set safely.

---

## Interview-Style Questions

1. **Why use a naming convention?**
   - *Find and delete resources quickly; avoid orphan costs.*

2. **Why tag resources?**
   - *Cost allocation, ownership, and bulk filtering.*

3. **Why storage accounts need unique names?**
   - *Storage account namespace is global across all Azure subscriptions.*

---

## References to Verify

- [Azure naming conventions](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Storage account naming rules](https://learn.microsoft.com/azure/storage/common/storage-account-overview#storage-account-name)

---

**Module 00 complete.** Continue to [01-cloud-fundamentals](../01-cloud-fundamentals/README.md).
