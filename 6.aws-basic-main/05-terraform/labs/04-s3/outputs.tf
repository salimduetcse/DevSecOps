output "bucket_name" {
  value = aws_s3_bucket.lab.id
}

output "object_key" {
  value = aws_s3_object.hello.key
}

output "list_command" {
  value = "aws s3 ls s3://${aws_s3_bucket.lab.id}/ --recursive --profile aws-basic-lab"
}
