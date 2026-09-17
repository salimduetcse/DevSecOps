# Azure CLI Command Cheatsheet

Quick reference for **location `southeastasia`** and resource group **`devops-lab-<yourname>-rg`**.

---

## Global Options (Every Session)

```bash
az login
az account set --subscription "<subscription-name-or-id>"

export YOURNAME=alice   # change me — short lowercase; avoid <angle-brackets> in Bash
export LOCATION=southeastasia
export RG="devops-lab-${YOURNAME}-rg"

az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"

# Or per command:
az group list --resource-group "$RG" --location "$LOCATION"
```

---

## Identity and Account

```bash
az account show
az account list --output table
az ad signed-in-user show
az config get defaults.location
az config get defaults.group
```

---

## Resource Groups

```bash
az group create --name "$RG" --location southeastasia
az group show --name "$RG"
az group list --output table
az group delete --name "$RG" --yes --no-wait
```

---

## Virtual Machines

```bash
# List VMs
az vm list --resource-group "$RG" \
  --query "[].{Name:name,State:powerState,Location:location}" \
  --output table \
  --show-details

# Create Ubuntu VM (example shape — full labs use dedicated guides)
az vm create \
  --resource-group "$RG" \
  --name "devops-lab-${YOURNAME}-cli-web" \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  --location southeastasia

# Open ports via NSG rules (see full lab guides for My IP CIDR)

# Deallocate / delete
az vm deallocate --resource-group "$RG" --name "devops-lab-${YOURNAME}-cli-web"
az vm delete --resource-group "$RG" --name "devops-lab-${YOURNAME}-cli-web" --yes
```

---

## Virtual Network

```bash
az network vnet create --resource-group "$RG" --name <vnet> \
  --address-prefix 10.0.0.0/16 --subnet-name public --subnet-prefix 10.0.1.0/24 \
  --location southeastasia
az network vnet list --resource-group "$RG" --output table
az network vnet subnet create --resource-group "$RG" --vnet-name <vnet> \
  --name public --address-prefixes 10.0.1.0/24
```

---

## Managed Disks

```bash
az disk create --resource-group "$RG" --name <disk-name> --size-gb 8 --sku Standard_LRS \
  --location southeastasia
az vm disk attach --resource-group "$RG" --vm-name <vm-name> --name <disk-name>
az snapshot create --resource-group "$RG" --name <snap-name> --source <disk-name>
```

---

## Blob Storage

```bash
az storage account create --name <unique-sa-name> --resource-group "$RG" \
  --location southeastasia --sku Standard_LRS --kind StorageV2
az storage container create --account-name <sa> --name labs --auth-mode login
az storage blob upload --account-name <sa> --container-name labs \
  --name week1/hello.txt --file ./hello.txt --auth-mode login
az storage account delete --name <sa> --resource-group "$RG" --yes
```

---

## MySQL Flexible Server

```bash
az mysql flexible-server list --resource-group "$RG" --output table
az mysql flexible-server create --resource-group "$RG" --name <server> \
  --location southeastasia --sku-name Standard_B1ms --tier Burstable \
  --storage-size 20 --version 8.0.21 \
  --admin-user <user> --admin-password '<password>'
az mysql flexible-server delete --resource-group "$RG" --name <server> --yes
```

---

## Load Balancer / VMSS

```bash
az network lb list --resource-group "$RG" --output table
az vmss list --resource-group "$RG" --output table
az vmss list-instances --resource-group "$RG" --name <vmss> --output table
```

---

## Container Apps / ACR

```bash
az acr list --resource-group "$RG" --output table
az containerapp list --resource-group "$RG" --output table
az containerapp show --name <app> --resource-group "$RG"
az acr login --name <acr-name>
```

---

## Useful Modifiers

| Flag / Tool | Purpose |
|-------------|---------|
| `--query` | JMESPath filter |
| `--output table` | Readable table |
| `--output tsv` | Script-friendly |
| `--only-show-errors` | Quieter output |
| `az ... --help` | Built-in help |

---

## Get Your Public IP (NSG Rules)

```bash
export MY_IP=$(curl -s https://api.ipify.org)
echo "$MY_IP"
# NSG CIDR often: ${MY_IP}/32
```

---

## Common CLI Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `Please run 'az login'` | No session | `az login` |
| `AuthorizationFailed` | Missing RBAC | Contributor on RG/subscription |
| `ResourceGroupNotFound` | Wrong RG / defaults | `az config get defaults.group` |
| `SkuNotAvailable` / location error | Wrong region or SKU | Use `southeastasia` and supported SKUs |
| Name already exists | Global uniqueness (storage, MySQL, ACR) | Add random suffix |
| Cannot delete VNet/NSG | Dependency order | Delete VM/NIC/PIP first |
| SSH timeout | NSG / wrong IP | Update source address prefix to `MY_IP/32` |
| `az: command not found` | PATH | Reinstall CLI; fix PATH in Git Bash |
| JSON quoting in Git Bash | Shell escaping | Prefer single quotes around JSON |

### Debug mode

```bash
az vm list --debug 2>&1 | less
```

### Disable color / simplify

```bash
export AZURE_CORE_NO_COLOR=true
```

---

## Security Reminder

- Prefer `az login` for daily student work
- Never commit `~/.azure/` or client secrets
- Never put secrets in shell scripts in Git
- Use `.gitignore` for `*.pem`, `.azure/`, secret `.json`, `.env`

---

## What We Achieved

- Quick reference for all major services
- Troubleshooting guide for common CLI errors

**Next:** [06-cli-labs-same-order-as-console.md](06-cli-labs-same-order-as-console.md)
