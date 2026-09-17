# CLI Lab — Load Balancer and VM Scale Set

Repeat [Portal lab 07](../../03-console-labs/07-load-balancer-vmss/README.md) using Azure CLI.

> **Cost warning:** Load Balancer + 2× VMSS instances — delete same day.

---

## 1. Theory Reminder

- **Custom image / cloud-init** → **VM Scale Set** registers behind a **Load Balancer**
- **LB** frontend public IP listens HTTP:80 and forwards to backend pool
- **NSG:** allow HTTP to LB; app instances receive traffic from LB health probes / backend rules

---

## 2. Setup Variables

```bash
az login
export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
export VNET="devops-lab-${YOURNAME}-cli-lb-vnet"
export SUBNET="backend"
export NSG="devops-lab-${YOURNAME}-cli-app-nsg"
export LB="devops-lab-${YOURNAME}-cli-lb"
export PIP="devops-lab-${YOURNAME}-cli-lb-pip"
export VMSS="devops-lab-${YOURNAME}-cli-vmss"
export PROBE="http-probe"
export RULE="http-rule"

az group create --name "$RG" --location "$LOCATION"
az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"
```

---

## 3. Resource Creation Commands

### 3.1 Network + NSG

```bash
az network vnet create \
  --resource-group "$RG" \
  --name "$VNET" \
  --address-prefix 10.10.0.0/16 \
  --subnet-name "$SUBNET" \
  --subnet-prefix 10.10.1.0/24 \
  --location "$LOCATION"

az network nsg create --resource-group "$RG" --name "$NSG" --location "$LOCATION"

# HTTP from Internet (lab LB front door)
az network nsg rule create \
  --resource-group "$RG" --nsg-name "$NSG" \
  --name AllowHTTP --priority 1000 --access Allow --protocol Tcp \
  --direction Inbound --source-address-prefixes '*' \
  --destination-port-ranges 80

# Lab-only SSH from Internet (training reliability). Prefer My IP in production.
az network nsg rule create \
  --resource-group "$RG" --nsg-name "$NSG" \
  --name AllowSSHLab --priority 1010 --access Allow --protocol Tcp \
  --direction Inbound --source-address-prefixes '*' \
  --destination-port-ranges 22

az network vnet subnet update \
  --resource-group "$RG" --vnet-name "$VNET" --name "$SUBNET" \
  --network-security-group "$NSG"
```

> **Lab-only exception:** SSH on `*` helps students finish bootstrap reliably. Do not use this in production; restrict to My IP or use Azure Bastion / Run Command.

### 3.2 Public IP + Load Balancer

```bash
az network public-ip create \
  --resource-group "$RG" \
  --name "$PIP" \
  --sku Standard \
  --allocation-method Static \
  --location "$LOCATION"

az network lb create \
  --resource-group "$RG" \
  --name "$LB" \
  --sku Standard \
  --public-ip-address "$PIP" \
  --frontend-ip-name frontend \
  --backend-pool-name backendpool \
  --location "$LOCATION"

az network lb probe create \
  --resource-group "$RG" \
  --lb-name "$LB" \
  --name "$PROBE" \
  --protocol Http \
  --port 80 \
  --path /

az network lb rule create \
  --resource-group "$RG" \
  --lb-name "$LB" \
  --name "$RULE" \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name frontend \
  --backend-pool-name backendpool \
  --probe-name "$PROBE"
```

### 3.3 VM Scale Set with nginx cloud-init

```bash
cat > /tmp/vmss-cloud-init.yaml << 'EOF'
#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx --now
  - echo "<h1>LB-VMSS CLI Lab — devops-lab</h1>" > /var/www/html/index.html
EOF

az vmss create \
  --resource-group "$RG" \
  --name "$VMSS" \
  --image Ubuntu2204 \
  --instance-count 2 \
  --vm-sku Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name "$VNET" \
  --subnet "$SUBNET" \
  --lb "$LB" \
  --backend-pool-name backendpool \
  --nsg "$NSG" \
  --upgrade-policy-mode Manual \
  --custom-data /tmp/vmss-cloud-init.yaml \
  --location "$LOCATION"

echo "Wait 3–5 min for instances + health probes..."
sleep 180
```

### 3.4 Test LB public IP

```bash
export LB_IP=$(az network public-ip show \
  --resource-group "$RG" --name "$PIP" --query ipAddress -o tsv)

curl -s "http://${LB_IP}" | head -5
echo "LB IP: $LB_IP"
```

---

## 4. Validation Commands

```bash
az vmss list-instances --resource-group "$RG" --name "$VMSS" \
  --query "[].{Name:name,Provisioning:provisioningState}" -o table

az network lb show --resource-group "$RG" --name "$LB" \
  --query "{Name:name,SKU:sku.name}" -o table

az network lb rule list --resource-group "$RG" --lb-name "$LB" -o table
```

| Output | Expected |
|--------|----------|
| Instance count | `2` |
| curl LB IP | nginx HTML |
| Probe | HTTP `/` on port 80 |

---

## 5. Cleanup Commands

```bash
# Delete VMSS first (instances)
az vmss delete --resource-group "$RG" --name "$VMSS" --yes

# Delete LB and public IP
az network lb delete --resource-group "$RG" --name "$LB"
az network public-ip delete --resource-group "$RG" --name "$PIP"

# Delete NSG and VNet
az network nsg delete --resource-group "$RG" --name "$NSG"
az network vnet delete --resource-group "$RG" --name "$VNET"

# Leftover disks
az disk list --resource-group "$RG" -o table
rm -f /tmp/vmss-cloud-init.yaml
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Unhealthy / curl fails | Wait for cloud-init; confirm probe path `/`; check NSG allows 80 |
| LB timeout | Confirm rule maps frontend 80 → backend 80 with probe |
| VMSS create fails | Verify subnet, LB backend pool name, quotas |
| SSH wide open | Lab-only — tighten to My IP after connect |

---

## 7. What We Achieved

- Built VNet, NSG, Load Balancer, and VMSS via CLI
- Tested HTTP via LB public IP
- Included cleanup for VMSS, LB, PIP, NSG, and VNet

**Next:** [container-apps.md](container-apps.md)
