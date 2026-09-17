# Lab 06 — Azure Database for MySQL

## What This Module Teaches

Azure Database for MySQL Flexible Server: provision a small managed database, connect from an Azure VM, and practice backup/restore concepts.

## Learning Objectives

- Explain Flexible Server vs self-managed MySQL on a VM
- Launch the smallest burstable SKU MySQL Flexible Server
- Connect from an Azure VM in the same VNet (or via allowed firewall + NSG patterns for lab)
- Create and understand backups / restore points

## Lab Outcome

A working MySQL Flexible Server accessible from a lab VM, with at least one backup/restore concept demonstrated.

## Estimated Time

3–4 hours

## Cost Warning

**MySQL Flexible Server is one of the costlier labs.** Compute bills while the server exists (even idle); storage and backups add cost. Use the **smallest burstable SKU**, single availability zone for training, and **delete the server the same day** in [cleanup.md](cleanup.md). Do not leave MySQL running overnight.

## Cleanup Reminder

Delete the Flexible Server (skip long-term backups unless instructor requires), deallocate/delete the client VM, delete NSGs, and related networking. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-mysql-theory.md](01-mysql-theory.md) | MySQL Flexible Server theory |
| 2 | [02-create-mysql-flexible.md](02-create-mysql-flexible.md) | Create Flexible Server |
| 3 | [03-connect-from-vm.md](03-connect-from-vm.md) | Connect from Azure VM |
| 4 | [04-backup-restore.md](04-backup-restore.md) | Backup and restore |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
