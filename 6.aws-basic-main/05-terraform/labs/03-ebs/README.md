# Terraform Lab 03 — EBS

## 1. Architecture

EC2 + attached `aws_ebs_volume` + `aws_ebs_snapshot`.

## 2. Files

| File | Purpose |
|------|---------|
| `main.tf` | EC2, EBS volume, attachment, snapshot |
| `outputs.tf` | IDs + SSH + format hint |

After apply, **SSH manually** to format/mount (Console lab step) — Terraform attaches volume only.

## 3. Commands

```bash
cd 05-terraform/labs/03-ebs
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
terraform output format_mount_hint
```

## 4. Expected Output

Volume and snapshot IDs; EC2 public IP.

## 5. Validation

```bash
ssh -i *.pem ec2-user@$(terraform output -raw public_ip) 'lsblk'
```

## 6. Cleanup

```bash
terraform destroy
```

Destroys EC2, attached EBS volume, snapshot, security group, and key pair. Unmount `/data` on the instance first if you formatted the volume via SSH (optional — destroy terminates the instance).

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| AZ mismatch | `availability_zone` must match instance |
| Destroy stuck | Detach happens automatically on terminate |

## 8. What We Achieved

- EBS volume and snapshot as Terraform resources

**Next:** [../04-s3/](../04-s3/)
