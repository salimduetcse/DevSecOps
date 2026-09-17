# Container Apps — Cleanup

## 1. Concept Overview

Delete Container App → environment → ACR (images then registry) → lab Log Analytics workspace if dedicated.

---

## 2. Why Clean Up

Running replicas + environment logging left overnight wastes budget.

---

## 5. Before You Start

> **Cost warning:** Priority cleanup.

---

## 6. Step-by-Step Cleanup

### Step 1 — Delete Container App

1. **Container Apps** → select `devops-lab-<yourname>-app` → **Delete**
2. Confirm

### Step 2 — Delete environment

1. **Container Apps** → **Environments** → `devops-lab-<yourname>-env` → **Delete**
2. Must have no remaining apps

### Step 3 — Delete ACR images and registry

1. **Container registries** → repository → delete tags/manifests
2. **Delete** registry `devopslab<yourname>acr`

### Step 4 — Delete Log Analytics (if lab-owned)

1. **Log Analytics workspaces** → delete `devops-lab-<yourname>-law` if created only for this lab

### Step 5 — Disable ACR admin leftovers

If registry already deleted, skip. Never leave admin passwords in notes committed to Git.

---

## 7. Validation

| Check | Expected |
|-------|----------|
| Container Apps | 0 lab apps |
| Environments | 0 lab env |
| ACR | Registry deleted |
| Running replicas | none |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Environment won’t delete | Delete all apps first |
| ACR delete blocked | Delete repositories/soft-delete policies; remove locks |

---

## 9. Checklist

- [ ] Container App deleted
- [ ] Environment deleted
- [ ] ACR deleted
- [ ] Log Analytics deleted (if lab-only)
- [ ] No secrets committed to Git

---

## 10. Interview Questions

1. **First step Container Apps cleanup?**
   - *Delete the Container App (stop replicas), then the environment.*

---

## 11. What We Achieved

- Fully removed Container Apps / ACR lab stack

**Console labs 05–08 complete.** Continue remaining console labs if any, then [04-azure-cli](../../04-azure-cli/README.md) when that module is available.
