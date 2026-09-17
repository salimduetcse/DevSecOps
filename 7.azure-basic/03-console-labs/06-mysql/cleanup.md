# MySQL — Cleanup

## 1. Concept Overview

Delete MySQL Flexible Server(s), delete client VM, remove NSGs/public IPs, and unused networking.

---

## 2. Why Clean Up

MySQL Flexible Server is **high cost** if left running overnight.

---

## 5. Before You Start

> **Cost warning:** Delete MySQL **today** — same day as creation.

---

## 6. Step-by-Step Cleanup

### Step 1 — Delete Flexible Server

1. **Azure Database for MySQL flexible servers** → select `devops-lab-<yourname>-mysql`
2. **Delete** → type server name → confirm
3. Also delete `devops-lab-<yourname>-mysql-restored` if you created a restore

Wait until removed from the list.

### Step 2 — Delete client VM

1. **Virtual machines** → `devops-lab-<yourname>-mysql-client` → **Delete**
2. Check **Delete associated resources** / delete NIC, public IP, OS disk if prompted

### Step 3 — Delete NSG (if dedicated)

1. **Network security groups** → delete `devops-lab-<yourname>-mysql-client-nsg` if unused

### Step 4 — Delete SSH key resource (optional)

If you created an Azure key pair resource only for this lab, delete it; remove local private keys securely.

### Step 5 — Networking leftovers

Delete unused private DNS zones / delegated subnets only if this lab created them and they are unused.

---

## 7. Validation

| Check | Expected |
|-------|----------|
| MySQL servers | No lab Flexible Servers |
| VM | Deleted |
| Disks / IPs | No orphaned lab disks or public IPs |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Delete fails — dependencies | Delete private endpoint / VNet links first |
| Disk remains | Delete OS disk after VM deletion |

---

## 9. Checklist

- [ ] Primary MySQL Flexible Server deleted
- [ ] Restored server deleted (if any)
- [ ] Client VM deleted
- [ ] NIC / public IP / disks deleted
- [ ] Lab NSG deleted (if unused)

---

## 10. Interview Questions

1. **Most common student billing mistake?**
   - *Leaving managed MySQL running overnight.*

---

## 11. What We Achieved

- Zero MySQL Flexible Server charges from this lab

**Next:** [07-load-balancer-vmss](../07-load-balancer-vmss/README.md)
