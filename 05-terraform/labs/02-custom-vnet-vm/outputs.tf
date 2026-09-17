output "vnet_id" {
  value = azurerm_virtual_network.lab.id
}

output "public_ip" {
  value = azurerm_public_ip.web.ip_address
}

output "ssh_command" {
  value = "ssh -i ${local.name_prefix}-key.pem ${var.admin_username}@${azurerm_public_ip.web.ip_address}"
}

output "http_url" {
  value = "http://${azurerm_public_ip.web.ip_address}"
}
