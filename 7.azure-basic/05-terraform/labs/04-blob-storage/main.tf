resource "random_string" "sa_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "lab" {
  name     = "${local.name_prefix}-blob-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "lab" {
  name                            = substr("${local.sa_base}${random_string.sa_suffix.result}", 0, 24)
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  tags                            = local.common_tags

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "lab" {
  name                  = "lab-content"
  storage_account_id    = azurerm_storage_account.lab.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "hello" {
  name                 = "labs/hello.txt"
  storage_container_id = azurerm_storage_container.lab.id
  type                 = "Block"
  source_content       = "Terraform Blob lab - ${var.student_name}"
}
