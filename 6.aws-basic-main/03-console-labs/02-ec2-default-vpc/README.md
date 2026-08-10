# Lab 02 — EC2 in Default VPC

## What This Module Teaches

Amazon EC2 basics: launch an instance in the default VPC, connect via SSH, install nginx, and understand security groups.

## Learning Objectives

- Explain EC2, AMI, instance type, and key pairs
- Launch a Linux EC2 instance in the default VPC (`ap-southeast-1`)
- Connect using SSH from Git Bash (Windows)
- Install nginx and verify HTTP access
- Configure and explain security group rules

## Lab Outcome

A running EC2 instance serving a simple nginx page, reachable from your IP (then terminated after cleanup).

## Estimated Time

3–4 hours

## Cost Warning

**EC2 charges apply** when instances run. Use `t3.micro` (Free Tier eligible if account qualifies). Stop or terminate instances when done. Elastic IP charges may apply if allocated and not attached. Complete [cleanup.md](cleanup.md) same day.

## Cleanup Reminder

**Defer full cleanup** if you are continuing to [Lab 04 EBS](../04-ebs/README.md) — Lab 04 needs the running EC2 from this lab.

Otherwise: terminate the EC2 instance, release unused Elastic IPs, and delete the key pair if no longer needed. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-ec2-theory.md](01-ec2-theory.md) | EC2 theory |
| 2 | [02-launch-ec2-default-vpc.md](02-launch-ec2-default-vpc.md) | Launch EC2 |
| 3 | [03-connect-using-ssh.md](03-connect-using-ssh.md) | SSH connection |
| 4 | [04-install-nginx-and-test.md](04-install-nginx-and-test.md) | nginx install |
| 5 | [05-security-group-explanation.md](05-security-group-explanation.md) | Security groups |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
