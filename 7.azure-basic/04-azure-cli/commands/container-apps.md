# CLI Lab — Container Apps

Repeat [Portal lab 08](../../03-console-labs/08-container-apps/README.md) using Azure CLI + Docker in Git Bash.

> **Cost warning:** Azure Container Apps + ACR — delete same day.

---

## 1. Theory Reminder

- **ACR** stores Docker images
- **Container Apps Environment** + **Container App** run containers (consumption plan for labs)
- Ingress routes HTTP traffic to the container (similar role to ALB in the ECS lab)

---

## 2. Setup Variables

```bash
az login
export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
# ACR name: 5-50 alphanumeric
export ACR="devopslab${YOURNAME}cliacr"
export ACR=$(echo "$ACR" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9' | cut -c1-50)
export ENV="devops-lab-${YOURNAME}-cli-cae"
export APP="devops-lab-${YOURNAME}-cli-app"
export IMAGE="devops-lab-cli-app"

az group create --name "$RG" --location "$LOCATION"
az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"

# Extensions (once per machine)
az extension add --name containerapp --upgrade 2>/dev/null || az extension add --name containerapp
az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.OperationalInsights --wait
```

---

## 3. Resource Creation Commands

### 3.1 Create ACR

```bash
az acr create \
  --resource-group "$RG" \
  --name "$ACR" \
  --sku Basic \
  --location "$LOCATION" \
  --admin-enabled true
```

### 3.2 Build and push image (local Docker)

```bash
mkdir -p /tmp/aca-cli-lab && cd /tmp/aca-cli-lab
echo '<h1>Container Apps CLI Lab — devops-lab</h1>' > index.html
cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF

docker build -t "${IMAGE}:latest" .

az acr login --name "$ACR"
docker tag "${IMAGE}:latest" "${ACR}.azurecr.io/${IMAGE}:latest"
docker push "${ACR}.azurecr.io/${IMAGE}:latest"
```

### 3.3 Create Container Apps Environment

```bash
az containerapp env create \
  --name "$ENV" \
  --resource-group "$RG" \
  --location "$LOCATION"
```

### 3.4 Get ACR credentials for pull

```bash
export ACR_USER=$(az acr credential show --name "$ACR" --query username -o tsv)
export ACR_PASS=$(az acr credential show --name "$ACR" --query "passwords[0].value" -o tsv)
```

> Treat `$ACR_PASS` like a secret — do not paste into Git or chat.

### 3.5 Create Container App with external HTTP ingress

```bash
az containerapp create \
  --name "$APP" \
  --resource-group "$RG" \
  --environment "$ENV" \
  --image "${ACR}.azurecr.io/${IMAGE}:latest" \
  --target-port 80 \
  --ingress external \
  --registry-server "${ACR}.azurecr.io" \
  --registry-username "$ACR_USER" \
  --registry-password "$ACR_PASS" \
  --cpu 0.25 \
  --memory 0.5Gi \
  --min-replicas 1 \
  --max-replicas 2

# Optional: scale toward 2 replicas for labs
az containerapp update \
  --name "$APP" \
  --resource-group "$RG" \
  --min-replicas 2 \
  --max-replicas 2

echo "Wait 1–3 minutes for revision healthy..."
sleep 90
```

### 3.6 Test FQDN

```bash
export APP_FQDN=$(az containerapp show \
  --name "$APP" --resource-group "$RG" \
  --query properties.configuration.ingress.fqdn -o tsv)

curl -s "https://${APP_FQDN}" | head -5
echo "App URL: https://${APP_FQDN}"
```

---

## 4. Validation Commands

```bash
az containerapp show --name "$APP" --resource-group "$RG" \
  --query "{Name:name,Provisioning:properties.provisioningState,FQDN:properties.configuration.ingress.fqdn}" -o table

az containerapp revision list --name "$APP" --resource-group "$RG" -o table

az acr repository show-tags --name "$ACR" --repository "$IMAGE" -o table
```

| Output | Expected |
|--------|----------|
| Provisioning | `Succeeded` |
| Revision | Active / healthy |
| curl HTTPS FQDN | HTML from container |

---

## 5. Cleanup Commands

```bash
# Delete Container App then Environment
az containerapp delete --name "$APP" --resource-group "$RG" --yes
az containerapp env delete --name "$ENV" --resource-group "$RG" --yes

# Delete ACR (removes images)
az acr delete --name "$ACR" --resource-group "$RG" --yes

# Unset secrets from shell
unset ACR_PASS ACR_USER

# Optional: Log Analytics workspace created with environment — list and delete if leftover
az monitor log-analytics workspace list --resource-group "$RG" -o table
# az monitor log-analytics workspace delete --resource-group "$RG" --workspace-name <name> --yes
```

> Backup: [03-console-labs/08-container-apps/cleanup.md](../../03-console-labs/08-container-apps/cleanup.md)

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Cannot pull image | Check ACR login + registry credentials on the app |
| Ingress not ready | Wait; check revision status |
| Provider not registered | `az provider register --namespace Microsoft.App` |
| Docker login fail | `az acr login --name "$ACR"` after `az login` |
| ACR name invalid | Lowercase alphanumeric only |
| Extension missing | `az extension add --name containerapp` |

---

## 7. What We Achieved

- ACR push, Container Apps Environment, and Container App with ingress via CLI
- Validated HTTPS endpoint
- Complete cleanup of Container Apps + ACR

**CLI module complete!** Next: [05-terraform](../../05-terraform/README.md)
