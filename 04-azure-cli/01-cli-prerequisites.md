# Azure CLI Prerequisites

## Learning Goal

Confirm your environment is ready before installing the Azure CLI and running command labs.

---

## What You Need

| Requirement | Detail |
|-------------|--------|
| **Azure subscription** | Same subscription used for Module 03 Portal labs |
| **Entra ID lab user** | `devops-lab-<yourname>-user` (or your student account) with permission to create resources |
| **Region / location** | Default: `southeastasia` (Southeast Asia) — change only if instructor agrees |
| **Git Bash** | Windows terminal for SSH and Azure CLI (not PowerShell for this module) |
| **Portal experience** | Complete Module 03 first — CLI repeats the same resource flow |
| **Text editor** | VS Code or Notepad++ for notes and local config |

---

## Defaults and Region (This Course)

| Setting | Value |
|---------|-------|
| **Login (day-to-day)** | `az login` (interactive browser) |
| **Default location** | `southeastasia` |
| **Default resource group** | `devops-lab-<yourname>-rg` |
| **Output format** | `json` (recommended for learning) |

---

## Files Azure CLI Will Use

After login, session data lives on **your laptop only**:

| Path | Purpose |
|------|---------|
| `~/.azure/` | Tokens, cloud config, cached subscriptions |
| `~/.azure/clouds.config` and related | Cloud endpoint settings |
| `az config` defaults | Location, resource group, output (stored under `~/.azure/`) |

On Windows Git Bash, `~` maps to your user home (e.g. `/c/Users/YourName`).

**Example service principal values (placeholders only — never commit real secrets):**

```bash
# Environment variables for automation (local only — never commit)
export AZURE_CLIENT_ID="<app-id-guid>"
export AZURE_TENANT_ID="<tenant-id-guid>"
export AZURE_CLIENT_SECRET="<client-secret-value>"
export AZURE_SUBSCRIPTION_ID="<subscription-id-guid>"
```

For **student labs in this module**, prefer `az login` so you do not need a client secret on disk.

---

## Security Rules

1. **Never** paste real client secrets, passwords, or connection strings into this repo, Slack, or email
2. **Never** commit `~/.azure/` files or `.json` credential exports to Git
3. Use placeholders in docs: `<client-secret>`, `<your-strong-password>`
4. Prefer **`az login`** for daily student work; use a **service principal** only when you need non-interactive automation (CI/CD, scripts)
5. Do not share Owner-level service principals; scope roles to a resource group when possible

---

## Suggested `.gitignore` (Course Repo)

Add to your repo root or personal notes repo:

```gitignore
# Azure credentials and keys
.azure/
*.pem
*.ppk
*.json
!package.json
!**/package.json

# Terraform secrets
*.tfvars
terraform.tfstate
terraform.tfstate.backup
.env
.env.*
```

---

## Naming Convention (Same as Portal)

Replace `<yourname>` in all commands:

```
devops-lab-<yourname>-rg
devops-lab-<yourname>-vm
devops-lab-<yourname>-nsg
devops-lab-<yourname>-vnet
devops-lab-<yourname>-sa<random>
```

---

## Verify Git Bash Works

Open **Git Bash** and run:

```bash
whoami
pwd
echo $HOME
```

Expected: your Windows username and home path.

---

## Optional: Set Session Helpers

After configuration (Lesson 04), you can export helpers for fewer flags:

```bash
export LOCATION=southeastasia
export RG="devops-lab-<yourname>-rg"
```

Defaults set with `az config` mean you often omit `--location` and `--resource-group`.

---

## Cost Warning

CLI creates the **same billable resources** as the Portal. Run **cleanup commands** at the end of every lab. Set a budget alert in Cost Management + Billing.

---

## Checklist Before Install

- [ ] Azure subscription and lab user exist (Module 03)
- [ ] Git Bash opens and runs basic commands
- [ ] Module 03 Portal labs understood
- [ ] Budget / cost alert configured
- [ ] `.gitignore` updated locally

---

## What We Achieved

- Confirmed prerequisites for Azure CLI module
- Understood `~/.azure/` session storage and SP env vars
- Know location `southeastasia` and naming `devops-lab-<yourname>-*`

**Next:** [02-install-azure-cli-windows-gitbash.md](02-install-azure-cli-windows-gitbash.md)
