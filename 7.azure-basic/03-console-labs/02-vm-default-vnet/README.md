# Lab 02 — VM with Portal-Created VNet

## What This Module Teaches

Azure Virtual Machines basics: launch a Linux VM while letting the Portal create a VNet, connect via SSH, install nginx, and understand network security groups (NSGs).

## Learning Objectives

- Explain Azure VMs, images, sizes, and SSH keys
- Launch an Ubuntu 22.04 Linux VM in `southeastasia` with a Portal-created VNet
- Connect using SSH from Git Bash (Windows)
- Install nginx and verify HTTP access
- Configure and explain NSG rules

## Lab Outcome

A running Azure Linux VM serving a simple nginx page, reachable from your IP (then deleted after cleanup — **defer** if doing Lab 04).

## Estimated Time

3–4 hours

## Cost Warning

**VM charges apply** when VMs run. Use `Standard_B1s` (smallest practical for labs). Stop or delete VMs when done. Public IP addresses and disks can still cost money when the VM is stopped (deallocated disks remain). Complete [cleanup.md](cleanup.md) same day unless deferring for Lab 04.

## Cleanup Reminder

**Defer full cleanup** if you are continuing to [Lab 04 Managed Disks](../04-managed-disks/README.md) — Lab 04 needs the running VM from this lab.

Otherwise: delete the VM (and preferably the whole resource group), release unused public IPs, and remove local private keys if no longer needed. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-vm-theory.md](01-vm-theory.md) | VM theory |
| 2 | [02-launch-vm.md](02-launch-vm.md) | Launch VM |
| 3 | [03-connect-using-ssh.md](03-connect-using-ssh.md) | SSH connection |
| 4 | [04-install-nginx-and-test.md](04-install-nginx-and-test.md) | nginx install |
| 5 | [05-nsg-explanation.md](05-nsg-explanation.md) | Network security groups |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
