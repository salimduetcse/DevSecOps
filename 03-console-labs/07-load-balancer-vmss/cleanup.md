# Load Balancer and VMSS — Cleanup

## 1. Concept Overview

Delete in order: VMSS → Load Balancer → public IP → custom image / gallery versions → base VM leftovers → NSGs.

---

## 2. Why Clean Up

Standard Load Balancer and multiple VMs left running become an expensive surprise.

---

## 5. Before You Start

> **Cost warning:** Highest priority cleanup lab after MySQL.

---

## 6. Step-by-Step Cleanup

### Step 1 — Delete VM Scale Set

1. **Virtual machine scale sets** → select `devops-lab-<yourname>-vmss`
2. **Delete** → confirm
3. Wait until instances and scale set are gone

### Step 2 — Delete Load Balancer

1. **Load balancers** → delete `devops-lab-<yourname>-lb`

### Step 3 — Delete public IP

1. **Public IP addresses** → delete `devops-lab-<yourname>-lb-pip`

### Step 4 — Delete custom image / gallery

1. **Images** or **Azure Compute Galleries**
2. Delete image version → image definition → gallery if lab-only
3. Delete managed image `devops-lab-<yourname>-nginx-image` if created without gallery

### Step 5 — Delete base VM (if still present)

1. Delete `devops-lab-<yourname>-lb-base` plus disks, NIC, public IP

### Step 6 — Delete NSGs

1. Delete `devops-lab-<yourname>-lb-nsg` and `devops-lab-<yourname>-app-nsg` if unused
2. Do not delete NSGs still attached to other labs

### Step 7 — Verify

No lab VMSS, no Standard LB, no orphaned public IPs/disks/images for this lab

---

## 7. Validation

VMSS = 0 for lab, Load balancers = 0 for lab names

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| LB won’t delete | Detach/delete VMSS first |
| Image in use | Delete scale set/VMs referencing image first |
| Disk remains | Delete unattached disks manually |

---

## 9. Checklist

- [ ] VMSS deleted
- [ ] Load Balancer deleted
- [ ] Public IP deleted
- [ ] Custom image / gallery deleted
- [ ] Base VM and disks deleted
- [ ] NSGs deleted

---

## 10. Interview Questions

1. **Delete order VMSS vs LB?**
   - *VMSS first (backends); then LB; then public IP and images.*

---

## 11. What We Achieved

- Removed all Load Balancer / VMSS lab resources

**Next:** [08-container-apps](../08-container-apps/README.md)
