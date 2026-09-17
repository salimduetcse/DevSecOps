# Install nginx and Test

## 1. Concept Overview

**nginx** is a popular web server and reverse proxy. You will install it on the Azure VM and test HTTP on **port 80** from your browser.

This proves: VM runs → NSG allows HTTP → web server responds.

---

## 2. Why DevOps Engineers Use nginx

- Serve static sites and reverse proxy to apps
- Lightweight and common in production
- Standard lab for verifying VM networking

---

## 3. Important Terms

| Term | Meaning |
|------|---------|
| **systemd** | Service manager on Ubuntu (`systemctl`) |
| **Port 80** | Default HTTP port |
| **NSG** | Must allow inbound TCP 80 for browser test |

---

## 4. Architecture Diagram

```mermaid
flowchart LR
    BROWSER[Your Browser] -->|HTTP :80| NSG[Network Security Group]
    NSG --> NGINX[nginx on Azure VM]
    NGINX --> PAGE[Default welcome page]
```

---

## 5. Before You Start

| Item | Detail |
|------|--------|
| SSH access | Working from previous lesson |
| NSG | You will add HTTP (80) from your IP |
| Public IP | Copied from VM Overview |

> **Cost warning:** VM still running = still billing.

---

## 6. Step-by-Step Lab

### Step 1 — Allow HTTP in NSG

1. Portal → VM `devops-lab-<yourname>-web` → **Networking**
2. **Add inbound port rule** (or edit NSG):
   - **Destination port:** 80
   - **Protocol:** TCP
   - **Source:** IP Addresses → `YOUR_PUBLIC_IP/32`
   - **Name:** `Allow-HTTP-MyIP`
3. Save

### Step 2 — SSH to VM

```bash
ssh -i ~/.ssh/devops-lab-<yourname>-key azureuser@<PUBLIC_IP>
```

### Step 3 — Update packages and install nginx

Ubuntu 22.04:

```bash
sudo apt update
sudo apt install nginx -y
```

### Step 4 — Start and enable nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

Press `q` to exit status view. Look for **active (running)**.

### Step 5 — Verify locally on server

```bash
curl localhost
```

You should see HTML with **Welcome to nginx**.

### Step 6 — Test from your browser

1. On your Windows laptop, open browser
2. Go to: `http://<PUBLIC_IP>`
3. You should see the nginx welcome page

> Use `http://` not `https://` — we did not configure TLS in this lab.

### Step 7 — Custom page (optional)

```bash
echo "<h1>devops-lab-<yourname> — nginx works!</h1>" | sudo tee /var/www/html/index.nginx-debian.html
# or edit /var/www/html/index.html depending on package layout
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
| Browser timeout | Add HTTP 80 from your IP in NSG; check public IP; confirm VM Running |
| Connection refused | `sudo systemctl start nginx` |
| Wrong page | Clear browser cache; verify `index.html` path under `/var/www/html` |
| curl works, browser fails | Your laptop IP changed — update NSG HTTP rule to new `/32` |
| apt fails | Outbound internet blocked — check NSG outbound defaults (usually Allow) |

---

## 9. Cleanup

Keep VM for NSG lesson. Full cleanup in [cleanup.md](cleanup.md) — or defer until Lab 04.

---

## 10. Interview Questions

1. **How do you install a package on Ubuntu?**
   - *`sudo apt update && sudo apt install <package>`*

2. **How do you start a service on boot?**
   - *`sudo systemctl enable <service>`*

3. **Why allow HTTP only from your IP in a lab?**
   - *Reduces exposure; production would use Load Balancer + HTTPS for public sites.*

---

## 11. What We Achieved

- Installed and started **nginx**
- Verified HTTP on port **80** from browser
- Confirmed VM + NSG + web server work together

**Next:** [05-nsg-explanation.md](05-nsg-explanation.md)

---

## 12. References

- [nginx on Ubuntu](https://ubuntu.com/server/docs/web-servers-nginx)
- [Filter network traffic with NSGs](https://learn.microsoft.com/azure/virtual-network/network-security-group-how-it-works)
