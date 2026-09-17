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

variable "container_image" {
  description = "Use public image for lab, or your ECR URI after docker push"
  type        = string
  default     = "public.ecr.aws/docker/library/nginx:alpine"
}

variable "desired_count" {
  type    = number
  default = 2
}

locals {
  name_prefix = "devops-lab-${var.student_name}-tf-ecs"
}
