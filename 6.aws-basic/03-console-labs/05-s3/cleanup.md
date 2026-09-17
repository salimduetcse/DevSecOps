# S3 — Cleanup

## 1. Concept Overview

Empty bucket (all object **versions** and delete markers) then delete bucket.

---

## 2. Why Clean Up

Versioned objects still cost storage.

---

## 5. Before You Start

> **Cost warning:** Until deleted, storage accrues.

---

## 6. Step-by-Step Cleanup

1. Bucket → **Empty**
2. Type `permanently delete` → confirm
3. Ensure **Show versions** — empty removes all versions (Console empty flow handles versions)
4. If empty fails: manually delete each version and delete markers
5. **Delete bucket**
6. Verify bucket gone from list

---

## 7. Validation

No `devops-lab-*` buckets remain.

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Bucket not empty | Delete all versions; check versioning delete markers |
| Object lock | Not used in lab — disable if enabled |

---

## 9. Checklist

- [ ] All objects and versions deleted
- [ ] Bucket deleted

---

## 10. Interview Questions

1. **Delete versioned object?**
   - *Creates delete marker; previous versions remain until permanently deleted.*

---

## 11. What We Achieved

- Removed S3 lab bucket completely

**Next:** [06-rds](../06-rds/README.md)
