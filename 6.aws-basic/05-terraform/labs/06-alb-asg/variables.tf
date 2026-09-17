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

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-alb"
}
