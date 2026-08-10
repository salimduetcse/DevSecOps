# ALB and Auto Scaling — Cleanup

## 1. Concept Overview

Delete in order: ASG → ALB → target group → launch template → AMI → snapshots → **base EC2** → security groups.

---

## 2. Why Clean Up

ALB alone costs **~$18+/month** if forgotten.

---

## 5. Before You Start

> **Cost warning:** Highest priority cleanup lab.

---

## 6. Step-by-Step Cleanup

### Step 1 — Delete Auto Scaling Group

1. **EC2** → **Auto Scaling Groups** → select ASG
2. **Delete** → check **delete associated instances** → confirm
3. Wait instances terminated

### Step 2 — Delete ALB

1. **Load Balancers** → select ALB → **Delete**
2. Confirm

### Step 3 — Delete target group

1. **Target Groups** → delete `devops-lab-<yourname>-tg`

### Step 4 — Delete launch template

1. **Launch templates** → delete `devops-lab-<yourname>-lt`

### Step 5 — Deregister AMI and delete snapshot

1. **AMIs** → select → **Deregister AMI**
2. **Snapshots** → delete linked snapshot

### Step 6 — Terminate base EC2 (if still running)

The golden-AMI **base instance** (`devops-lab-<yourname>-alb-base`) bills until terminated. ASG deletion does **not** remove it.

1. **EC2** → **Instances**
2. Filter `devops-lab-<yourname>-alb-base` (or any stopped/running instance not part of ASG)
3. **Instance state** → **Terminate instance**
4. Wait until **Terminated**

> You should terminate the base instance right after creating the AMI (see lesson 02). This step catches it if you skipped that.

### Step 7 — Delete security groups

1. **EC2** → **Security Groups**
2. Delete `devops-lab-<yourname>-alb-sg` and `devops-lab-<yourname>-app-sg` (names may vary — delete all unused lab ALB/ASG security groups)
3. Do not delete `default`

### Step 8 — Verify

No running lab instances, no ALB, no ASG, no lab AMIs or snapshots

---

## 7. Validation

EC2 instances = 0 for lab, Load balancers = 0

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| TG in use | Delete ALB first |
| ASG won't delete | Set desired/min/max to 0 first |

---

## 9. Checklist

- [ ] ASG deleted (with instances)
- [ ] ALB deleted
- [ ] Target group deleted
- [ ] Launch template deleted
- [ ] AMI deregistered
- [ ] Snapshots deleted
- [ ] Base EC2 (`alb-base`) terminated
- [ ] Security groups deleted

---

## 10. Interview Questions

1. **Delete order ASG vs ALB?**
   - *ASG first (instances); then ALB; then target group.*

---

## 11. What We Achieved

- Removed all ALB/ASG lab resources

**Next:** [08-ecs](../08-ecs/README.md)
