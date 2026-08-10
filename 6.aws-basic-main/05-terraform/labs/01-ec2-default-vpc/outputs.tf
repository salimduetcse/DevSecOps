output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP for SSH and browser"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "SSH command (run from Git Bash in this folder)"
  value       = "ssh -i ${local.name_prefix}-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "http_url" {
  description = "nginx test URL"
  value       = "http://${aws_instance.web.public_ip}"
}
