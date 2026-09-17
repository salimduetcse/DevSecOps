variable "location" {
  type    = string
  default = "southeastasia"
}

variable "student_name" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "vmss_capacity" {
  type    = number
  default = 2
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-lb"

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
