# Lab 05 — Blob Storage

## What This Module Teaches

Azure Blob Storage: create a storage account and container, upload/download blobs, enable versioning, and apply basic access control with container settings, RBAC, and SAS — without anonymous public website hosting.

## Learning Objectives

- Explain storage accounts, containers, blobs, and access tiers at a high level
- Create a globally unique storage account in `southeastasia`
- Upload and download blobs via Portal
- Enable blob versioning and observe version behavior
- Apply least-privilege access with RBAC and SAS (container stays private)

## Lab Outcome

A storage account with a private blob container, sample blobs, versioning enabled, and documented access control using RBAC/SAS placeholders.

## Estimated Time

2–3 hours

## Cost Warning

Blob storage charges for capacity, transactions, and data transfer. Keep blobs small for labs. Empty and delete the storage account in [cleanup.md](cleanup.md). Soft-deleted or versioned blobs can still incur storage until fully purged.

## Cleanup Reminder

Delete all blob versions (and soft-deleted items if enabled), then delete the storage account. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-blob-theory.md](01-blob-theory.md) | Blob Storage theory |
| 2 | [02-create-storage-account.md](02-create-storage-account.md) | Create storage account |
| 3 | [03-upload-download-blobs.md](03-upload-download-blobs.md) | Upload/download |
| 4 | [04-versioning.md](04-versioning.md) | Versioning |
| 5 | [05-access-control-basic.md](05-access-control-basic.md) | Access control (RBAC / SAS) |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
