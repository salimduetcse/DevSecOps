# Install nginx and Test

## 1. Concept Overview

**nginx** is a popular web server and reverse proxy. You will install it on EC2 and test HTTP on **port 80** from your browser.

This proves: instance runs → security group allows HTTP → web server responds.

---

## 2. Why DevOps Engineers Use nginx

- Serve static sites and reverse proxy to apps
- Lightweight and common in production
- Standard lab for verifying EC2 networking

---

## 3. Important Terms

| Term | Meaning |
|------|---------|
| **systemd** | Service manager on Amazon Linux (`systemctl`) |
| **Port 80** | Default HTTP port |
| **Security group** | Must allow inbound TCP 80 for browser test |

---

## 4. Architecture Diagram

```mermaid
flowchart LR
    BROWSER[Your Browser] -->|HTTP :80| SG[Security Group]
    SG --> NGINX[nginx on EC2]
    NGINX --> PAGE[Default welcome page]
```

---

## 5. Before You Start

| Item | Detail |
|------|--------|
| SSH access | Working from previous lesson |
| Security group | HTTP (80) from **My IP** |
| Public IP | Copied from EC2 console |

> **Cost warning:** Instance still running = still billing.

---

## 6. Step-by-Step Lab

### Step 1 — SSH to instance

```bash
ssh -i devops-lab-<yourname>-key.pem ec2-user@<PUBLIC_IP>
```

### Step 2 — Update packages and install nginx

Amazon Linux 2023:

```bash
sudo dnf update -y
sudo dnf install nginx -y
```

### Step 3 — Start and enable nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

Press `q` to exit status view. Look for **active (running)**.

### Step 4 — Verify locally on server

```bash
curl localhost
```

You should see HTML with **Welcome to nginx** or Amazon Linux default page.

### Step 5 — Test from your browser

1. On your Windows laptop, open browser
2. Go to: `http://<PUBLIC_IP>`
3. You should see the nginx welcome page

> Use `http://` not `https://` — we did not configure TLS in this lab.

### Step 6 — Custom page (optional)

```bash
echo "<h1>devops-lab-<yourname> — nginx works!</h1>" | sudo tee /usr/share/nginx/html/index.html
```

Refresh browser — see your message.

---

## 7. Validation / Testing Steps

| Check | Command / Action | Expected |
|-------|------------------|----------|
| nginx running | `sudo systemctl is-active nginx` | `active` |
| Local curl | `curl localhost` | HTML response |
| Browser | `http://<PUBLIC_IP>` | Page loads |
| Port listening | `sudo ss -tlnp \| grep :80` | nginx on port 80 |

---

## 8. Troubleshooting

| Problem | Solution |
|---------|----------|
| Browser timeout | Add HTTP 80 from **My IP** in security group; check public IP |
| Connection refused | `sudo systemctl start nginx` |
| Wrong page | Clear browser cache; verify custom `index.html` path |
| curl works, browser fails | Your laptop IP changed — update SG HTTP rule to **My IP** |

---

## 9. Cleanup

Keep instance for security group lesson. Full cleanup in [cleanup.md](cleanup.md).

---

## 10. Interview Questions

1. **How do you install a package on Amazon Linux 2023?**
   - *`sudo dnf install <package>`*

2. **How do you start a service on boot?**
   - *`sudo systemctl enable <service>`*

3. **Why allow HTTP only from My IP in a lab?**
   - *Reduces exposure; production would use ALB + HTTPS for public sites.*

---

## 11. What We Achieved

- Installed and started **nginx**
- Verified HTTP on port **80** from browser
- Confirmed EC2 + security group + web server work together

**Next:** [05-security-group-explanation.md](05-security-group-explanation.md)
