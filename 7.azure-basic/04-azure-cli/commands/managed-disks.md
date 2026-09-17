# CLI Lab — Managed Disks

Repeat [Portal lab 04](../../03-console-labs/04-managed-disks/README.md) using Azure CLI.

---

## 1. Theory Reminder

- **Managed Disk** = block storage in a region/zone, attached to a VM
- Attach → format → mount → `/etc/fstab`
- **Snapshot** = backup; restore = new disk from snapshot

---

## 2. Setup — Launch VM First (if needed)

```bash
az login
export LOCATION=southeastasia
export YOURNAME="<yourname>"
export RG="devops-lab-${YOURNAME}-rg"
export VM_NAME="devops-lab-${YOURNAME}-cli-web"
export DISK_NAME="devops-lab-${YOURNAME}-cli-data"
export SNAP_NAME="devops-lab-${YOURNAME}-cli-snap"

az config set defaults.location="$LOCATION"
az config set defaults.group="$RG"

# Use existing VM from vm-default-vnet.md OR create a small Ubuntu VM first
# export VM_NAME="<your-vm-name>"

az vm show --resource-group "$RG" --name "$VM_NAME" --query "{Name:name,Location:location}" -o table
```

---

## 3. Resource Creation Commands

### 3.1 Create data disk

```bash
az disk create \
  --resource-group "$RG" \
  --name "$DISK_NAME" \
  --size-gb 8 \
  --sku Standard_LRS \
  --location "$LOCATION"

echo "Disk: $DISK_NAME"
```

### 3.2 Attach disk to VM

```bash
az vm disk attach \
  --resource-group "$RG" \
  --vm-name "$VM_NAME" \
  --name "$DISK_NAME"
```

### 3.3 Format and mount (SSH)

```bash
export PUBLIC_IP=$(az vm show --resource-group "$RG" --name "$VM_NAME" \
  --show-details --query publicIps -o tsv)

ssh azureuser@"$PUBLIC_IP" << 'EOF'
lsblk
# Use the new disk device from lsblk — often /dev/sdc (not the OS disk)
DATA_DEV=$(lsblk -ndo NAME,TYPE,MOUNTPOINT | awk '$2=="disk" && $3=="" {print "/dev/"$1; exit}')
echo "Using $DATA_DEV"
sudo mkfs -t ext4 "$DATA_DEV"
sudo mkdir -p /data
sudo mount "$DATA_DEV" /data
echo "test" | sudo tee /data/cli-disk-test.txt
UUID=$(sudo blkid -s UUID -o value "$DATA_DEV")
echo "UUID=$UUID  /data  ext4  defaults,nofail  0  2" | sudo tee -a /etc/fstab
df -h /data
EOF
```

### 3.4 Create snapshot

```bash
az snapshot create \
  --resource-group "$RG" \
  --name "$SNAP_NAME" \
  --source "$DISK_NAME" \
  --location "$LOCATION"

az snapshot show --resource-group "$RG" --name "$SNAP_NAME" \
  --query "{Name:name,State:provisioningState,Size:diskSizeGb}" -o table
```

---

## 4. Validation Commands

```bash
az disk show --resource-group "$RG" --name "$DISK_NAME" \
  --query "{Name:name,Size:diskSizeGb,Sku:sku.name,State:diskState}" -o table

az vm show --resource-group "$RG" --name "$VM_NAME" \
  --query "storageProfile.dataDisks[].{Lun:lun,Name:name}" -o table

az snapshot show --resource-group "$RG" --name "$SNAP_NAME" \
  --query "{Name:name,State:provisioningState}" -o table
```

| Output | Meaning |
|--------|---------|
| Disk state `Attached` / `ActiveSAS` variants | Disk in use by VM |
| `dataDisks` lists your disk | Attach succeeded |
| Snapshot `Succeeded` | Backup ready |

---

## 5. Cleanup Commands

```bash
export RG="devops-lab-${YOURNAME}-rg"

# On VM via SSH (if mounted): sudo umount /data

# Detach and delete data disk
az vm disk detach --resource-group "$RG" --vm-name "$VM_NAME" --name "$DISK_NAME"
az disk delete --resource-group "$RG" --name "$DISK_NAME" --yes

# Delete snapshot
az snapshot delete --resource-group "$RG" --name "$SNAP_NAME" --yes

# Delete restored disk if you created one during the lab
if [ -n "${RESTORED_DISK:-}" ]; then
  az vm disk detach --resource-group "$RG" --vm-name "$VM_NAME" --name "$RESTORED_DISK" 2>/dev/null || true
  az disk delete --resource-group "$RG" --name "$RESTORED_DISK" --yes
fi

# Optionally delete VM used for this lab
az vm delete --resource-group "$RG" --name "$VM_NAME" --yes

# Clean leftover OS disks / NICs / PIP / NSG as needed
az disk list --resource-group "$RG" -o table
```

> Backup: [03-console-labs/04-managed-disks/cleanup.md](../../03-console-labs/04-managed-disks/cleanup.md)

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| Wrong device formatted | Always check `lsblk` — never format the OS disk |
| Attach fails | Disk must be in same region as VM |
| Snapshot delete blocked | Confirm disk/snapshot names; wait for Succeeded |

---

## 7. What We Achieved

- Created, attached, formatted Managed Disk via CLI + SSH
- Snapshot with `az snapshot create`
- Cleaned up disks, snapshots, and optional VM

**Next:** [blob-storage.md](blob-storage.md)
