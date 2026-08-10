# Final Cleanup Checklist

Use this checklist **after all labs, capstones, and course completion** in region **`ap-southeast-1`** (and any other region you used).

> **Cost warning:** Any resource left running continues to charge your account.

---

## How to Use

1. Open AWS Console → correct region (`ap-southeast-1`)
2. Work through each section below
3. Check box when verified **empty** or **deleted**
4. Repeat for other regions if you experimented elsewhere

---

## 1. EC2 Instances

**Console:** EC2 → Instances → filter `devops-lab`

```bash
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running,pending,stopping,stopped" \
  --query "Reservations[].Instances[?contains(Tags[?Key=='Project'].Value|[0],'aws-basic') || contains(Tags[?Key=='Name'].Value|[0],'devops-lab')].{Id:InstanceId,State:State.Name,Name:Tags[?Key=='Name']|[0].Value}" \
  --output table --profile aws-basic-lab --region ap-southeast-1
```

- [ ] All lab/capstone instances **terminated** (including `alb-base` from Console ALB lab if still running)
- [ ] No unexpected running instances

---

## 2. EBS Volumes

**Console:** EC2 → Volumes → status `available` (orphaned)

```bash
aws ec2 describe-volumes \
  --filters Name=status,Values=available \
  --query "Volumes[].{Id:VolumeId,Size:Size}" \
  --output table --profile aws-basic-lab --region ap-southeast-1
```

- [ ] No unattached lab volumes
- [ ] Delete orphaned `available` volumes

---

## 3. EBS / RDS / AMI Snapshots

**Console:** EC2 → Snapshots | RDS → Snapshots

```bash
aws ec2 describe-snapshots --owner-ids self \
  --query "Snapshots[?contains(Description,'devops-lab') || contains(Tags[?Key=='Name'].Value|[0],'devops-lab')].SnapshotId" \
  --output text --profile aws-basic-lab --region ap-southeast-1
```

- [ ] Lab EBS snapshots deleted
- [ ] Lab RDS snapshots deleted

---

## 4. AMIs

**Console:** EC2 → AMIs → Owned by me

- [ ] Deregister capstone/lab AMIs
- [ ] Delete associated snapshots after deregister

---

## 5. S3 Buckets

**Console:** S3 → search `devops-lab`

```bash
aws s3 ls --profile aws-basic-lab --region ap-southeast-1 | grep devops-lab
```

- [ ] All lab buckets empty and deleted
- [ ] Versioned objects and delete markers removed

---

## 6. RDS Databases

**Console:** RDS → Databases

```bash
aws rds describe-db-instances \
  --query "DBInstances[?contains(DBInstanceIdentifier,'devops-lab')].DBInstanceIdentifier" \
  --output text --profile aws-basic-lab --region ap-southeast-1
```

- [ ] No lab RDS instances (highest cost risk after forgotten EC2)
- [ ] Lab RDS snapshots deleted
- [ ] Custom DB subnet groups deleted (CLI/Terraform labs — Console uses default)

---

## 7. Load Balancers

**Console:** EC2 → Load Balancers

```bash
aws elbv2 describe-load-balancers \
  --query "LoadBalancers[?contains(LoadBalancerName,'devops-lab')].LoadBalancerName" \
  --output text --profile aws-basic-lab --region ap-southeast-1
```

- [ ] All ALBs deleted

---

## 8. Target Groups

**Console:** EC2 → Target Groups

- [ ] No orphaned `devops-lab-*` target groups

---

## 9. Launch Templates

**Console:** EC2 → Launch Templates

- [ ] Lab launch templates deleted

---

## 10. Auto Scaling Groups

**Console:** EC2 → Auto Scaling Groups

- [ ] All lab ASGs deleted (instances terminated first)

---

## 11. ECS Services and Clusters

**Console:** ECS → Clusters

```bash
aws ecs list-clusters --profile aws-basic-lab --region ap-southeast-1
aws logs describe-log-groups --log-group-name-prefix "/ecs/devops-lab" \
  --query "logGroups[].logGroupName" --output text \
  --profile aws-basic-lab --region ap-southeast-1
```

- [ ] Services scaled to 0 and deleted
- [ ] Clusters deleted
- [ ] Task definitions deregistered (optional)
- [ ] CloudWatch log groups deleted (`/ecs/devops-lab-*`)

```bash
# Delete each lab log group found above
aws logs delete-log-group --log-group-name "/ecs/devops-lab-<yourname>" \
  --profile aws-basic-lab --region ap-southeast-1
```

---

## 12. ECR Repositories

**Console:** ECR → Repositories

- [ ] Images deleted
- [ ] Repositories deleted

---

## 13. VPCs (Custom Lab VPCs)

**Console:** VPC → Your VPCs (non-default)

- [ ] Custom lab VPCs deleted (IGW detached first)
- [ ] Default VPC can remain

---

## 14. NAT Gateways (If Any)

**Console:** VPC → NAT Gateways

> NAT Gateway is **expensive** — delete immediately if created by mistake.

- [ ] No NAT Gateways running
- [ ] Elastic IPs released after NAT delete

---

## 15. Elastic IPs

**Console:** EC2 → Elastic IPs

- [ ] No unassociated Elastic IPs (charged when idle)

---

## 16. Security Groups (Orphaned)

**Console:** EC2 → Security Groups → filter `devops-lab`

- [ ] Delete unused lab security groups (not `default`)

---

## 17. Key Pairs

**Console:** EC2 → Key Pairs

- [ ] Delete lab key pairs
- [ ] Delete local `.pem` files

---

## 18. IAM Access Keys (Lab User)

**Console:** IAM → Users → `devops-lab-<yourname>-user` → Security credentials

- [ ] Delete access keys created for CLI/Terraform
- [ ] Keep MFA enabled on root and IAM user
- [ ] Optional end-of-course: remove lab user from admin group

---

## 19. Local Machine Cleanup

- [ ] `~/.aws/credentials` — remove unused keys (keep profile if needed)
- [ ] Delete `terraform.tfstate` backup copies from lab folders
- [ ] Delete `*.pem`, `*.csv` from Downloads/repo
- [ ] Confirm `.gitignore` prevented credential commits

```bash
git status   # no .pem, .tfstate, terraform.tfvars staged
```

---

## 20. Billing Check

**Console:** Billing → Bills → last month / current month

- [ ] Review charges by service (EC2, RDS, ELB, ECS)
- [ ] Billing alert still configured

---

# Final Revision Questions

Use these to prepare for interviews and course assessment.

## Cloud Fundamentals

1. What are the five characteristics of cloud computing?
2. Difference between SaaS, PaaS, and IaaS?
3. Public vs private vs hybrid cloud?
4. On-demand vs Reserved vs Spot pricing?
5. Why can cloud cost more than on-prem if poorly managed?

## AWS Foundation

6. Region vs Availability Zone vs edge location?
7. Name the six Well-Architected pillars.
8. Name the six CAF perspectives.
9. Shared responsibility: who patches EC2 OS? RDS engine?
10. Why enable MFA on root?

## EC2 / VPC

11. What is a security group? Stateful or stateless?
12. What makes a subnet public?
13. Why not SSH from `0.0.0.0/0`?
14. IGW vs NAT Gateway?

## Storage

15. EBS vs S3 — when to use each?
16. Why delete EBS snapshots?
17. S3 Block Public Access — why?

## Database

18. RDS vs MySQL on EC2?
19. Why RDS in private subnet?

## Load Balancing

20. What does ALB health check do?
21. What happens when ASG instance fails?

## ECS

22. ECS task vs service?
23. Fargate vs EC2 launch type?
24. Why target type IP for Fargate?

## CLI

25. Command to verify AWS identity?
26. Why not commit access keys?

## Terraform

27. `terraform plan` vs `terraform apply`?
28. Why not commit `terraform.tfstate`?
29. Resource vs data source?
30. What does `terraform destroy` do?

---

## Sign-Off

| Item | Done |
|------|------|
| All checklist sections verified | ☐ |
| Billing reviewed | ☐ |
| Revision questions attempted | ☐ |
| Course complete | ☐ |

**Congratulations — you completed AWS Basic for DevOps Professionals.**
