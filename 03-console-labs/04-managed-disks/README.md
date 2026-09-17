# Lab 04 — Managed Disks

## What This Module Teaches

Azure Managed Disks: attach data disks to a VM, format and mount, persist data across reboots, and use snapshots for backup/restore.

## Learning Objectives

- Explain managed disk types and use cases at a beginner level
- Create and attach a data disk to a running Azure VM
- Format, mount, and configure `/etc/fstab` for persistence
- Create snapshots and restore from snapshot

## Lab Outcome

A VM with an additional managed data disk mounted at a custom path, plus a snapshot demonstrating backup workflow.

## Estimated Time

2–3 hours

## Cost Warning

**Managed disks and snapshots cost money** per GB-month. Use small disks (e.g. 8–10 GiB). Delete disks and snapshots in [cleanup.md](cleanup.md). Snapshots left behind continue to charge.

## Cleanup Reminder

This lab reuses the **Lab 02 VM** (`devops-lab-<yourname>-web` in `devops-lab-<yourname>-rg-02`). Do **not** run [Lab 02 cleanup](../02-vm-default-vnet/cleanup.md) before this lab.

Unmount disk, detach, delete disks and snapshots, then delete the Lab 02 VM / resource group. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-managed-disk-theory.md](01-managed-disk-theory.md) | Managed disk theory |
| 2 | [02-create-and-attach-disk.md](02-create-and-attach-disk.md) | Create and attach |
| 3 | [03-format-mount-persist-disk.md](03-format-mount-persist-disk.md) | Format, mount, persist |
| 4 | [04-snapshot-and-restore.md](04-snapshot-and-restore.md) | Snapshot and restore |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
