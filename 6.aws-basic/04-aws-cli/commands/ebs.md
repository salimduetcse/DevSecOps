# CLI Lab — EBS

Repeat [Console lab 04](../../03-console-labs/04-ebs/README.md) using AWS CLI.

---

## 1. Theory Reminder

- **EBS** = block storage in one **AZ**
- Attach to EC2 → format → mount → `/etc/fstab`
- **Snapshot** = backup; restore = new volume from snapshot

---

## 2. Setup — Launch EC2 First (if needed)

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1
export YOURNAME="<yourname>"
export AZ="ap-southeast-1a"

# Use existing instance OR quick launch in default VPC (see ec2-default-vpc.md)
export INSTANCE_ID="<your-instance-id>"
export AZ=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].Placement.AvailabilityZone" --output text \
  --profile aws-basic-lab --region ap-southeast-1)
```

---

## 3. Resource Creation Commands

### 3.1 Create volume

```bash
export VOL_ID=$(aws ec2 create-volume \
  --size 8 --volume-type gp3 --availability-zone "$AZ" \
  --tag-specifications "ResourceType=volume,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-cli-data}]" \
  --query VolumeId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 wait volume-available --volume-ids "$VOL_ID" \
  --profile aws-basic-lab --region ap-southeast-1

echo "Volume: $VOL_ID"
```

### 3.2 Attach volume

```bash
aws ec2 attach-volume \
  --volume-id "$VOL_ID" \
  --instance-id "$INSTANCE_ID" \
  --device /dev/sdf \
  --profile aws-basic-lab --region ap-southeast-1

aws ec2 wait volume-in-use --volume-ids "$VOL_ID" \
  --profile aws-basic-lab --region ap-southeast-1
```

### 3.3 Format and mount (SSH)

```bash
export PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text \
  --profile aws-basic-lab --region ap-southeast-1)

ssh -i "<your-key>.pem" ec2-user@"$PUBLIC_IP" << 'EOF'
lsblk
# Use correct device from lsblk — often xvdf or nvme1n1
sudo mkfs -t xfs /dev/xvdf
sudo mkdir -p /data
sudo mount /dev/xvdf /data
echo "test" | sudo tee /data/cli-ebs-test.txt
UUID=$(sudo blkid -s UUID -o value /dev/xvdf)
echo "UUID=$UUID  /data  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab
df -h /data
EOF
```

### 3.4 Create snapshot

```bash
export SNAP_ID=$(aws ec2 create-snapshot \
  --volume-id "$VOL_ID" \
  --description "CLI lab snapshot devops-lab-${YOURNAME}" \
  --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=devops-lab-${YOURNAME}-cli-snap}]" \
  --query SnapshotId --output text \
  --profile aws-basic-lab --region ap-southeast-1)

aws ec2 wait snapshot-completed --snapshot-ids "$SNAP_ID" \
  --profile aws-basic-lab --region ap-southeast-1

echo "Snapshot: $SNAP_ID"
```

---

## 4. Validation Commands

```bash
aws ec2 describe-volumes --volume-ids "$VOL_ID" \
  --query "Volumes[0].{State:State,Size:Size,Attachments:Attachments}" \
  --profile aws-basic-lab --region ap-southeast-1

aws ec2 describe-snapshots --snapshot-ids "$SNAP_ID" \
  --query "Snapshots[0].{State:State,VolumeSize:VolumeSize}" \
  --output table --profile aws-basic-lab --region ap-southeast-1
```

| Output | Meaning |
|--------|---------|
| `State: in-use` | Volume attached |
| `Attachments[0].Device` | `/dev/sdf` |
| Snapshot `completed` | Backup ready |

---

## 5. Cleanup Commands

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_REGION=ap-southeast-1

# On EC2 via SSH (if mounted): sudo umount /data

# Detach and delete data volume
aws ec2 detach-volume --volume-id "$VOL_ID" --profile aws-basic-lab --region ap-southeast-1
aws ec2 wait volume-available --volume-ids "$VOL_ID" --profile aws-basic-lab --region ap-southeast-1
aws ec2 delete-volume --volume-id "$VOL_ID" --profile aws-basic-lab --region ap-southeast-1

# Delete snapshot
aws ec2 delete-snapshot --snapshot-id "$SNAP_ID" --profile aws-basic-lab --region ap-southeast-1

# Delete restored volume if you created one during snapshot lab
if [ -n "${RESTORED_VOL_ID:-}" ]; then
  aws ec2 detach-volume --volume-id "$RESTORED_VOL_ID" --profile aws-basic-lab --region ap-southeast-1 2>/dev/null
  aws ec2 wait volume-available --volume-ids "$RESTORED_VOL_ID" --profile aws-basic-lab --region ap-southeast-1 2>/dev/null
  aws ec2 delete-volume --volume-id "$RESTORED_VOL_ID" --profile aws-basic-lab --region ap-southeast-1
fi

# Terminate EC2 (if launched for this lab)
aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" \
  --profile aws-basic-lab --region ap-southeast-1
aws ec2 wait instance-terminated --instance-ids "$INSTANCE_ID" \
  --profile aws-basic-lab --region ap-southeast-1

# Delete security group (set SG_ID during ec2-default-vpc.md if reusing that stack)
if [ -n "${SG_ID:-}" ]; then
  aws ec2 delete-security-group --group-id "$SG_ID" \
    --profile aws-basic-lab --region ap-southeast-1
fi

# Delete key pair (set KEY_NAME during ec2-default-vpc.md)
if [ -n "${KEY_NAME:-}" ]; then
  aws ec2 delete-key-pair --key-name "$KEY_NAME" \
    --profile aws-basic-lab --region ap-southeast-1
  rm -f "${KEY_NAME}.pem"
fi

# Verify no lab volumes or snapshots
aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=devops-lab-${YOURNAME}-cli-data" \
  --query "Volumes[].VolumeId" --output text \
  --profile aws-basic-lab --region ap-southeast-1
```

> Backup: [03-console-labs/04-ebs/cleanup.md](../../03-console-labs/04-ebs/cleanup.md)

---

## 6. Troubleshooting

| Problem | Solution |
|---------|----------|
| `VolumeZoneNotFound` | Volume AZ must match instance AZ |
| Device not found | Run `lsblk` — NVMe names differ |
| Attach fails | Wait `volume-available` |

---

## 7. What We Achieved

- Created, attached, formatted EBS via CLI + SSH
- Snapshot with `create-snapshot`
- Cleaned up volumes, snapshots, EC2, security group, and key pair

**Next:** [s3.md](s3.md)
