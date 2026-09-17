# Format, Mount, and Persist Managed Disk

## 1. Concept Overview

New data disks are **raw block devices** — format with a filesystem, mount to a directory, add to **`/etc/fstab`** for persistence across reboots.

---

## 2. Why DevOps Engineers Persist Mounts

Without `/etc/fstab`, the disk won't remount after reboot — data exists but the path disappears.

---

## 3. Important Terms

| Term | Meaning |
|------|---------|
| **mkfs.ext4** | Create ext4 filesystem (common on Ubuntu) |
| **mount** | Attach filesystem to `/data` |
| **UUID** | Stable ID for fstab (better than device name) |
| **nofail** | Boot continues if volume missing |

---

## 4. Architecture Diagram

```mermaid
flowchart LR
    DISK[Managed Data Disk] --> FS[ext4 filesystem]
    FS --> MNT["/data mount point"]
    MNT --> FSTAB[/etc/fstab]
```

---

## 5. Before You Start

Disk attached; `lsblk` shows new device (example: `/dev/sdc`).

> **Cost warning:** Disk still billing.

---

## 6. Step-by-Step Lab (SSH)

Replace `/dev/sdc` with your device from `lsblk` (never format the OS disk — usually `sda` / `sda1`).

```bash
# Identify disks carefully
lsblk
df -h

# Format (DESTROYS data on empty volume — OK for new empty data disk)
sudo mkfs -t ext4 /dev/sdc

# Create mount point
sudo mkdir -p /data

# Mount
sudo mount /dev/sdc /data

# Verify
df -h /data
sudo touch /data/testfile.txt

# Get UUID for fstab
sudo blkid /dev/sdc
# copy UUID value
```

### Add to /etc/fstab

```bash
sudo nano /etc/fstab
```

Add line (replace UUID):

```
UUID=<your-uuid>  /data  ext4  defaults,nofail  0  2
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
| `df -h /data` | Shows ext4 filesystem |
| Reboot test (optional) | `sudo reboot` — `/data` still mounted |
| testfile exists | After remount |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| `mount: wrong fs type` | Run mkfs first |
| Boot hangs on fstab | Use `nofail`; fix UUID from Azure Serial Console / rescue |
| NVMe device name | Use the device path shown by `lsblk` |
| Formatted wrong disk | Stop — restore from snapshot/backup if any; be careful next time |

---

## 9. Cleanup

[cleanup.md](cleanup.md)

---

## 10. Interview Questions

1. **Why UUID in fstab?**
   - *Device names can change; UUID stays stable.*

2. **What does nofail do?**
   - *System boots even if the disk is unavailable.*

---

## 11. What We Achieved

- Formatted, mounted, persisted managed data disk at `/data`

**Next:** [04-snapshot-and-restore.md](04-snapshot-and-restore.md)

---

## 12. References

- [Format and mount a data disk on Linux](https://learn.microsoft.com/azure/virtual-machines/linux/attach-disk-portal#connect-to-the-linux-vm-to-mount-the-new-disk)
- [Azure Disks FAQ](https://learn.microsoft.com/azure/virtual-machines/faq-for-disks)
