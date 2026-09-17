# CLI Lab — Blob Storage

Repeat [Portal lab 05](../../03-console-labs/05-blob-storage/README.md) using Azure CLI.

---

## 1. Theory Reminder

- **Storage account** name is **globally unique**; containers hold **blobs** (objects)
- Prefer **private** containers for labs; avoid anonymous public access unless instructor demo
- **Soft delete / versioning** helps recover objects
- Auth: prefer **Azure AD (`--auth-mode login`)** after `az login`

---

## 2. Setup Variables

```bash
az login
export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
# Storage account names: 3-24 chars, lowercase alphanumeric only
export SA="devopslab${YOURNAME}cli$(date +%y%m)"
export SA=$(echo "$SA" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9' | cut -c1-24)

az group create --name "$RG" --location "$LOCATION"
az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"
echo "Storage account: $SA"
```

---

## 3. Resource Creation Commands

### 3.1 Create storage account

```bash
az storage account create \
  --name "$SA" \
  --resource-group "$RG" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2

# Network firewall default action (Allow = public endpoint allowed; not Entra auth)
az storage account update \
  --name "$SA" \
  --resource-group "$RG" \
  --default-action Allow
```

### 3.2 Role assignment (required before `--auth-mode login` uploads)

Subscription Owner/Contributor alone does **not** grant blob data-plane access. Assign a data role first:

```bash
export USER_ID=$(az ad signed-in-user show --query id -o tsv)
export SCOPE=$(az storage account show --name "$SA" --resource-group "$RG" --query id -o tsv)

az role assignment create \
  --assignee-object-id "$USER_ID" \
  --assignee-principal-type User \
  --role "Storage Blob Data Contributor" \
  --scope "$SCOPE"

# Wait ~1-2 minutes for RBAC propagation before creating containers / uploading
sleep 60
```

### 3.3 Create container and upload blobs

```bash
az storage container create \
  --account-name "$SA" \
  --name labs \
  --auth-mode login \
  --public-access off

echo "CLI lab version 1" > hello.txt

az storage blob upload \
  --account-name "$SA" \
  --container-name labs \
  --name week1/hello.txt \
  --file hello.txt \
  --auth-mode login \
  --overwrite true

az storage blob upload \
  --account-name "$SA" \
  --container-name labs \
  --name week1/readme.txt \
  --file hello.txt \
  --auth-mode login \
  --overwrite true
```

### 3.4 Enable blob versioning

```bash
az storage account blob-service-properties update \
  --account-name "$SA" \
  --resource-group "$RG" \
  --enable-versioning true

echo "CLI lab version 2" > hello.txt
az storage blob upload \
  --account-name "$SA" \
  --container-name labs \
  --name week1/hello.txt \
  --file hello.txt \
  --auth-mode login \
  --overwrite true
```

---

## 4. Validation Commands

```bash
# List blobs
az storage blob list \
  --account-name "$SA" \
  --container-name labs \
  --auth-mode login \
  --query "[].{Name:name,Size:properties.contentLength}" -o table

# Download
az storage blob download \
  --account-name "$SA" \
  --container-name labs \
  --name week1/hello.txt \
  --file ./downloaded-hello.txt \
  --auth-mode login
cat downloaded-hello.txt

# Encryption / HTTPS
az storage account show --name "$SA" --resource-group "$RG" \
  --query "{HttpsOnly:enableHttpsTrafficOnly,PublicBlob:allowBlobPublicAccess,Kind:kind}" -o table
```

| Output | Meaning |
|--------|---------|
| Blobs listed under `labs` | Upload succeeded |
| `HttpsOnly: true` | Secure transfer required |
| `PublicBlob: false` | Anonymous public access disabled |

---

## 5. Cleanup Commands

```bash
# Delete all blobs (optional before account delete)
az storage blob delete-batch \
  --account-name "$SA" \
  --source labs \
  --auth-mode login 2>/dev/null || true

# Delete storage account
az storage account delete \
  --name "$SA" \
  --resource-group "$RG" \
  --yes

# Verify
az storage account list --resource-group "$RG" --query "[?name=='${SA}']" -o table
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `StorageAccountAlreadyExists` / name taken | Change `$SA` suffix |
| Auth mode login fails | Assign **Storage Blob Data Contributor**; wait for RBAC |
| Cannot delete account | Empty containers; disable locks; retry |
| Invalid account name | Only lowercase letters and numbers, 3–24 chars |

---

## 7. What We Achieved

- Created private storage account + container via CLI
- Uploaded, versioned, and validated blobs with Entra auth
- Deleted storage account with cleanup commands

**Next:** [mysql.md](mysql.md)
