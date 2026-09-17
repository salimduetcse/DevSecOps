output "vpc_id" {
  value = aws_vpc.lab.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_command" {
  value = "ssh -i ${local.name_prefix}-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "http_url" {
  value = "http://${aws_instance.web.public_ip}"
}
