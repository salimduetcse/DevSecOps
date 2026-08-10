variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "aws_profile" {
  type    = string
  default = "aws-basic-lab"
}

variable "student_name" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "devopslab"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-rds"
}
