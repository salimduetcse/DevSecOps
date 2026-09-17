# Create a Service Principal Safely

## Learning Goal

Understand **service principals** (app identity for automation) versus **`az login`** (your user for daily labs). Create an SP carefully, store secrets only locally, and never commit them to Git.

---

## Prefer `az login` for Student Day-to-Day Work

| Method | When to use |
|--------|-------------|
| **`az login`** | Classroom labs, learning, interactive Git Bash sessions |
| **Service principal** | CI/CD pipelines, unattended scripts, Terraform/automation |

For **this course’s CLI labs**, start every session with:

```bash
az login
az account show
```

You only need a service principal when your instructor asks for automation practice, or when you later wire Terraform/CI.

---

## What Is a Service Principal?

In Microsoft Entra ID (Azure AD):

- An **app registration** represents an application identity
- A **service principal** is that app’s identity **in your tenant/subscription**
- A **client secret** (or certificate) authenticates the app — like an access key, but for apps

Unlike AWS IAM access keys on a user, Azure student labs usually authenticate **you** via `az login`. The SP is the automation counterpart of “programmatic access.”

---

## Security Rules

| Rule | Why |
|------|-----|
| Prefer user `az login` for labs | No long-lived secret on disk |
| Do not use personal Owner SP for everything | Limit blast radius |
| Scope to a resource group when possible | Least privilege |
| Never commit secrets | Bots scan public GitHub in minutes |
| Delete SP / rotate secret after course | Reduces attack surface |
| Use placeholders in docs | `<client-secret>` only |

---

## Step 1 — Interactive Login (Required First)

```bash
az login
```

Select the correct subscription if prompted, then:

```bash
az account show --output table
az account list --output table
```

Set the subscription you use for labs:

```bash
az account set --subscription "<subscription-name-or-id>"
```

---

## Step 2 — Create Service Principal (Automation Path)

Create an SP with **Contributor** on a **lab resource group** (safer than whole subscription).

```bash
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
export LOCATION=southeastasia

# Create RG if it does not exist yet
az group create --name "$RG" --location "$LOCATION"

# Create SP scoped to the resource group
az ad sp create-for-rbac \
  --name "devops-lab-${YOURNAME}-cli-sp" \
  --role Contributor \
  --scopes "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/${RG}"
```

**Example output (placeholders — never commit real values):**

```json
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "devops-lab-yourname-cli-sp",
  "password": "<client-secret-shown-once>",
  "tenant": "11111111-1111-1111-1111-111111111111"
}
```

| Field | Meaning |
|-------|---------|
| `appId` | Client ID (`AZURE_CLIENT_ID`) |
| `password` | Client secret — **shown once** |
| `tenant` | Directory (tenant) ID |

> **Never** paste real `password` / `appId` into course Markdown, tickets, or chat.

---

## Step 3 — Store Locally (Env Vars — Not Git)

**Prefer** exporting in the **current Git Bash session** only (not saved scripts in the repo):

```bash
export AZURE_CLIENT_ID="<appId-from-output>"
export AZURE_TENANT_ID="<tenant-from-output>"
export AZURE_CLIENT_SECRET="<password-from-output>"
export AZURE_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
```

Login as the service principal (automation demo):

```bash
az login --service-principal \
  --username "$AZURE_CLIENT_ID" \
  --password "$AZURE_CLIENT_SECRET" \
  --tenant "$AZURE_TENANT_ID"

az account set --subscription "$AZURE_SUBSCRIPTION_ID"
az account show --output table
```

Switch back to your user for normal labs:

```bash
az login
az account set --subscription "$AZURE_SUBSCRIPTION_ID"
```

### Optional: local secrets file outside the repo

If you save a file, put it **outside** the git tree and never commit it:

```bash
# Example path OUTSIDE the course repo
mkdir -p ~/azure-lab-secrets
chmod 700 ~/azure-lab-secrets
# Store notes privately — do not use filenames committed in this course
```

---

## Step 4 — Do Not Put Secrets in Shell History Carelessly

**Avoid committing scripts like:**

```bash
export AZURE_CLIENT_SECRET=real-secret-here   # BAD if this file is committed
```

If a secret entered your history by mistake:

```bash
history -c
```

Also rotate the secret in Entra ID (App registrations → Certificates & secrets).

---

## Step 5 — Verify Nothing Credential-Related Is in Git

```bash
cd /c/faizul-personal/ntech/module-4/azure-basic
git status
```

Ensure `.azure/`, `*.pem`, secret `.json` dumps, and `.env` are **not** staged. Use `.gitignore` from [01-cli-prerequisites.md](01-cli-prerequisites.md).

---

## Validation

| Check | How |
|-------|-----|
| User login works | `az login` then `az account show` |
| SP created | Portal → Microsoft Entra ID → App registrations → `devops-lab-<yourname>-cli-sp` |
| SP can act in RG | SP login → `az group show -n devops-lab-<yourname>-rg` |
| Not in Git | `git status` clean of credential files |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `Insufficient privileges` creating SP | Need Application Administrator / User Access Admin rights — ask instructor |
| Lost client secret | Create a new secret on the app registration; delete the old one |
| SP AccessDenied on resources | Check role assignment scope (RG vs subscription) |
| Wrong subscription | `az account list -o table` then `az account set` |

---

## Cleanup (End of Course)

```bash
# Delete the app registration / SP (name from create step)
az ad sp list --display-name "devops-lab-${YOURNAME}-cli-sp" --query "[].appId" -o tsv
# Then:
az ad sp delete --id "<appId>"

# Clear local env
unset AZURE_CLIENT_ID AZURE_TENANT_ID AZURE_CLIENT_SECRET AZURE_SUBSCRIPTION_ID
```

Portal: **Microsoft Entra ID** → **App registrations** → delete the lab app.

Return to user login:

```bash
az login
```

---

## What We Achieved

- Distinguished `az login` (daily) vs service principal (automation)
- Created a resource-group-scoped SP safely
- Stored secrets only in local env / private notes — no secrets in Git

**Next:** [04-az-configure-defaults.md](04-az-configure-defaults.md)
