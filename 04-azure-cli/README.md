# Module 04 — Azure CLI

## What This Module Teaches

Install and configure the Azure CLI, create a service principal safely (for automation), and repeat the same labs from Module 03 using command-line workflows.

## Learning Objectives

- Install Azure CLI on Windows (Git Bash)
- Prefer interactive `az login` for day-to-day student work; understand service principals for CI/CD
- Configure defaults (`southeastasia` location and a lab resource group)
- Map Portal actions to CLI commands for VM, VNet, Managed Disks, Blob, MySQL, LB/VMSS, Container Apps

## Lab Outcome

A working Azure CLI session and command guides that reproduce each Portal lab. Students can operate Azure from the terminal.

## Estimated Time

10–12 hours (setup + all command labs)

## Cost Warning

**Same as Module 03** — CLI creates the same billable resources. Run cleanup after each command lab. Never paste real client secrets or passwords into committed files; use placeholders like `<client-secret>` and environment variables locally.

## Cleanup Reminder

Each command guide includes **cleanup commands**. Backup: matching Portal lab [cleanup.md](../03-console-labs/) files. Destroy resources before the next lab.

**Before starting Module 04:** finish all Portal lab cleanups (see [06-cli-labs-same-order-as-console.md](06-cli-labs-same-order-as-console.md)). **Before Module 05 Terraform:** run [final-cleanup-checklist.md](../06-capstone-project/final-cleanup-checklist.md) to avoid paying for duplicate stacks.

## Defaults and Region

| Setting | Value |
|---------|-------|
| Login method (daily) | `az login` (interactive) |
| Location | `southeastasia` |
| Resource group | `devops-lab-<yourname>-rg` (typical) |
| Terminal | **Git Bash** (not PowerShell) |

## Security

- Session tokens from `az login` live under `~/.azure/` on your laptop only
- Service principal secrets stay in local env vars or a secret store — never in Git
- Never commit secrets — see `.gitignore` in [01-cli-prerequisites.md](01-cli-prerequisites.md)

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-cli-prerequisites.md](01-cli-prerequisites.md) | Prerequisites |
| 2 | [02-install-azure-cli-windows-gitbash.md](02-install-azure-cli-windows-gitbash.md) | Install CLI |
| 3 | [03-create-service-principal.md](03-create-service-principal.md) | Service principals |
| 4 | [04-az-configure-defaults.md](04-az-configure-defaults.md) | Configure defaults |
| 5 | [05-cli-command-cheatsheet.md](05-cli-command-cheatsheet.md) | Cheatsheet |
| 6 | [06-cli-labs-same-order-as-console.md](06-cli-labs-same-order-as-console.md) | Labs overview |

## Command Guides

| Lab | File |
|-----|------|
| VM Default VNet | [commands/vm-default-vnet.md](commands/vm-default-vnet.md) |
| Custom VNet VM | [commands/custom-vnet-vm.md](commands/custom-vnet-vm.md) |
| Managed Disks | [commands/managed-disks.md](commands/managed-disks.md) |
| Blob Storage | [commands/blob-storage.md](commands/blob-storage.md) |
| MySQL Flexible Server | [commands/mysql.md](commands/mysql.md) |
| LB + VMSS | [commands/lb-vmss.md](commands/lb-vmss.md) |
| Container Apps | [commands/container-apps.md](commands/container-apps.md) |
