# Lab 05 — S3

## What This Module Teaches

Amazon S3 object storage: create buckets, upload/download objects, enable versioning, and apply a basic bucket policy.

## Learning Objectives

- Explain S3 buckets, objects, keys, and storage classes at a high level
- Create a uniquely named bucket in `ap-southeast-1`
- Upload and download objects via Console
- Enable versioning and observe version behavior
- Write a basic bucket policy (principle of least access)

## Lab Outcome

An S3 bucket with sample objects, versioning enabled, and a documented bucket policy using placeholder ARNs.

## Estimated Time

2–3 hours

## Cost Warning

S3 charges for storage, requests, and data transfer. Keep objects small for labs. Empty and delete the bucket in [cleanup.md](cleanup.md). Versioned delete markers still incur storage until fully removed.

## Cleanup Reminder

Delete all object versions, then delete the bucket. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-s3-theory.md](01-s3-theory.md) | S3 theory |
| 2 | [02-create-bucket.md](02-create-bucket.md) | Create bucket |
| 3 | [03-upload-download-objects.md](03-upload-download-objects.md) | Upload/download |
| 4 | [04-versioning.md](04-versioning.md) | Versioning |
| 5 | [05-bucket-policy-basic.md](05-bucket-policy-basic.md) | Bucket policy |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
