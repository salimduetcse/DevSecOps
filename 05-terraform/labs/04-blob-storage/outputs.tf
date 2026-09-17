output "storage_account_name" {
  value = azurerm_storage_account.lab.name
}

output "container_name" {
  value = azurerm_storage_container.lab.name
}

output "blob_name" {
  value = azurerm_storage_blob.hello.name
}

output "list_command" {
  value = "az storage blob list --account-name ${azurerm_storage_account.lab.name} --container-name ${azurerm_storage_container.lab.name} --auth-mode login -o table"
}
