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

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "ap-southeast-1a"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "allowed_http_cidr" {
  type    = string
  default = ""
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-vpc"
  http_cidr   = var.allowed_http_cidr != "" ? var.allowed_http_cidr : var.allowed_ssh_cidr
}
