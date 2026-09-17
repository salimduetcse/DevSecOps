# Terraform Lab 04 - S3

## 1. Architecture

Private S3 bucket with encryption, versioning, Block Public Access, and sample object.

## 2. Files

`random_id` ensures a globally unique bucket name.
`force_destroy = true` is enabled so `terraform destroy` can remove lab objects and bucket versions cleanly.

## 3. Commands

```bash
cd 05-terraform/labs/04-s3
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
```

## 4. Expected Output

`bucket_name`, `list_command` outputs.

## 5. Validation

```bash
terraform output -raw list_command | bash
aws s3 cp s3://$(terraform output -raw bucket_name)/labs/hello.txt - --profile aws-basic-lab
```

## 6. Cleanup

```bash
terraform destroy
```

Terraform removes the sample object, object versions, and bucket as part of destroy. This convenience is appropriate for a disposable training lab, not for production buckets.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| Bucket not empty on destroy | Run destroy again; verify no extra manual objects were added outside Terraform |

## 8. What We Achieved

- S3 bucket + object as code with security defaults

**Next:** [../05-rds/](../05-rds/)
