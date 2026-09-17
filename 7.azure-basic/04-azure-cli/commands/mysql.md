# CLI Lab — MySQL Flexible Server

Repeat [Portal lab 06](../../03-console-labs/06-mysql/README.md) using Azure CLI.

> **Cost warning:** Azure Database for MySQL Flexible Server bills while running. Delete same day. Use a small Burstable SKU (`Standard_B1ms`).

---

## 1. Theory Reminder

- **Azure Database for MySQL – Flexible Server** = managed MySQL
- Prefer **VNet integration / private access** in production; this lab uses a small server and connects from a client VM with firewall rules carefully scoped
- Do **not** open MySQL to `0.0.0.0/0` permanently — allow your client VM private IP or temporary My IP for demo only if instructor requires

---

## 2. Setup Variables

```bash
az login
export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
# MySQL server name: globally unique lowercase
export DB_NAME="devops-lab-${YOURNAME}-cli-mysql"
export DB_NAME=$(echo "$DB_NAME" | tr '[:upper:]' '[:lower:]')
export DB_USER="dbadmin"
export DB_PASS="<your-strong-password>"
export MYSQL_DB="devopslab"
export CLIENT_VM="devops-lab-${YOURNAME}-cli-mysql-client"
export MY_IP=$(curl -s https://api.ipify.org)

az group create --name "$RG" --location "$LOCATION"
az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"
```

---

## 3. Resource Creation Commands

### 3.1 Create client VM (to run mysql client)

```bash
az vm create \
  --resource-group "$RG" \
  --name "$CLIENT_VM" \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  --location "$LOCATION"

export CLIENT_IP=$(az vm show --resource-group "$RG" --name "$CLIENT_VM" \
  --show-details --query publicIps -o tsv)
export CLIENT_PRIVATE_IP=$(az vm show --resource-group "$RG" --name "$CLIENT_VM" \
  --show-details --query privateIps -o tsv)

# Restrict SSH on the auto NSG if needed (same pattern as vm-default-vnet.md)
echo "Client public IP: $CLIENT_IP  private: $CLIENT_PRIVATE_IP"
```

### 3.2 Create MySQL Flexible Server

```bash
az mysql flexible-server create \
  --resource-group "$RG" \
  --name "$DB_NAME" \
  --location "$LOCATION" \
  --admin-user "$DB_USER" \
  --admin-password "$DB_PASS" \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 20 \
  --version 8.0.21 \
  --public-access "$CLIENT_IP" \
  --database-name "$MYSQL_DB"

echo "Waiting for server (several minutes is normal)..."
az mysql flexible-server show \
  --resource-group "$RG" \
  --name "$DB_NAME" \
  --query "{Name:name,State:state,FQDN:fullyQualifiedDomainName}" -o table

export DB_FQDN=$(az mysql flexible-server show \
  --resource-group "$RG" --name "$DB_NAME" \
  --query fullyQualifiedDomainName -o tsv)

echo "MySQL FQDN: $DB_FQDN"
```

> **Note:** `--public-access "$CLIENT_IP"` limits firewall to the client VM public IP for this training pattern. Production should prefer private access / VNet integration.

### 3.3 Connect from client VM

```bash
ssh azureuser@"$CLIENT_IP" << EOF
sudo apt-get update -y
sudo apt-get install -y mysql-client
mysql -h ${DB_FQDN} -u ${DB_USER} -p'${DB_PASS}' -e "SHOW DATABASES;"
mysql -h ${DB_FQDN} -u ${DB_USER} -p'${DB_PASS}' ${MYSQL_DB} -e \
  "CREATE TABLE cli_test (id INT PRIMARY KEY, msg VARCHAR(50)); INSERT INTO cli_test VALUES (1,'CLI MySQL works'); SELECT * FROM cli_test;"
EOF
```

---

## 4. Validation Commands

```bash
az mysql flexible-server show \
  --resource-group "$RG" \
  --name "$DB_NAME" \
  --query "{State:state,Version:version,FQDN:fullyQualifiedDomainName,Tier:sku.tier}" \
  -o table

az mysql flexible-server db list \
  --resource-group "$RG" \
  --server-name "$DB_NAME" -o table

az mysql flexible-server firewall-rule list \
  --resource-group "$RG" \
  --name "$DB_NAME" -o table
```

| Field | Expected |
|-------|----------|
| `State` | `Ready` |
| Database | `devopslab` exists |
| Firewall | Limited to client IP (not open world unless you changed it) |

### Optional snapshot-style backup note

Flexible Server managed backups differ from RDS manual snapshots. For training, verify backup settings:

```bash
az mysql flexible-server show \
  --resource-group "$RG" --name "$DB_NAME" \
  --query backup -o json
```

Do not enable long retention for labs.

---

## 5. Cleanup Commands

```bash
# Delete MySQL Flexible Server (stops compute charges)
az mysql flexible-server delete \
  --resource-group "$RG" \
  --name "$DB_NAME" \
  --yes

# Delete client VM
az vm delete --resource-group "$RG" --name "$CLIENT_VM" --yes

# Clean leftover NIC / PIP / disks / NSG / VNet as needed
az disk list --resource-group "$RG" -o table
az network public-ip list --resource-group "$RG" -o table
```

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Connection timeout | Firewall rule must include client public IP; wait for Ready state |
| Name already exists | Change `$DB_NAME` (global uniqueness) |
| Long create time | Normal — several minutes |
| Password special chars | Escape in shell or use a simpler lab password |
| `SKU not available` | Pick another Burstable size available in `southeastasia` |

---

## 7. What We Achieved

- Created MySQL Flexible Server and client VM via CLI
- Connected and ran SQL
- Performed full cleanup

**Next:** [lb-vmss.md](lb-vmss.md)
