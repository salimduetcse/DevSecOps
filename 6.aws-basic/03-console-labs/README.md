# Module 03 — Console Labs

## What This Module Teaches

Hands-on AWS using the **Management Console**. You will build the same core services a DevOps engineer uses daily: IAM, EC2, VPC, EBS, S3, RDS, load balancing, auto scaling, and ECS — in that order.

## Learning Objectives

- Navigate the AWS Console confidently
- Create and manage IAM users, groups, and policies
- Launch and connect to EC2 instances in default and custom VPCs
- Attach EBS volumes, use S3, and run a small RDS MySQL instance
- Deploy highly available apps with ALB and Auto Scaling
- Run a containerized app on ECS with ECR and ALB

## Lab Outcome

A working set of lab resources demonstrating each service. **Clean up each sub-lab before starting the next** — with one exception noted below.

## Estimated Time

20–25 hours (all sub-labs)

## Cost Warning

**Medium–High.** EC2, RDS, ALB, and ECS can incur charges even on small instances. Use Free Tier where eligible, smallest instance types, and **complete every cleanup.md** immediately after each lab. Default region: `ap-southeast-1`.

## Cleanup Reminder

**Every sub-lab has a `cleanup.md` file.** Do not start the next lab until the previous lab's resources are deleted — except where noted below. See [COST-AND-SAFETY-GUIDE.md](../COST-AND-SAFETY-GUIDE.md).

### Lab cleanup order (important)

| Lab | When to run `cleanup.md` |
|-----|--------------------------|
| 01 IAM | End of course (keys/user) — see [01-iam-basics/cleanup.md](01-iam-basics/cleanup.md) |
| 02 EC2 default VPC | **Defer** if doing Lab 04 next — see [02-ec2-default-vpc/cleanup.md](02-ec2-default-vpc/cleanup.md) |
| 03 Custom VPC | Immediately after Lab 03 |
| 04 EBS | Immediately after Lab 04 — **also cleans up Lab 02 EC2** |
| 05–08 | Immediately after each lab |

**Lab 04 EBS** reuses the EC2 instance from **Lab 02**. Keep Lab 02 running through Lab 04, then run Lab 04 cleanup (which terminates that EC2). Lab 03 (custom VPC) is independent — clean it up when you finish Lab 03.

## Sub-Labs (Console Order)

| # | Lab | Est. Time |
|---|-----|-----------|
| 1 | [01-iam-basics](01-iam-basics/) | 2–3 hrs |
| 2 | [02-ec2-default-vpc](02-ec2-default-vpc/) | 3–4 hrs |
| 3 | [03-custom-vpc-ec2](03-custom-vpc-ec2/) | 4–5 hrs |
| 4 | [04-ebs](04-ebs/) | 2–3 hrs |
| 5 | [05-s3](05-s3/) | 2–3 hrs |
| 6 | [06-rds](06-rds/) | 3–4 hrs |
| 7 | [07-load-balancer-auto-scaling](07-load-balancer-auto-scaling/) | 4–5 hrs |
| 8 | [08-ecs](08-ecs/) | 4–5 hrs |

This order is repeated in [04-aws-cli](../04-aws-cli/) and [05-terraform](../05-terraform/).
