# Install Azure CLI on Windows (Git Bash)

## Learning Goal

Install the **Azure CLI** on Windows and run it from **Git Bash**.

---

## 1. Download and Install (MSI — Recommended)

### Step 1 — Download

1. Open: [https://learn.microsoft.com/cli/azure/install-azure-cli-windows](https://learn.microsoft.com/cli/azure/install-azure-cli-windows)
2. Download the **MSI installer for Windows (64-bit)**

### Step 2 — Run installer

1. Run the `.msi` file
2. Accept defaults (installs under `C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\` or similar)
3. Finish installation
4. **Close and reopen Git Bash** (required to refresh PATH)

### Step 3 — Verify in Git Bash

```bash
az version
```

**Expected output (version may differ):**

```json
{
  "azure-cli": "2.x.x",
  ...
}
```

Or:

```bash
az --version
```

If `az: command not found`:

```bash
"/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin/az.cmd" --version
```

Add to `~/.bashrc` if needed (adjust path if your install differs):

```bash
echo 'export PATH="/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 2. Use Azure CLI from Git Bash

### Why Git Bash?

- Same commands as Linux/macOS labs and production servers
- SSH to Azure VMs with OpenSSH
- Paths like `~/.azure/` work naturally

### Basic test (before login)

```bash
az help
```

Press `q` to quit help pager if a pager appears.

### Path to Azure CLI config

```bash
ls -la ~/.azure/
```

If the folder does not exist yet, it will be created by `az login` / first config commands.

```bash
mkdir -p ~/.azure
chmod 700 ~/.azure
```

---

## 3. Git Bash vs PowerShell

| Use | Tool |
|-----|------|
| This course CLI labs | **Git Bash** |
| PowerShell | Not assumed — quoting and paths may differ |

All examples use:

```bash
az <group> <subgroup> <command> --resource-group devops-lab-<yourname>-rg --location southeastasia
```

---

## 4. Enable Tab Completion (Optional)

```bash
eval "$(register-python-argcomplete az)" 2>/dev/null || true
# Official completion for bash (if available on your install):
# source /etc/bash_completion.d/azure-cli   # Linux path; Windows often uses az.cmd
```

On Windows Git Bash, tab completion may be limited. Use `az <command> --help` liberally.

---

## 5. Validation

| Command | Expected |
|---------|----------|
| `az version` | Shows `azure-cli` version |
| `which az` or `type az` | Path to `az` / `az.cmd` |
| `az help` | Help text loads |

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `az: command not found` | Reopen Git Bash; add Azure CLI `wbin` to PATH |
| Old / broken install | Uninstall Azure CLI; reinstall MSI; reopen Git Bash |
| Permission denied on `~/.azure` | `chmod 700 ~/.azure` |
| Garbled / stuck pager | Set `export AZURE_CORE_NO_COLOR=1` or use `--only-show-errors` |

---

## 7. Cost Warning

Installing CLI is free. Charges start when you run commands that create resources.

---

## What We Achieved

- Installed Azure CLI on Windows
- Verified `az` works in Git Bash
- Prepared `~/.azure` directory for login/config

**Next:** [03-create-service-principal.md](03-create-service-principal.md)
