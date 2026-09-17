variable "location" {
  type    = string
  default = "southeastasia"
}

variable "student_name" {
  type = string
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "allowed_http_cidr" {
  type    = string
  default = ""
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-vnet"
  http_cidr   = var.allowed_http_cidr != "" ? var.allowed_http_cidr : var.allowed_ssh_cidr

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
