# Install AWS CLI on Windows (Git Bash)

## Learning Goal

Install **AWS CLI version 2** on Windows and run it from **Git Bash**.

---

## 1. Download and Install (MSI — Recommended)

### Step 1 — Download

1. Open: [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)
2. Download **AWS CLI MSI installer for Windows (64-bit)**

### Step 2 — Run installer

1. Run the `.msi` file
2. Accept defaults (installs to `C:\Program Files\Amazon\AWSCLIV2\`)
3. Finish installation
4. **Close and reopen Git Bash** (required to refresh PATH)

### Step 3 — Verify in Git Bash

```bash
aws --version
```

**Expected output (version may differ):**

```
aws-cli/2.x.x Python/3.x.x Windows/10 exe/AMD64
```

If `aws: command not found`:

```bash
"/c/Program Files/Amazon/AWSCLIV2/aws.exe" --version
```

Add to `~/.bashrc` if needed:

```bash
echo 'export PATH="/c/Program Files/Amazon/AWSCLIV2:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 2. Use AWS CLI from Git Bash

### Why Git Bash?

- Same commands as Linux/macOS labs and production servers
- SSH to EC2 with OpenSSH
- Paths like `~/.aws/credentials` work naturally

### Basic test (before credentials)

```bash
aws help
```

Press `q` to quit help pager.

### Path to AWS config files

```bash
ls -la ~/.aws/
```

If folder does not exist yet, it will be created by `aws configure`.

```bash
mkdir -p ~/.aws
chmod 700 ~/.aws
```

---

## 3. Git Bash vs PowerShell

| Use | Tool |
|-----|------|
| This course CLI labs | **Git Bash** |
| PowerShell | Not assumed — commands may differ |

All examples use:

```bash
aws <service> <operation> --profile aws-basic-lab --region ap-southeast-1
```

---

## 4. Enable Command Completion (Optional)

```bash
echo 'complete -C aws_completer aws' >> ~/.bashrc
source ~/.bashrc
```

---

## 5. Validation

| Command | Expected |
|---------|----------|
| `aws --version` | Shows `aws-cli/2.` |
| `which aws` | Path to `aws.exe` |
| `aws help` | Help text loads |

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `aws: command not found` | Reopen Git Bash; add AWSCLIV2 to PATH |
| Wrong version (v1) | Uninstall old AWS CLI; install v2 MSI |
| Permission denied on `~/.aws` | `chmod 700 ~/.aws` |
| Garbled output | Set `export AWS_PAGER=""` to disable pager |

---

## 7. Cost Warning

Installing CLI is free. Charges start when you run commands that create resources.

---

## What We Achieved

- Installed AWS CLI v2 on Windows
- Verified `aws` works in Git Bash
- Prepared `~/.aws` directory for credentials

**Next:** [03-create-access-key.md](03-create-access-key.md)
