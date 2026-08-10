# Format, Mount, and Persist EBS

## 1. Concept Overview

New EBS volumes are **raw block devices** — format with a filesystem, mount to a directory, add to **`/etc/fstab`** for persistence across reboots.

---

## 2. Why DevOps Engineers Persist Mounts

Without `/etc/fstab`, disk won't remount after reboot — data exists but path disappears.

---

## 3. Important Terms

| Term | Meaning |
|------|---------|
| **mkfs.xfs** | Create XFS filesystem (Amazon Linux default) |
| **mount** | Attach filesystem to `/data` |
| **UUID** | Stable ID for fstab (better than device name) |
| **nofail** | Boot continues if volume missing |

---

## 4. Architecture Diagram

```mermaid
flowchart LR
    VOL[EBS Volume] --> FS[XFS filesystem]
    FS --> MNT["/data mount point"]
    MNT --> FSTAB[/etc/fstab]
```

---

## 5. Before You Start

Volume attached; `lsblk` shows new device (example: `/dev/xvdf`).

> **Cost warning:** Volume still billing.

---

## 6. Step-by-Step Lab (SSH)

Replace `/dev/xvdf` with your device from `lsblk`.

```bash
# Format (DESTROYS data on empty volume — OK for new volume)
sudo mkfs -t xfs /dev/xvdf

# Create mount point
sudo mkdir -p /data

# Mount
sudo mount /dev/xvdf /data

# Verify
df -h /data
sudo touch /data/testfile.txt

# Get UUID for fstab
sudo blkid /dev/xvdf
# copy UUID value
```

### Add to /etc/fstab

```bash
sudo nano /etc/fstab
```

Add line (replace UUID):

```
UUID=<your-uuid>  /data  xfs  defaults,nofail  0  2
```

Test fstab:

```bash
sudo umount /data
sudo mount -a
df -h /data
ls /data/testfile.txt
```

---

## 7. Validation

| Check | Expected |
|-------|----------|
| `df -h /data` | Shows xfs filesystem |
| Reboot test (optional) | `sudo reboot` — `/data` still mounted |
| testfile exists | After remount |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| `mount: wrong fs type` | Run mkfs first |
| Boot hangs on fstab | Use `nofail`; fix UUID in recovery mode |
| NVMe device name | Use `/dev/nvme1n1` from lsblk |

---

## 9. Cleanup

[cleanup.md](cleanup.md)

---

## 10. Interview Questions

1. **Why UUID in fstab?**
   - *Device names can change; UUID stays stable.*

2. **What does nofail do?**
   - *System boots even if volume unavailable.*

---

## 11. What We Achieved

- Formatted, mounted, persisted EBS at `/data`

**Next:** [04-snapshot-and-restore.md](04-snapshot-and-restore.md)
