variable "location" {
  description = "Azure region"
  type        = string
  default     = "southeastasia"
}

variable "student_name" {
  description = "Your name for resource naming"
  type        = string
}

variable "vm_size" {
  description = "VM size — Free trial friendly"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Linux admin username"
  type        = string
  default     = "azureuser"
}

variable "allowed_ssh_cidr" {
  description = "Your public IP with /32 for SSH — e.g. 203.0.113.10/32"
  type        = string
}

variable "allowed_http_cidr" {
  description = "CIDR for HTTP test — use same as SSH for lab"
  type        = string
  default     = "" # empty = use allowed_ssh_cidr
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf"
  http_cidr   = var.allowed_http_cidr != "" ? var.allowed_http_cidr : var.allowed_ssh_cidr

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
