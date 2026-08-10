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

locals {
  name_prefix = "devops-lab-${var.student_name}-tf"
}
