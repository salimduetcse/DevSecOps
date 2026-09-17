# Terraform Lab 06 — ALB and Auto Scaling

> **Cost warning:** ALB + 2 EC2 — destroy same day.

## 1. Architecture

ALB (public HTTP) → Target Group → ASG (2 instances) with nginx user_data.

## 2. Files

Launch template embeds nginx install — no golden AMI step for simplicity.

## 3. Commands

```bash
cd 05-terraform/labs/06-alb-asg
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
# Wait 3-5 min for healthy targets
```

## 4. Expected Output

`http_url` = `http://devops-lab-...-alb-....ap-southeast-1.elb.amazonaws.com`

## 5. Validation

```bash
curl $(terraform output -raw http_url)
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn) \
  --profile aws-basic-lab --region ap-southeast-1
```

## 6. Cleanup

```bash
terraform destroy
```

Removes ASG (and instances), ALB, target group, launch template, and security groups. No separate golden-AMI base EC2 in this Terraform lab.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| 502 from ALB | Wait for ASG instances healthy |
| Unhealthy targets | Check app SG allows ALB SG |

## 8. What We Achieved

- ALB + ASG entirely in Terraform

**Next:** [../07-ecs/](../07-ecs/)
