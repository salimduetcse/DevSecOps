# CLI Lab — Custom VNet VM

Repeat [Portal lab 03](../../03-console-labs/03-custom-vnet-vm/README.md) using Azure CLI.

---

## 1. Theory Reminder

- **Custom VNet** with address space `10.0.0.0/16`
- **Public subnet** `10.0.1.0/24` (internet via system default routes when public IP is attached)
- **NSG** with SSH/HTTP from My IP
- **No NAT Gateway** (costly — skip)

---

## 2. Setup Variables

```bash
az login
export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
export VNET="devops-lab-${YOURNAME}-cli-vnet"
export SUBNET="public"
export NSG="devops-lab-${YOURNAME}-vpc-cli-nsg"
export VM_NAME="devops-lab-${YOURNAME}-vpc-cli-web"
export PIP="devops-lab-${YOURNAME}-vpc-cli-pip"
export NIC="devops-lab-${YOURNAME}-vpc-cli-nic"
export VNET_CIDR="10.0.0.0/16"
export PUB_CIDR="10.0.1.0/24"
export MY_IP=$(curl -s https://api.ipify.org)

az group create --name "$RG" --location "$LOCATION"
az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"
```

---

## 3. Resource Creation Commands

### 3.1 Create VNet + public subnet

```bash
az network vnet create \
  --resource-group "$RG" \
  --name "$VNET" \
  --address-prefix "$VNET_CIDR" \
  --subnet-name "$SUBNET" \
  --subnet-prefix "$PUB_CIDR" \
  --location "$LOCATION"

echo "VNet: $VNET"
```

### 3.2 Create NSG and rules

```bash
az network nsg create \
  --resource-group "$RG" \
  --name "$NSG" \
  --location "$LOCATION"

az network nsg rule create \
  --resource-group "$RG" --nsg-name "$NSG" \
  --name AllowSSHMyIP --priority 1000 --access Allow --protocol Tcp \
  --direction Inbound --source-address-prefixes "${MY_IP}/32" \
  --destination-port-ranges 22

az network nsg rule create \
  --resource-group "$RG" --nsg-name "$NSG" \
  --name AllowHTTPMyIP --priority 1010 --access Allow --protocol Tcp \
  --direction Inbound --source-address-prefixes "${MY_IP}/32" \
  --destination-port-ranges 80

# Associate NSG to subnet
az network vnet subnet update \
  --resource-group "$RG" \
  --vnet-name "$VNET" \
  --name "$SUBNET" \
  --network-security-group "$NSG"
```

### 3.3 Public IP + NIC

```bash
az network public-ip create \
  --resource-group "$RG" \
  --name "$PIP" \
  --sku Standard \
  --allocation-method Static \
  --location "$LOCATION"

az network nic create \
  --resource-group "$RG" \
  --name "$NIC" \
  --vnet-name "$VNET" \
  --subnet "$SUBNET" \
  --network-security-group "$NSG" \
  --public-ip-address "$PIP" \
  --location "$LOCATION"
```

### 3.4 Create VM on custom NIC

```bash
az vm create \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --nics "$NIC" \
  --location "$LOCATION"

export PUBLIC_IP=$(az network public-ip show \
  --resource-group "$RG" --name "$PIP" --query ipAddress -o tsv)

echo "Public IP: $PUBLIC_IP"
```

### 3.5 nginx

```bash
ssh -o StrictHostKeyChecking=accept-new azureuser@"$PUBLIC_IP" \
  'sudo apt-get update -y && sudo apt-get install -y nginx && sudo systemctl enable nginx --now && curl -s localhost | head -3'

curl -s "http://${PUBLIC_IP}" | head -5
```

---

## 4. Validation Commands

```bash
az network vnet show --resource-group "$RG" --name "$VNET" \
  --query "{Name:name,AddressSpace:addressSpace.addressPrefixes}" -o json

az network vnet subnet show --resource-group "$RG" --vnet-name "$VNET" --name "$SUBNET" \
  --query "{Prefix:addressPrefix,NSG:networkSecurityGroup.id}" -o json

az vm show --resource-group "$RG" --name "$VM_NAME" --show-details \
  --query "{Name:name,PublicIP:publicIps,PrivateIP:privateIps}" -o table
```

| Field | Expected |
|-------|----------|
| VNet address space | `10.0.0.0/16` |
| Subnet | `10.0.1.0/24` with NSG attached |
| VM public IP | Matches `$PIP` |

---

## 5. Cleanup Commands

```bash
# Delete VM first
az vm delete --resource-group "$RG" --name "$VM_NAME" --yes

# Delete NIC, public IP, NSG, VNet (order matters)
az network nic delete --resource-group "$RG" --name "$NIC"
az network public-ip delete --resource-group "$RG" --name "$PIP"
az network nsg delete --resource-group "$RG" --name "$NSG"
az network vnet delete --resource-group "$RG" --name "$VNET"

# OS disk often remains
az disk list --resource-group "$RG" -o table
# az disk delete --resource-group "$RG" --name <os-disk> --yes

# Verify
az vm list --resource-group "$RG" --query "[?name=='${VM_NAME}']" -o table
az network vnet list --resource-group "$RG" -o table
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Cannot delete VNet | Delete VM, NIC, PIP first |
| No internet on VM | Confirm public IP on NIC; check NSG allows outbound |
| SSH timeout | Refresh `MY_IP` in NSG rule |
| NicInUse | Deallocate/delete VM before NIC delete |

---

## 7. What We Achieved

- Built custom VNet stack entirely via CLI
- Launched VM, tested nginx, validated networking
- Deleted all resources in correct order

**Next:** [managed-disks.md](managed-disks.md)
