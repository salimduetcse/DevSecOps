output "instance_id" {
  value = aws_instance.lab.id
}

output "volume_id" {
  value = aws_ebs_volume.data.id
}

output "snapshot_id" {
  value = aws_ebs_snapshot.data.id
}

output "public_ip" {
  value = aws_instance.lab.public_ip
}

output "ssh_command" {
  value = "ssh -i ${local.name_prefix}-key.pem ec2-user@${aws_instance.lab.public_ip}"
}

output "format_mount_hint" {
  value = "SSH: sudo mkfs -t xfs /dev/xvdf; sudo mkdir -p /data; sudo mount /dev/xvdf /data"
}
