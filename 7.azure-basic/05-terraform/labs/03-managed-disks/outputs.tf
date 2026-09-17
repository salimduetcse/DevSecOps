output "vm_id" {
  value = azurerm_linux_virtual_machine.lab.id
}

output "disk_id" {
  value = azurerm_managed_disk.data.id
}

output "snapshot_id" {
  value = azurerm_snapshot.data.id
}

output "public_ip" {
  value = azurerm_public_ip.lab.ip_address
}

output "ssh_command" {
  value = "ssh -i ${local.name_prefix}-key.pem ${var.admin_username}@${azurerm_public_ip.lab.ip_address}"
}

output "format_mount_hint" {
  value = "SSH: sudo mkfs -t xfs /dev/sdc; sudo mkdir -p /data; sudo mount /dev/sdc /data  # device letter may vary — check lsblk"
}
