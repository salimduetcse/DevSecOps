output "db_endpoint" {
  value = aws_db_instance.lab.address
}

output "client_public_ip" {
  value = aws_instance.client.public_ip
}

output "ssh_command" {
  value = "ssh -i ${local.name_prefix}-key.pem ec2-user@${aws_instance.client.public_ip}"
}

output "mysql_test_command" {
  value     = "mysql -h ${aws_db_instance.lab.address} -u ${var.db_username} -p"
  sensitive = false
}
