# Create IAM Access Key Safely

## Learning Goal

Create **programmatic access** (access key) for your IAM lab user — store it only in `~/.aws/credentials`, never in Git.

---

## Security Rules

| Rule | Why |
|------|-----|
| Do not use root user keys | Full account compromise risk |
| One key per user for lab | Easier to rotate and delete |
| Never commit keys | Bots scan public GitHub in minutes |
| Delete key after course | Reduces attack surface |
| Use placeholders in docs | `AKIAIOSFODNN7EXAMPLE` only |

---

## Step 1 — Create Access Key (Console)

Use Console once for key creation (AWS shows secret only at creation time).

1. Sign in as **IAM lab user** or root
2. **IAM** → **Users** → `devops-lab-<yourname>-user`
3. **Security credentials** tab
4. **Access keys** → **Create access key**
5. Use case: **Command Line Interface (CLI)**
6. Check acknowledgment → **Next** → **Create access key**
7. Copy:
   - **Access key ID** (example format: `AKIA...`)
   - **Secret access key** (shown once)
8. **Download .csv** to a safe folder — **not** inside git repo
9. **Done**

> **Never** paste real values into course Markdown, tickets, or chat.

---

## Step 2 — Store Locally (Manual Edit)

Edit credentials file in Git Bash:

```bash
mkdir -p ~/.aws
chmod 700 ~/.aws
nano ~/.aws/credentials
```

Add (replace placeholders only):

```ini
[aws-basic-lab]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

Save: `Ctrl+O`, Enter, `Ctrl+X`

Restrict permissions:

```bash
chmod 600 ~/.aws/credentials
```

---

## Step 3 — Verify File Is Not in Git Repo

From your course repo folder:

```bash
cd /c/faizul-personal/ntech/module-4/aws-basic
git status
```

Ensure `.aws/`, `*.pem`, and `*.csv` are **not** staged. Use `.gitignore` from [01-cli-prerequisites.md](01-cli-prerequisites.md).

---

## Step 4 — Do Not Export Keys in Shell History

**Avoid:**

```bash
export AWS_SECRET_ACCESS_KEY=real-secret-here   # BAD — saved in history
```

**Prefer:** `~/.aws/credentials` with profile `aws-basic-lab`.

Clear history if you made a mistake:

```bash
history -c
```

---

## Validation

| Check | How |
|-------|-----|
| Key exists in IAM | IAM Console shows active key |
| Local file | `cat ~/.aws/credentials` shows `[aws-basic-lab]` (do not share output) |
| Not in Git | `git status` clean of credential files |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Lost secret key | Delete key in IAM; create new key |
| Two keys limit | IAM allows 2 keys max per user — delete unused |
| Access denied later | User needs IAM permissions; check group policy |

---

## Cleanup (End of Course)

```bash
# Delete via Console: IAM → User → Security credentials → Delete access key
# Then remove local profile:
nano ~/.aws/credentials
# Delete [aws-basic-lab] section
```

---

## What We Achieved

- Created IAM access key for CLI (Console step)
- Stored credentials in `~/.aws/credentials` under profile `aws-basic-lab`
- Applied security rules — no keys in Git

**Next:** [04-aws-configure-profile.md](04-aws-configure-profile.md)
