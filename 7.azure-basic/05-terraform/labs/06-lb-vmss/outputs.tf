output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "lb_name" {
  value = azurerm_lb.web.name
}

output "frontend_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}

output "http_url" {
  value = "http://${azurerm_public_ip.lb.ip_address}"
}
