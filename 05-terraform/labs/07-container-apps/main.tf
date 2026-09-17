resource "random_string" "acr_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "lab" {
  name     = "${local.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_log_analytics_workspace" "lab" {
  name                = "${local.name_prefix}-law"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_container_app_environment" "lab" {
  name                       = "${local.name_prefix}-env"
  location                   = azurerm_resource_group.lab.location
  resource_group_name        = azurerm_resource_group.lab.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id
  tags                       = local.common_tags
}

resource "azurerm_container_registry" "lab" {
  name                = substr("${local.acr_base}${random_string.acr_suffix.result}", 0, 50)
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = local.common_tags
}

resource "azurerm_container_app" "web" {
  name                         = local.app_name
  container_app_environment_id = azurerm_container_app_environment.lab.id
  resource_group_name          = azurerm_resource_group.lab.name
  revision_mode                = "Single"
  tags                         = local.common_tags

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "web"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  # Wired so students can later set container_image to an ACR push
  registry {
    server               = azurerm_container_registry.lab.login_server
    username             = azurerm_container_registry.lab.admin_username
    password_secret_name = "acr-pwd"
  }

  secret {
    name  = "acr-pwd"
    value = azurerm_container_registry.lab.admin_password
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
