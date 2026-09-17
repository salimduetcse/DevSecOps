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

variable "disk_size_gb" {
  type    = number
  default = 8
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-disk"

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
