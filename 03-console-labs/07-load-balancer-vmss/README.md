# Lab 07 — Load Balancer and VM Scale Sets

## What This Module Teaches

High availability patterns: Azure Load Balancer (Standard), custom images / VM Scale Set model, scale sets across availability zones (or AZs/fault domains), and testing failover.

## Learning Objectives

- Explain Azure Load Balancer, backend pools, health probes, and rules
- Create a custom image from a configured VM (and understand VMSS)
- Deploy a Standard Load Balancer with HTTP load balancing
- Create a Virtual Machine Scale Set (VMSS)
- Test high availability by deleting an instance

## Lab Outcome

A multi-instance web tier behind an Azure Load Balancer that recovers when instances fail.

## Estimated Time

4–5 hours

## Cost Warning

**Load Balancer Standard and VMSS are costly if left running.** Standard LB has hourly fees; multiple VMs multiply cost. Use minimum instance count of 2 only for the exercise, then delete everything in [cleanup.md](cleanup.md) same day.

## Cleanup Reminder

Delete VMSS → Load Balancer → public IP → image/gallery artifacts → base VM → NSGs in correct order. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-lb-theory.md](01-lb-theory.md) | Load Balancer theory |
| 2 | [02-image-and-vmss-model.md](02-image-and-vmss-model.md) | Custom image and VMSS model |
| 3 | [03-create-load-balancer.md](03-create-load-balancer.md) | Create Load Balancer |
| 4 | [04-create-vm-scale-set.md](04-create-vm-scale-set.md) | Create VM Scale Set |
| 5 | [05-test-high-availability.md](05-test-high-availability.md) | Test HA |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
