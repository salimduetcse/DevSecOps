resource "azurerm_resource_group" "lab" {
  name     = "${local.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "lab" {
  name                = "${local.name_prefix}-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "lab" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_security_group" "lab" {
  name                = "${local.name_prefix}-nsg"
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

resource "azurerm_public_ip" "lab" {
  name                = "${local.name_prefix}-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "lab" {
  name                = "${local.name_prefix}-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab.id
  }
}

resource "azurerm_network_interface_security_group_association" "lab" {
  network_interface_id      = azurerm_network_interface.lab.id
  network_security_group_id = azurerm_network_security_group.lab.id
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

resource "azurerm_linux_virtual_machine" "lab" {
  name                = "${local.name_prefix}-vm"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.lab.id
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

resource "azurerm_managed_disk" "data" {
  name                 = "${local.name_prefix}-data"
  location             = azurerm_resource_group.lab.location
  resource_group_name  = azurerm_resource_group.lab.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  tags                 = local.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  managed_disk_id    = azurerm_managed_disk.data.id
  virtual_machine_id = azurerm_linux_virtual_machine.lab.id
  lun                = 0
  caching            = "ReadWrite"
}

resource "azurerm_snapshot" "data" {
  name                = "${local.name_prefix}-snap"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  create_option       = "Copy"
  source_resource_id  = azurerm_managed_disk.data.id
  tags                = local.common_tags

  depends_on = [azurerm_virtual_machine_data_disk_attachment.data]
}
