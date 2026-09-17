variable "location" {
  type    = string
  default = "southeastasia"
}

variable "subscription_id" {
  description = "Azure subscription ID. Get with: az account show --query id -o tsv"
  type        = string
}

variable "student_name" {
  type = string
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf"

  # Storage account names: 3-24 lowercase alphanumeric only
  sa_base = lower(replace("dl${var.student_name}tf", "-", ""))

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
