# AWS CLI Prerequisites

## Learning Goal

Confirm your environment is ready before installing the AWS CLI and running command labs.

---

## What You Need

| Requirement | Detail |
|-------------|--------|
| **AWS account** | Same account used for Module 03 Console labs |
| **IAM lab user** | `devops-lab-<yourname>-user` with permissions to create resources |
| **Region** | Default: `ap-southeast-1` (Singapore) — change only if instructor agrees |
| **Git Bash** | Windows terminal for SSH and AWS CLI (not PowerShell for this module) |
| **Console experience** | Complete Module 03 first — CLI repeats the same resource flow |
| **Text editor** | VS Code or Notepad++ for config files |

---

## Profile and Region (This Course)

| Setting | Value |
|---------|-------|
| **Profile name** | `aws-basic-lab` |
| **Default region** | `ap-southeast-1` |
| **Output format** | `json` (recommended for learning) |

---

## Files AWS CLI Will Use

After configuration, credentials live on **your laptop only**:

| File | Purpose |
|------|---------|
| `~/.aws/credentials` | Access Key ID and Secret Access Key per profile |
| `~/.aws/config` | Region, output format, and profile settings |

On Windows Git Bash, `~` maps to your user home (e.g. `/c/Users/YourName`).

**Example structure (placeholders only — never commit real keys):**

```ini
# ~/.aws/credentials
[aws-basic-lab]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

```ini
# ~/.aws/config
[profile aws-basic-lab]
region = ap-southeast-1
output = json
```

---

## Security Rules

1. **Never** paste real access keys into this repo, Slack, or email
2. **Never** commit `~/.aws/` files to Git
3. Use placeholders in docs: `AKIAEXAMPLE`, `<your-secret-key>`
4. Prefer **one access key** per lab user; delete when course ends
5. Root user should **not** have programmatic access keys

---

## Suggested `.gitignore` (Course Repo)

Add to your repo root or personal notes repo:

```gitignore
# AWS credentials and keys
.aws/
*.pem
*.csv
credentials
config

# Terraform secrets
*.tfvars
terraform.tfstate
terraform.tfstate.backup
.env
.env.*
```

---

## Naming Convention (Same as Console)

Replace `<yourname>` in all commands:

```
devops-lab-<yourname>-key
devops-lab-<yourname>-ec2-sg
devops-lab-<yourname>-web
devops-lab-<yourname>-vpc
devops-lab-<yourname>-bucket-<random>
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

## Optional: Set Profile for Session

After configuration (Lesson 04), you can export for fewer flags:

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_DEFAULT_REGION=ap-southeast-1
```

---

## Cost Warning

CLI creates the **same billable resources** as the Console. Run **cleanup commands** at the end of every lab. Set billing alerts in AWS Budgets.

---

## Checklist Before Install

- [ ] IAM lab user exists (Module 03)
- [ ] Git Bash opens and runs basic commands
- [ ] Module 03 Console labs understood
- [ ] Billing alert configured
- [ ] `.gitignore` updated locally

---

## What We Achieved

- Confirmed prerequisites for AWS CLI module
- Understood `~/.aws/credentials` and `~/.aws/config`
- Know profile name `aws-basic-lab` and region `ap-southeast-1`

**Next:** [02-install-aws-cli-windows-gitbash.md](02-install-aws-cli-windows-gitbash.md)
