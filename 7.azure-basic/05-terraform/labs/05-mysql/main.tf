resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "lab" {
  name     = "${local.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "lab" {
  name                = "${local.name_prefix}-vnet"
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "lab" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.30.1.0/24"]
}

resource "azurerm_network_security_group" "client" {
  name                = "${local.name_prefix}-client-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "client" {
  name                = "${local.name_prefix}-client-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "client" {
  name                = "${local.name_prefix}-client-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.client.id
  }
}

resource "azurerm_network_interface_security_group_association" "client" {
  network_interface_id      = azurerm_network_interface.client.id
  network_security_group_id = azurerm_network_security_group.client.id
}

resource "tls_private_key" "lab" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.lab.private_key_pem
  filename        = "${path.module}/${local.name_prefix}-key.pem"
  file_permission = "0400"
}

resource "azurerm_linux_virtual_machine" "client" {
  name                = "${local.name_prefix}-client"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.client.id
  ]
  tags = local.common_tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.lab.public_key_openssh
  }

  os_disk {
    name                 = "${local.name_prefix}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_mysql_flexible_server" "lab" {
  name                   = local.mysql_name
  resource_group_name    = azurerm_resource_group.lab.name
  location               = azurerm_resource_group.lab.location
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = var.mysql_sku
  version                = "8.0.21"
  # Let Azure pick an availability zone (hardcoding zone often fails by region)
  backup_retention_days  = 1
  tags                   = local.common_tags

  storage {
    size_gb = 20
  }
}

resource "azurerm_mysql_flexible_database" "lab" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_mysql_flexible_server.lab.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Firewall: allow client VM public IP
resource "azurerm_mysql_flexible_server_firewall_rule" "client" {
  name                = "allow-client-vm"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_mysql_flexible_server.lab.name
  start_ip_address    = azurerm_public_ip.client.ip_address
  end_ip_address      = azurerm_public_ip.client.ip_address
}

# Firewall: allow student IP (for optional direct test from laptop)
resource "azurerm_mysql_flexible_server_firewall_rule" "student" {
  name                = "allow-student"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_mysql_flexible_server.lab.name
  start_ip_address    = local.student_ip
  end_ip_address      = local.student_ip
}
