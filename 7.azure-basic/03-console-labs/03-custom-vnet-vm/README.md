# Lab 03 — Custom VNet and VM

## What This Module Teaches

Build a custom virtual network from scratch: subnets, public IP + internet routing concepts, route tables (light), NSGs, and launch a VM inside your own network.

## Learning Objectives

- Explain VNet, CIDR, subnets (public/private), public IP, and system routes
- Create a VNet with public and private subnets in `southeastasia`
- Configure internet access using public IP (Azure system routes — light route table teaching)
- Focus on NSGs (stateful like AWS SGs); note Azure has no NACL equivalent in these labs
- Launch a VM in a custom VNet and verify connectivity

## Lab Outcome

A working custom VNet with at least one public subnet and a Linux VM reachable via SSH and HTTP (nginx optional).

## Estimated Time

4–5 hours

## Cost Warning

VNet, subnets, NSGs, and route tables are generally low/no cost. **VMs, public IPs, and data transfer** still cost money. **NAT Gateway** is **not** required for this lab — do not create one unless instructed (NAT Gateway is expensive).

## Cleanup Reminder

Delete VM first, then public IP / NSG / subnets / VNet — or delete the whole resource group `devops-lab-<yourname>-rg-03` per [cleanup.md](cleanup.md). Order matters if deleting piece by piece.

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-vnet-theory.md](01-vnet-theory.md) | VNet theory |
| 2 | [02-create-vnet.md](02-create-vnet.md) | Create VNet |
| 3 | [03-create-subnets.md](03-create-subnets.md) | Create subnets |
| 4 | [04-create-public-ip-and-routing.md](04-create-public-ip-and-routing.md) | Public IP and internet routing |
| 5 | [05-route-table-and-routing.md](05-route-table-and-routing.md) | Route tables (light) |
| 6 | [06-nsg-basics.md](06-nsg-basics.md) | NSG basics (vs AWS SG + NACL) |
| 7 | [07-launch-vm-in-custom-vnet.md](07-launch-vm-in-custom-vnet.md) | Launch VM |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
