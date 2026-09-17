# Terraform Lab 07 — Container Apps with ACR

> **Cost warning:** Container Apps + ACR — destroy same day.

## 1. Architecture

ACR → Container Apps environment → Container App (external ingress) → internet.

Default image: public nginx (works without docker push). Optional: push to ACR and set `container_image` in tfvars.

## 2. Files

Creates Log Analytics workspace, Container Apps environment, ACR (Basic), and Container App with HTTP ingress.

## 3. Commands

```bash
cd 05-terraform/labs/07-container-apps
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
# Wait 2-5 min
```

### Optional ACR push

```bash
terraform output -raw acr_push_hint
# docker build, tag, push — then update container_image in tfvars and terraform apply
```

Example push workflow:

```bash
az acr login --name $(terraform output -raw acr_name)
docker pull nginx:alpine
docker tag nginx:alpine $(terraform output -raw acr_login_server)/lab-web:latest
docker push $(terraform output -raw acr_login_server)/lab-web:latest
# set container_image = "<login_server>/lab-web:latest" in tfvars, then terraform apply
```

## 4. Expected Output

`http_url`, `acr_login_server`, `container_app_name`

## 5. Validation

```bash
curl $(terraform output -raw http_url)
az containerapp show \
  --name $(terraform output -raw container_app_name) \
  --resource-group $(terraform output -raw resource_group_name) \
  --query "{fqdn:properties.configuration.ingress.fqdn,running:properties.runningStatus}" -o table
```

## 6. Cleanup

```bash
terraform destroy
```

Removes Container App, environment, Log Analytics, ACR, and Resource Group. If destroy fails, delete the Resource Group in Portal.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| Ingress 404 / empty | Wait for revision to become Running |
| Cannot pull from ACR | Enable admin or registry credentials; check image URI |
| Name already exists | ACR names are globally unique — random suffix helps |

## 8. What We Achieved

- Full Container Apps + ACR stack in Terraform

**Terraform labs complete!** Next: [06-capstone-project](../../06-capstone-project/)
