variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "aws-basic-lab"
}

variable "student_name" {
  description = "Your name for resource naming"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type — Free Tier friendly"
  type        = string
  default     = "t3.micro"
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
}
