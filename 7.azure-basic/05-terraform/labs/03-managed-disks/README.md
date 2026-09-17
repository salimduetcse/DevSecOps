# Terraform Lab 03 — Managed Disks

## 1. Architecture

Linux VM + attached `azurerm_managed_disk` + `azurerm_snapshot`.

## 2. Files

| File | Purpose |
|------|---------|
| `main.tf` | RG, VNet, VM, managed data disk, attachment, snapshot |
| `outputs.tf` | IDs + SSH + format hint |

After apply, **SSH manually** to format/mount (Portal lab step) — Terraform attaches the disk only.

## 3. Commands

```bash
cd 05-terraform/labs/03-managed-disks
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
terraform output format_mount_hint
```

## 4. Expected Output

Disk and snapshot IDs; VM public IP.

## 5. Validation

```bash
ssh -i *.pem azureuser@$(terraform output -raw public_ip) 'lsblk'
```

## 6. Cleanup

```bash
terraform destroy
```

Destroys VM, attached managed disk, snapshot, NSG, and keys. Unmount `/data` on the instance first if you formatted the disk via SSH (optional — destroy deallocates the VM).

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| Disk attach fails | Lun/caching conflict — use Lun `0` and `ReadWrite` for data disk |
| Destroy stuck | Detach happens as part of destroy; retry `terraform destroy` |

## 8. What We Achieved

- Managed disk and snapshot as Terraform resources

**Next:** [../04-blob-storage/](../04-blob-storage/)
