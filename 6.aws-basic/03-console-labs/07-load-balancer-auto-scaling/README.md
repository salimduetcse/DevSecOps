# Lab 07 — Load Balancer and Auto Scaling

## What This Module Teaches

High availability patterns: Application Load Balancer (ALB), AMIs, launch templates, Auto Scaling Groups, and testing failover across AZs.

## Learning Objectives

- Explain ALB, target groups, and health checks
- Create an AMI and launch template from a configured EC2 instance
- Deploy an ALB with HTTP listener
- Create an Auto Scaling Group across multiple AZs
- Test high availability by terminating instances

## Lab Outcome

A multi-AZ web tier behind an ALB that recovers automatically when instances fail.

## Estimated Time

4–5 hours

## Cost Warning

**ALB and ASG are costly if left running.** ALB bills hourly plus LCU usage; multiple EC2 instances multiply cost. Use minimum capacity of 2 only for the lab exercise, then scale down and delete everything in [cleanup.md](cleanup.md) same day.

## Cleanup Reminder

Delete ASG, ALB, target groups, launch template, AMIs, snapshots, **base EC2 (`alb-base`)**, and security groups in correct order. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-alb-theory.md](01-alb-theory.md) | ALB theory |
| 2 | [02-ami-and-launch-template.md](02-ami-and-launch-template.md) | AMI and launch template |
| 3 | [03-create-alb.md](03-create-alb.md) | Create ALB |
| 4 | [04-create-auto-scaling-group.md](04-create-auto-scaling-group.md) | Auto Scaling Group |
| 5 | [05-test-high-availability.md](05-test-high-availability.md) | Test HA |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
