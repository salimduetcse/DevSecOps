# Lab 03 — Custom VPC and EC2

## What This Module Teaches

Build a custom VPC from scratch: subnets, internet gateway, route tables, security groups, NACLs, and launch EC2 inside your own network.

## Learning Objectives

- Explain VPC, CIDR, subnets (public/private), IGW, and route tables
- Create a VPC with public subnets in `ap-southeast-1`
- Configure routing for internet access
- Compare security groups vs NACLs
- Launch EC2 in a custom VPC and verify connectivity

## Lab Outcome

A working custom VPC with at least one public subnet and an EC2 instance reachable via SSH and HTTP (nginx optional).

## Estimated Time

4–5 hours

## Cost Warning

VPC components (VPC, subnets, IGW, route tables) are generally free. **EC2 and data transfer** still cost money. NAT Gateway is **not** required for this lab — do not create one unless instructed (NAT Gateway is expensive).

## Cleanup Reminder

Delete EC2 first, then detach/delete IGW, subnets, route tables, and VPC per [cleanup.md](cleanup.md). Order matters to avoid dependency errors.

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-vpc-theory.md](01-vpc-theory.md) | VPC theory |
| 2 | [02-create-vpc.md](02-create-vpc.md) | Create VPC |
| 3 | [03-create-subnets.md](03-create-subnets.md) | Create subnets |
| 4 | [04-create-internet-gateway.md](04-create-internet-gateway.md) | Internet gateway |
| 5 | [05-route-table-and-routing.md](05-route-table-and-routing.md) | Route tables |
| 6 | [06-security-group-and-nacl.md](06-security-group-and-nacl.md) | SG and NACL |
| 7 | [07-launch-ec2-in-custom-vpc.md](07-launch-ec2-in-custom-vpc.md) | Launch EC2 |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
