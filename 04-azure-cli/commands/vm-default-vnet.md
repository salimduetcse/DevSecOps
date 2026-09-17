# CLI Lab — VM Default VNet

Repeat [Portal lab 02](../../03-console-labs/02-vm-default-vnet/README.md) using Azure CLI in Git Bash.

---

## 1. Theory Reminder

- **Azure VM** = virtual server in a **VNet**
- Creating a VM without a custom VNet lets Azure create a **default-style network stack** (VNet, subnet, NIC, public IP, NSG)
- **NSG** = firewall — use **My IP** for SSH, not `0.0.0.0/0`
- **SSH key** = authentication (`--generate-ssh-keys` or existing key)

---

## 2. Setup Variables

```bash
az login
az account show --output table

export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
export VM_NAME="devops-lab-${YOURNAME}-cli-web"
export NSG_NAME="devops-lab-${YOURNAME}-cli-vm-nsg"
export MY_IP=$(curl -s https://api.ipify.org)

az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"

echo "My IP: $MY_IP"
az group create --name "$RG" --location "$LOCATION"
```

---

## 3. Resource Creation Commands

### 3.1 Create Ubuntu VM (Azure creates VNet/NIC/PIP/NSG)

```bash
az vm create \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  --nsg "$NSG_NAME" \
  --location "$LOCATION"

# Capture public IP
export PUBLIC_IP=$(az vm show \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --show-details \
  --query publicIps -o tsv)

echo "Public IP: $PUBLIC_IP"
```

> Keys are written under `~/.ssh/id_rsa` / `id_rsa.pub` when generating for the first time. Restrict permissions: `chmod 400 ~/.ssh/id_rsa`.

### 3.2 Restrict SSH and HTTP to My IP only

`az vm create` may open SSH widely by default. Replace wide rules with **My IP**.

```bash
# List rules
az network nsg rule list --resource-group "$RG" --nsg-name "$NSG_NAME" -o table

# Delete overly open default SSH rule if present (name may be default-allow-ssh)
az network nsg rule delete \
  --resource-group "$RG" \
  --nsg-name "$NSG_NAME" \
  --name default-allow-ssh 2>/dev/null || true

# SSH from My IP only
az network nsg rule create \
  --resource-group "$RG" \
  --nsg-name "$NSG_NAME" \
  --name AllowSSHMyIP \
  --priority 1000 \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes "${MY_IP}/32" \
  --destination-port-ranges 22

# HTTP from My IP only
az network nsg rule create \
  --resource-group "$RG" \
  --nsg-name "$NSG_NAME" \
  --name AllowHTTPMyIP \
  --priority 1010 \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes "${MY_IP}/32" \
  --destination-port-ranges 80
```

> **Security:** We use `$MY_IP/32` — not `0.0.0.0/0` for SSH.

### 3.3 SSH and install nginx

```bash
ssh -o StrictHostKeyChecking=accept-new azureuser@"$PUBLIC_IP" << 'EOF'
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx --now
echo "<h1>CLI Lab VM — devops-lab</h1>" | sudo tee /var/www/html/index.html
curl -s localhost | head -5
EOF
```

---

## 4. Validation Commands

```bash
# VM state
az vm get-instance-view \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --query "instanceView.statuses[?starts_with(code,'PowerState/')].displayStatus" \
  --output tsv

# Public IP
az vm show --resource-group "$RG" --name "$VM_NAME" --show-details \
  --query "{Name:name,PublicIP:publicIps,PrivateIP:privateIps}" -o table

# NSG rules
az network nsg rule list --resource-group "$RG" --nsg-name "$NSG_NAME" \
  --query "[].{Name:name,Port:destinationPortRange,Source:sourceAddressPrefix}" -o table

# HTTP test from laptop (Git Bash)
curl -s "http://${PUBLIC_IP}" | head -5
```

### Output explanation

| Output | Meaning |
|--------|---------|
| Power state `VM running` | Instance is up |
| `PublicIP` | SSH and browser target |
| NSG port 22 from your IP | SSH allowed from your CIDR |
| curl HTML | nginx responding on port 80 |

---

## 5. Cleanup Commands

```bash
export RG="devops-lab-${YOURNAME}-rg"
export VM_NAME="devops-lab-${YOURNAME}-cli-web"

# Delete VM and attached disks/NICs as prompted; for training, deleting the RG is simplest
az vm delete --resource-group "$RG" --name "$VM_NAME" --yes

# Orphaned disks / NICs / PIP / NSG may remain — delete RG if this RG is lab-only:
# az group delete --name "$RG" --yes --no-wait

# Safer granular cleanup when RG is shared:
az network public-ip list --resource-group "$RG" -o table
az network nic list --resource-group "$RG" -o table
az network nsg list --resource-group "$RG" -o table
az network vnet list --resource-group "$RG" -o table

# Example deletes (adjust names from list output):
# az network nsg delete --resource-group "$RG" --name "$NSG_NAME"
# az network public-ip delete --resource-group "$RG" --name <pip-name>
# az network nic delete --resource-group "$RG" --name <nic-name>
# az network vnet delete --resource-group "$RG" --name <vnet-name>
# az disk list --resource-group "$RG" -o table
# az disk delete --resource-group "$RG" --name <os-disk-name> --yes

# Verify no VM
az vm list --resource-group "$RG" --query "[?name=='${VM_NAME}']" -o table
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| SSH timeout | Update NSG with new `MY_IP`; confirm VM running |
| Permission denied (publickey) | Use `azureuser` and the key generated by `--generate-ssh-keys` |
| No public IP | Ensure `--public-ip-sku Standard` on create |
| `AuthorizationFailed` | Check RBAC Contributor on RG |
| Wrong location | Confirm `--location southeastasia` / defaults |

---

## 7. What We Achieved

- Created VM, NSG rules, and network resources via CLI
- Installed nginx over SSH
- Validated with `az vm show` and `curl`
- Cleaned up resources with CLI commands

**Next:** [custom-vnet-vm.md](custom-vnet-vm.md)
