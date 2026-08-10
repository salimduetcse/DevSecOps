# Lab 01 — IAM Basics

## What This Module Teaches

Identity and Access Management (IAM): root user vs IAM users, creating a lab user, and organizing permissions with groups for training.

## Learning Objectives

- Explain why not to use the root user for daily work
- Create an IAM user for lab work with programmatic and console access
- Create an admin group and attach policies for training (lab scope only)
- Practice least privilege awareness

## Lab Outcome

A dedicated IAM lab user (and optional admin group) for console and later CLI/Terraform labs — not the root account.

## Estimated Time

2–3 hours

## Cost Warning

IAM itself is free. No charge for users, groups, or policies. Avoid creating unnecessary access keys; rotate and delete unused keys.

## Cleanup Reminder

After labs and course completion, remove lab users, access keys, and groups per [cleanup.md](cleanup.md). Never delete the root user; disable or remove lab IAM users only.

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-root-user-vs-iam-user.md](01-root-user-vs-iam-user.md) | Root vs IAM user |
| 2 | [02-create-iam-user-for-lab.md](02-create-iam-user-for-lab.md) | Create lab IAM user |
| 3 | [03-create-admin-group-for-training.md](03-create-admin-group-for-training.md) | Admin group for training |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
