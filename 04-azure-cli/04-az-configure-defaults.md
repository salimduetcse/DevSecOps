# Configure Azure CLI Defaults

## Learning Goal

Set subscription with **`az account set`**, configure **`defaults.location=southeastasia`** and **`defaults.group`**, verify with **`az account show`**, and understand Azure CLI command structure.

---

## Step 1 — Login and Select Subscription

In Git Bash:

```bash
az login
az account list --output table
az account set --subscription "<subscription-name-or-id>"
az account show --output table
```

| Field | Meaning |
|-------|---------|
| `name` | Subscription display name |
| `id` | Subscription GUID |
| `tenantId` | Entra ID directory |
| `state` | Should be `Enabled` |

---

## Step 2 — Set Defaults (Location + Resource Group)

Create (or reuse) your lab resource group, then set CLI defaults:

```bash
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
export LOCATION=southeastasia

az group create --name "$RG" --location "$LOCATION"

az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"
az config set core.output=json
```

This writes configuration under `~/.azure/` so many commands inherit location and resource group.

Verify:

```bash
az config get defaults.location
az config get defaults.group
az config get core.output
```

**Expected:**

```
southeastasia
devops-lab-<yourname>-rg
json
```

(Exact output format may wrap values; location and group names must match.)

---

## Step 3 — Test Identity and Access

```bash
az account show
az ad signed-in-user show --query "{userPrincipalName:userPrincipalName,displayName:displayName}" -o json
```

**Example output (user login):**

```json
{
  "userPrincipalName": "student@contoso.com",
  "displayName": "Student Name"
}
```

Confirm you can see the resource group:

```bash
az group show --name "$RG" --output table
```

If this works, subscription and defaults are correct.

---

## Step 4 — Location and Output Format

### Location

Always use **`southeastasia`** for labs unless instructor says otherwise.

```bash
az account list-locations --query "[?name=='southeastasia'].{Name:name,Display:displayName}" -o table
```

**Expected:** row for Southeast Asia.

### Output formats

| Format | Use |
|--------|-----|
| `json` | Default for labs — full detail |
| `table` | Human-readable lists |
| `tsv` | Scripts |
| `yaml` | Readable alternative |

Examples:

```bash
az account show --output table
az account show --output tsv
```

### Override defaults per command

```bash
az group list --output table
az vm list --resource-group other-rg --output table
az storage account list --subscription "<other-sub-id>" --output table
```

---

## Step 5 — CLI Command Structure

```bash
az <group> <subgroup> <command> [parameters]
```

| Part | Example |
|------|---------|
| Group | `vm`, `network`, `storage`, `mysql`, `containerapp`, `acr` |
| Subgroup | `vnet`, `nsg`, `nic`, `disk` |
| Command | `create`, `show`, `list`, `delete` |
| Parameters | `--name`, `--resource-group`, `--location`, `--query`, `--output` |

### Get help

```bash
az vm --help
az vm create --help
```

### Query and filter (JMESPath)

```bash
az vm list \
  --query "[].{Name:name,Location:location,RG:resourceGroup}" \
  --output table
```

### Session environment variables (optional)

```bash
export LOCATION=southeastasia
export RG="devops-lab-${YOURNAME}-rg"

az group show --name "$RG"
```

With defaults set, you can often omit `--location` and `--resource-group`.

---

## Step 6 — What-If / Dry Run Style Safety

Azure CLI does not have AWS-style `--dry-run` on every command. Prefer:

```bash
# Preview ARM deployment changes (when using templates)
# az deployment group what-if ...

# Always list before delete
az resource list --resource-group "$RG" --output table

# Confirm names carefully before:
# az group delete --name "$RG" --yes --no-wait
```

For training: create resources in **one lab RG**, then delete the whole group at cleanup when appropriate.

---

## Validation Checklist

- [ ] `az login` completed
- [ ] `az account set` points at lab subscription
- [ ] `az config` has `defaults.location=southeastasia`
- [ ] `az config` has `defaults.group=devops-lab-<yourname>-rg`
- [ ] `az account show` returns expected subscription
- [ ] Output format `json` works

---

## Troubleshooting

| Error | Solution |
|-------|----------|
| `Please run 'az login'` | Run `az login` |
| Wrong subscription | `az account list -o table` then `az account set` |
| Resources in unexpected region | Check `az config get defaults.location` |
| `AuthorizationFailed` | Ask instructor for Contributor on subscription or RG |
| Defaults ignored | Pass `--resource-group` / `--location` explicitly |

---

## Cost Warning

`az account show` is free. Other commands may create paid resources.

---

## What We Achieved

- Selected subscription with **`az account set`**
- Set **`defaults.location=southeastasia`** and **`defaults.group`**
- Verified identity with **`az account show`**
- Learned CLI command structure and `--query`

**Next:** [05-cli-command-cheatsheet.md](05-cli-command-cheatsheet.md)
