# Lab 04 — EBS

## What This Module Teaches

Amazon Elastic Block Store: attach volumes to EC2, format and mount, persist data across reboots, and use snapshots for backup/restore.

## Learning Objectives

- Explain EBS volume types and use cases at a beginner level
- Create and attach an EBS volume to a running EC2 instance
- Format, mount, and configure `/etc/fstab` for persistence
- Create snapshots and restore from snapshot

## Lab Outcome

An EC2 instance with an additional EBS volume mounted at a custom path, plus a snapshot demonstrating backup workflow.

## Estimated Time

2–3 hours

## Cost Warning

**EBS volumes and snapshots cost money** per GB-month. Use small volumes (e.g. 8–10 GiB). Delete volumes and snapshots in [cleanup.md](cleanup.md). Snapshots left behind continue to charge.

## Cleanup Reminder

This lab reuses the **Lab 02 EC2** (`devops-lab-<yourname>-web`). Do **not** run [Lab 02 cleanup](../02-ec2-default-vpc/cleanup.md) before this lab.

Unmount volume, detach, delete volumes and snapshots, terminate the Lab 02 EC2, delete security group and key pair. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-ebs-theory.md](01-ebs-theory.md) | EBS theory |
| 2 | [02-create-and-attach-ebs.md](02-create-and-attach-ebs.md) | Create and attach |
| 3 | [03-format-mount-persist-ebs.md](03-format-mount-persist-ebs.md) | Format, mount, persist |
| 4 | [04-snapshot-and-restore.md](04-snapshot-and-restore.md) | Snapshot and restore |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
