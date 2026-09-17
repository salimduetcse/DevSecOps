output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.lab.name
}

output "public_ip" {
  description = "Public IP for SSH and browser"
  value       = azurerm_public_ip.web.ip_address
}

output "ssh_command" {
  description = "SSH command (run from Git Bash in this folder)"
  value       = "ssh -i ${local.name_prefix}-key.pem ${var.admin_username}@${azurerm_public_ip.web.ip_address}"
}

output "http_url" {
  description = "nginx test URL"
  value       = "http://${azurerm_public_ip.web.ip_address}"
}
