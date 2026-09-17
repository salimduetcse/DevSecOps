# ECS — Cleanup

## 1. Concept Overview

Delete ECS service → ALB → target group → tasks stop → cluster → task definitions → ECR images → log groups → security groups.

---

## 2. Why Clean Up

Fargate + ALB left running = **expensive**.

---

## 5. Before You Start

> **Cost warning:** Priority cleanup.

---

## 6. Step-by-Step Cleanup

### Step 1 — Delete ECS service

1. **ECS** → **Clusters** → your cluster → **Services**
2. Select `devops-lab-<yourname>-service` → **Delete**
3. Check **force delete** if tasks stuck → confirm
4. Wait until no services remain

### Step 2 — Delete ALB and target group

1. **EC2** → **Load Balancers** → delete `devops-lab-<yourname>-ecs-alb`
2. **Target Groups** → delete `devops-lab-<yourname>-ecs-tg`

### Step 3 — Stop any stray tasks

**ECS** → cluster → **Tasks** — stop if any left

### Step 4 — Delete cluster

**ECS** → **Clusters** → delete `devops-lab-<yourname>-cluster`

### Step 5 — Deregister task definition (optional)

**Task definitions** → select → **Deregister** all revisions

### Step 6 — Delete ECR images and repository

1. **ECR** → repository → select image → **Delete**
2. **Delete repository**

### Step 7 — Delete CloudWatch log group (if created)

**CloudWatch** → **Log groups** → delete `/ecs/devops-lab-<yourname>`

### Step 8 — Delete security groups

Delete `ecs-sg` and `ecs-alb-sg`

---

## 7. Validation

| Check | Expected |
|-------|----------|
| ECS clusters | 0 lab clusters |
| ALB | 0 |
| ECR | repo deleted |
| Fargate tasks | none running |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Cluster won't delete | Delete all services and tasks first |
| TG in use | Delete ALB first |

---

## 9. Checklist

- [ ] ECS service deleted
- [ ] ALB deleted
- [ ] Target group deleted
- [ ] Cluster deleted
- [ ] ECR repo deleted
- [ ] Security groups deleted
- [ ] Log group deleted

---

## 10. Interview Questions

1. **First step ECS cleanup?**
   - *Scale service to 0 or delete service.*

---

## 11. What We Achieved

- Fully removed ECS/ECR/ALB lab stack

**Console labs complete!** Next: [04-aws-cli](../../04-aws-cli/README.md)
