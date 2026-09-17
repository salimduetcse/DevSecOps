output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "cluster_name" {
  value = aws_ecs_cluster.lab.name
}

output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "http_url" {
  value = "http://${aws_lb.web.dns_name}"
}

output "ecr_push_hint" {
  value = "aws ecr get-login-password --region ap-southeast-1 --profile aws-basic-lab | docker login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}"
}
