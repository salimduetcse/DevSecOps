variable "location" {
  type    = string
  default = "southeastasia"
}

variable "student_name" {
  type = string
}

variable "container_image" {
  description = "Public image for first apply, or your ACR URI after docker push"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 2
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-ca"
  # Container App name: 2-32 chars, lowercase alphanumeric + hyphens
  app_name = substr(lower("ca-${var.student_name}-${random_string.acr_suffix.result}"), 0, 32)
  # ACR: 5-50 alphanumeric only
  acr_base = lower(replace("dl${var.student_name}tfca", "-", ""))

  common_tags = {
    Project     = "azure-basic"
    Owner       = var.student_name
    Environment = "training"
  }
}
