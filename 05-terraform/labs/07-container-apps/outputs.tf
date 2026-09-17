output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "acr_name" {
  value = azurerm_container_registry.lab.name
}

output "acr_login_server" {
  value = azurerm_container_registry.lab.login_server
}

output "container_app_name" {
  value = azurerm_container_app.web.name
}

output "http_url" {
  value = "https://${azurerm_container_app.web.latest_revision_fqdn}"
}

output "acr_push_hint" {
  value = "az acr login --name ${azurerm_container_registry.lab.name}"
}
