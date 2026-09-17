output "db_fqdn" {
  value = azurerm_mysql_flexible_server.lab.fqdn
}

output "client_public_ip" {
  value = azurerm_public_ip.client.ip_address
}

output "ssh_command" {
  value = "ssh -i ${local.name_prefix}-key.pem ${var.admin_username}@${azurerm_public_ip.client.ip_address}"
}

output "mysql_test_command" {
  value = "mysql -h ${azurerm_mysql_flexible_server.lab.fqdn} -u ${var.db_username} -p"
}
