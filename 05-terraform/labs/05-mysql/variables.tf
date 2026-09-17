variable "location" {
  type    = string
  default = "southeastasia"
}

variable "student_name" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "db_username" {
  type    = string
  default = "adminuser"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "devopslab"
}

variable "mysql_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-mysql"
  # Flex server name: lowercase letters, numbers, hyphens
  mysql_name  = lower("dl-${var.student_name}-tf-mysql-${random_string.suffix.result}")
  student_ip  = replace(var.allowed_ssh_cidr, "/32", "")

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
