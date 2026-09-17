# CLI Labs — Same Order as Portal

## Overview

Repeat **Module 03 Portal labs** using **Azure CLI** in **Git Bash**. Same services, same order, same region.

| # | Portal Lab | CLI Guide |
|---|------------|-----------|
| 1 | Entra ID / subscription setup | Lessons 01–04 in this module |
| 2 | VM default VNet | [commands/vm-default-vnet.md](commands/vm-default-vnet.md) |
| 3 | Custom VNet VM | [commands/custom-vnet-vm.md](commands/custom-vnet-vm.md) |
| 4 | Managed Disks | [commands/managed-disks.md](commands/managed-disks.md) |
| 5 | Blob Storage | [commands/blob-storage.md](commands/blob-storage.md) |
| 6 | MySQL Flexible Server | [commands/mysql.md](commands/mysql.md) |
| 7 | LB + VMSS | [commands/lb-vmss.md](commands/lb-vmss.md) |
| 8 | Container Apps | [commands/container-apps.md](commands/container-apps.md) |

---

## Before Every Lab

```bash
az login
az account set --subscription "<subscription-name-or-id>"

export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"

az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"

az account show --output table
```

---

## Lab Rules

1. **One lab at a time** — run cleanup before starting next
2. **Location:** `southeastasia` always
3. **Resource group:** `devops-lab-<yourname>-rg` (or one RG per lab if instructor prefers)
4. **SSH:** still use Git Bash for VM access
5. **Cost:** same warnings as Portal — deallocate/delete same day
6. **Naming:** `devops-lab-<yourname>-*`
7. **Auth:** prefer `az login`; never commit service principal secrets

---

## Each CLI Lab Includes

1. Theory reminder
2. Resource creation commands
3. Validation commands
4. Output explanation
5. Cleanup commands
6. Troubleshooting
7. What we achieved

---

## Suggested Schedule

| Day | Lab | Est. Time |
|-----|-----|-----------|
| 1 | Setup + VM default VNet | 2–3 hrs |
| 2 | Custom VNet | 3–4 hrs |
| 3 | Managed Disks + Blob | 2–3 hrs |
| 4 | MySQL Flexible Server | 2–3 hrs |
| 5 | LB + VMSS | 3–4 hrs |
| 6 | Container Apps | 3–4 hrs |

---

## Portal vs CLI

| Task | Portal | CLI |
|------|--------|-----|
| Learn visually | ✅ Best | Secondary |
| Automation / CI/CD | Manual | ✅ Best |
| Repeatability | Click-heavy | ✅ Scriptable |
| This course | Module 03 first | Module 04 second |

Module 05 **Terraform** automates the same flow again.

---

## Cost Warning

CLI labs create **real resources**. Every command guide ends with **cleanup commands**. If cleanup fails, use matching [03-console-labs cleanup](../03-console-labs/) as backup.

## Cleanup Between Modules (Portal → CLI → Terraform)

The same services are taught three times. **Do not start Module 04 CLI labs while Portal lab resources are still running** — you will duplicate cost.

1. Finish a Portal sub-lab → run its `cleanup.md`
2. Before starting Module 04, verify zero lab resources (or run [final-cleanup-checklist.md](../06-capstone-project/final-cleanup-checklist.md))
3. Repeat before Module 05 Terraform

**Exception (Portal only):** Defer Lab 02 VM cleanup until after Lab 04 Managed Disks if that lab reuses the same VM — follow instructor Portal notes.

---

## What We Achieved

- Mapped Portal lab order to CLI command guides
- Ready to start hands-on CLI labs

**Start here:** [commands/vm-default-vnet.md](commands/vm-default-vnet.md)
