# Blob Storage — Cleanup

## 1. Concept Overview

Delete all blobs (including **versions** and soft-deleted items), then delete the storage account (or the whole resource group if this lab owns it alone).

---

## 2. Why Clean Up

Versioned and soft-deleted blobs still cost storage.

---

## 5. Before You Start

> **Cost warning:** Until deleted, capacity accrues.

---

## 6. Step-by-Step Cleanup

1. Storage account → **Containers** → `labs`
2. Select all blobs → **Delete**
3. If versioning enabled: open each deleted/versioned blob path → delete **all versions**
4. If soft delete enabled: **Show deleted blobs** → undelete is reverse; instead **Delete permanently** / wait retention only if Portal requires purge UI — prefer disabling soft delete then deleting, or purge via Storage Explorer/CLI if needed
5. Delete other containers if created (`images`, etc.)
6. **Storage accounts** → select account → **Delete** → type account name → confirm
7. Optionally delete RG `devops-lab-<yourname>-rg` if empty and unused by later labs

---

## 7. Validation

No `devopslab*` lab storage accounts remain (or none matching your name).

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Account not empty | Delete all containers, versions, and soft-deleted blobs |
| Immutable / legal hold | Not used in lab — remove policies if you enabled them by mistake |

---

## 9. Checklist

- [ ] All blobs and versions deleted
- [ ] Soft-deleted items purged (if any)
- [ ] Storage account deleted

---

## 10. Interview Questions

1. **Delete a versioned blob?**
   - *Current version may be removed while prior versions remain until each is deleted.*

---

## 11. What We Achieved

- Removed Blob Storage lab resources completely

**Next:** [06-mysql](../06-mysql/README.md)
