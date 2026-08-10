# Lab 06 — RDS

## What This Module Teaches

Amazon RDS for MySQL: provision a small managed database, connect from EC2, and practice backup with snapshots.

## Learning Objectives

- Explain RDS vs self-managed databases on EC2
- Launch a small MySQL RDS instance (`db.t3.micro` where available)
- Connect from an EC2 instance in the same VPC
- Create manual snapshots and understand automated backups

## Lab Outcome

A working RDS MySQL instance accessible from a lab EC2 instance, with at least one manual snapshot demonstrated.

## Estimated Time

3–4 hours

## Cost Warning

**RDS is one of the costlier labs.** Instances bill hourly; storage and backups add cost. Use smallest instance class, single-AZ for training, and **delete the instance** (with final snapshot only if you need it) in [cleanup.md](cleanup.md). Do not leave RDS running overnight.

## Cleanup Reminder

Delete RDS instance (skip final snapshot for training unless instructor says otherwise), terminate EC2 client, delete security groups, key pair, and custom DB subnet group (if created). See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-rds-theory.md](01-rds-theory.md) | RDS theory |
| 2 | [02-create-rds-mysql.md](02-create-rds-mysql.md) | Create RDS MySQL |
| 3 | [03-connect-from-ec2.md](03-connect-from-ec2.md) | Connect from EC2 |
| 4 | [04-backup-snapshot.md](04-backup-snapshot.md) | Backup snapshot |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
