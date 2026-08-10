# RDS — Cleanup

## 1. Concept Overview

Delete RDS instance and snapshots, terminate EC2 client, delete security groups.

---

## 2. Why Clean Up

RDS is **high cost** if left running overnight.

---

## 5. Before You Start

> **Cost warning:** Delete RDS **today**.

---

## 6. Step-by-Step Cleanup

### Step 1 — Delete RDS instance

1. **RDS** → **Databases** → select instance
2. **Actions** → **Delete**
3. **Create final snapshot?** **No** (training lab) OR Yes then delete snapshot after
4. Confirm identifier → **Delete**

Wait until instance removed.

### Step 2 — Delete snapshots

1. **RDS** → **Snapshots**
2. Delete `devops-lab-<yourname>-mysql-snap` and any restored instance snapshots

### Step 3 — Terminate EC2 client

**EC2** → terminate `devops-lab-<yourname>-rds-client`

### Step 4 — Delete security groups

1. **EC2** → **Security Groups**
2. Delete `devops-lab-<yourname>-rds-sg` and `devops-lab-<yourname>-rds-client-sg` after RDS and EC2 are gone

### Step 5 — Delete key pair (if created for rds-client)

1. **EC2** → **Key pairs** → delete `devops-lab-<yourname>-key` (if not reused elsewhere)
2. Delete local `.pem` file securely

### Step 6 — DB subnet group (only if custom)

> **Console lab:** Uses the **default** DB subnet group for the default VPC — **nothing to delete**.

If you created a **dedicated** DB subnet group for this lab:

1. **RDS** → **Subnet groups** → select your lab group → **Delete**
2. Only possible after the RDS instance is fully deleted

---

## 7. Validation

| Check | Expected |
|-------|----------|
| RDS | No lab databases |
| Snapshots | None |
| EC2 | Terminated |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Delete protection | Disable on instance first |
| SG in use | Wait for RDS deletion |

---

## 9. Checklist

- [ ] RDS deleted
- [ ] Snapshots deleted
- [ ] EC2 client terminated
- [ ] Security groups deleted
- [ ] Key pair deleted (if lab-only)
- [ ] Custom DB subnet group deleted (if created)

---

## 10. Interview Questions

1. **Most common student billing mistake?**
   - *Leaving RDS running.*

---

## 11. What We Achieved

- Zero RDS charges from lab

**Next:** [07-load-balancer-auto-scaling](../07-load-balancer-auto-scaling/README.md)
