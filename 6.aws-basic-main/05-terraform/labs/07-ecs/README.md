# Terraform Lab 07 — ECS with ALB

> **Cost warning:** Fargate + ALB — destroy same day.

## 1. Architecture

ECR repo → ECS Fargate cluster → Service (2 tasks) → ALB → internet.

Default image: public nginx (works without docker push). Optional: push to ECR and set `container_image` in tfvars.

## 2. Files

Creates IAM execution role, ECR, cluster, task definition, ALB, service.

## 3. Commands

```bash
cd 05-terraform/labs/07-ecs
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
# Wait 3-5 min
```

### Optional ECR push

```bash
terraform output -raw ecr_push_hint
# docker build, tag, push — then update container_image in tfvars and terraform apply
```

## 4. Expected Output

`http_url`, `ecr_repository_url`, `cluster_name`

## 5. Validation

```bash
curl $(terraform output -raw http_url)
aws ecs describe-services \
  --cluster $(terraform output -raw cluster_name) \
  --services devops-lab-yourname-tf-ecs-service \
  --profile aws-basic-lab --region ap-southeast-1 \
  --query 'services[0].{running:runningCount,desired:desiredCount}'
```

## 6. Cleanup

```bash
terraform destroy
```

`force_delete = true` on ECR helps empty the repository on destroy. Also removes the lab IAM execution role (`devops-lab-*-exec-role`). If destroy fails, follow [03-console-labs/08-ecs/cleanup.md](../../03-console-labs/08-ecs/cleanup.md).

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| Tasks not healthy | Check ECS SG allows ALB SG on 80 |
| CannotPullContainerError | Execution role or wrong image URI |
| Service fails to stabilize | Wait longer; check target group health |

## 8. What We Achieved

- Full ECS Fargate + ALB stack in Terraform

**Terraform labs complete!** Next: [06-capstone-project](../../06-capstone-project/)
