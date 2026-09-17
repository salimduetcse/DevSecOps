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

variable "ebs_size_gb" {
  type    = number
  default = 8
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "availability_zone" {
  type    = string
  default = "ap-southeast-1a"
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-ebs"
}
