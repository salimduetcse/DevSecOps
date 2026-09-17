# Module 03 — Console Labs

## What This Module Teaches

Hands-on Azure using the **Azure Portal**. You will build the same core services a DevOps engineer uses daily: Entra ID / RBAC, Virtual Machines, Virtual Networks, Managed Disks, Blob Storage, MySQL, load balancing / VM Scale Sets, and Container Apps — in that order.

## Learning Objectives

- Navigate the Azure Portal confidently
- Create and manage Entra ID users, groups, and Azure RBAC assignments
- Launch and connect to Linux VMs in portal-created and custom VNets
- Attach managed disks, use Blob Storage, and run a small MySQL Flexible Server
- Deploy highly available apps with Load Balancer and VM Scale Sets
- Run a containerized app on Azure Container Apps with ACR

## Lab Outcome

A working set of lab resources demonstrating each service. **Clean up each sub-lab before starting the next** — with one exception noted below.

## Estimated Time

20–25 hours (all sub-labs)

## Cost Warning

**Medium–High.** VMs, MySQL Flexible Server, Load Balancer / VMSS, and Container Apps can incur charges even on small sizes. Use Free trial credits where eligible, smallest SKUs, and **complete every cleanup.md** immediately after each lab. Default region: `southeastasia`.

## Resource Groups

Recommend **one resource group per lab** so cleanup is a single delete:

```
devops-lab-<yourname>-rg-<lab>
```

Examples: `devops-lab-faizul-rg-01`, `devops-lab-faizul-rg-02`, `devops-lab-faizul-rg-03`, `devops-lab-faizul-rg-04`.

**Exception:** Lab 04 reuses the Lab 02 VM — keep Lab 02 resources in `devops-lab-<yourname>-rg-02` through Lab 04, then clean up that resource group once.

Tags on every resource: `Project=azure-basic`, `Owner=<yourname>`, `Environment=training`. See [lab-naming-convention.md](../00-course-setup/lab-naming-convention.md).

## Cleanup Reminder

**Every sub-lab has a `cleanup.md` file.** Do not start the next lab until the previous lab's resources are deleted — except where noted below. See [COST-AND-SAFETY-GUIDE.md](../COST-AND-SAFETY-GUIDE.md).

### Lab cleanup order (important)

| Lab | When to run `cleanup.md` |
|-----|--------------------------|
| 01 Entra / RBAC | End of course (user/group/role) — see [01-entra-rbac-basics/cleanup.md](01-entra-rbac-basics/cleanup.md) |
| 02 VM default VNet | **Defer** if doing Lab 04 next — see [02-vm-default-vnet/cleanup.md](02-vm-default-vnet/cleanup.md) |
| 03 Custom VNet | Immediately after Lab 03 |
| 04 Managed Disks | Immediately after Lab 04 — **also cleans up Lab 02 VM** |
| 05–08 | Immediately after each lab |

**Lab 04 Managed Disks** reuses the Linux VM from **Lab 02**. Keep Lab 02 running through Lab 04, then run Lab 04 cleanup (which deletes that VM / resource group). Lab 03 (custom VNet) is independent — clean it up when you finish Lab 03.

## Sub-Labs (Portal Order)

| # | Lab | Est. Time |
|---|-----|-----------|
| 1 | [01-entra-rbac-basics](01-entra-rbac-basics/) | 2–3 hrs |
| 2 | [02-vm-default-vnet](02-vm-default-vnet/) | 3–4 hrs |
| 3 | [03-custom-vnet-vm](03-custom-vnet-vm/) | 4–5 hrs |
| 4 | [04-managed-disks](04-managed-disks/) | 2–3 hrs |
| 5 | [05-blob-storage](05-blob-storage/) | 2–3 hrs |
| 6 | [06-mysql](06-mysql/) | 3–4 hrs |
| 7 | [07-load-balancer-vmss](07-load-balancer-vmss/) | 4–5 hrs |
| 8 | [08-container-apps](08-container-apps/) | 4–5 hrs |

**Portal path:** Entra/RBAC → VM → VNet → Managed Disks → Blob → MySQL → LB/VMSS → Container Apps

This order is repeated in [04-azure-cli](../04-azure-cli/) and [05-terraform](../05-terraform/).
