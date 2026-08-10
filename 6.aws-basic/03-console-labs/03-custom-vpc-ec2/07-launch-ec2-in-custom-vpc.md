# Launch EC2 in Custom VPC

## 1. Concept Overview

Launch EC2 in **public subnet** of your custom VPC, install nginx, test SSH and HTTP — same as default VPC lab but on **your network**.

---

## 2. Why DevOps Engineers Do This

Production apps run in custom VPCs, not default. This lab proves your VPC design works.

---

## 3. Important Terms

| Resource | Name |
|----------|------|
| Instance | `devops-lab-<yourname>-vpc-web` |
| Key pair | `devops-lab-<yourname>-vpc-key` (or reuse previous) |
| SG | `devops-lab-<yourname>-vpc-sg` |

---

## 4. Architecture Diagram

```mermaid
flowchart LR
    YOU -->|SSH/HTTP| IGW --> EC2[EC2 in public subnet]
    EC2 --> VPC[10.0.1.0/24]
```

---

## 5. Before You Start

Complete VPC, subnet, IGW, route table, SG steps.

> **Cost warning:** EC2 bills while running. Terminate after lab.

---

## 6. Step-by-Step AWS Console Lab

### Step 1 — Launch instance

1. **EC2** → **Launch instances**
2. **Name:** `devops-lab-<yourname>-vpc-web`
3. **AMI:** Amazon Linux 2023
4. **Type:** `t3.micro`
5. **Key pair:** create or select `devops-lab-<yourname>-vpc-key`
6. **Network:**
   - VPC: `devops-lab-<yourname>-vpc`
   - Subnet: `devops-lab-<yourname>-public-1a`
   - Auto-assign public IP: **Enable**
   - SG: `devops-lab-<yourname>-vpc-sg`
7. **Launch**

### Step 2 — SSH and install nginx

```bash
ssh -i devops-lab-<yourname>-vpc-key.pem ec2-user@<PUBLIC_IP>

sudo dnf install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>Custom VPC — devops-lab-<yourname></h1>" | sudo tee /usr/share/nginx/html/index.html
```

### Step 3 — Browser test

Open `http://<PUBLIC_IP>` from laptop.

---

## 7. Validation / Testing Steps

| Check | Expected |
|-------|----------|
| Instance in custom VPC | VPC ID matches |
| Subnet | Public subnet |
| SSH | Works |
| HTTP | nginx page loads |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| No public IP | Subnet auto-assign off — fix subnet setting or relaunch |
| Timeout | Route table missing IGW route |
| Wrong VPC | Terminate and relaunch |

---

## 9. Cleanup

[cleanup.md](cleanup.md) immediately after validation.

---

## 10. Interview Questions

1. **Why launch in public subnet for this lab?**
   - *Direct internet access via IGW for SSH and HTTP testing.*

2. **Where would RDS go?**
   - *Private subnet with SG allowing only app tier.*

---

## 11. What We Achieved

- EC2 running in **custom VPC** public subnet
- nginx tested over HTTP
- End-to-end custom network working

**Next:** [cleanup.md](cleanup.md)
