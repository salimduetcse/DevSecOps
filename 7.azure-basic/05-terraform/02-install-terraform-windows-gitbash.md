# Install Terraform on Windows (Git Bash)

## Learning Goal

Install Terraform and run it from **Git Bash** — same terminal as Azure CLI labs.

---

## Step 1 — Download

1. Open [https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
2. Download **Windows AMD64** zip
3. Extract `terraform.exe`

## Step 2 — Install to PATH

```bash
mkdir -p ~/bin
cp /c/path/to/download/terraform.exe ~/bin/
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Or place in `C:\Program Files\Terraform\` and add to Windows PATH, then reopen Git Bash.

## Step 3 — Verify

```bash
terraform version
```

**Expected:**

```
Terraform v1.x.x
on windows_amd64
```

## Step 4 — Verify Azure CLI Login

Terraform uses your Azure CLI session by default:

```bash
az login
az account show --query "{name:name, id:id, tenantId:tenantId}" -o table
```

Set the correct subscription if you have more than one:

```bash
az account set --subscription "<subscription-name-or-id>"
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `terraform: command not found` | Fix PATH; reopen Git Bash |
| Azure auth fails in Terraform | Run `az login` and `az account set` |

---

## What We Achieved

- Terraform installed and verified in Git Bash

**Next:** [03-provider-backend-state.md](03-provider-backend-state.md)
