# Lab 01 — Entra ID and RBAC Basics

## What This Module Teaches

Microsoft Entra ID and Azure role-based access control (RBAC): subscription Owner / Global Admin caution vs day-to-day lab users, creating a lab user, and organizing permissions with Entra groups plus Contributor on a resource group for training.

## Learning Objectives

- Explain why not to use subscription Owner / Global Admin for daily work
- Create a Microsoft Entra ID user for lab work with portal sign-in
- Create a training admin group and assign **Contributor** on a lab resource group
- Practice least privilege awareness

## Lab Outcome

A dedicated Entra lab user (and optional training group with RBAC) for Portal and later CLI/Terraform labs — not unrestricted Global Admin for everyday tasks.

## Estimated Time

2–3 hours

## Cost Warning

Entra ID users/groups and Azure RBAC assignments themselves are free for these basics. Avoid creating unnecessary app registrations or credentials; rotate and delete unused secrets. The risk is *what* lab users can create (VMs, MySQL, etc.) in later labs.

## Cleanup Reminder

After labs and course completion, remove lab users, groups, and RBAC assignments per [cleanup.md](cleanup.md). Never delete your only subscription Owner / break-glass admin; disable or remove lab Entra users only.

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-owner-vs-entra-user.md](01-owner-vs-entra-user.md) | Owner / Global Admin vs Entra lab user |
| 2 | [02-create-lab-user.md](02-create-lab-user.md) | Create lab Entra user |
| 3 | [03-create-admin-group-for-training.md](03-create-admin-group-for-training.md) | Group + Contributor RBAC for training |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
