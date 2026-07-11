# Python WSGI Self-Hosted Runner Deployment

> **Phase 3** — Do after completing at least one Phase 2 Docker project.  
> **Master guide:** [`../../README.md`](../../README.md) Sections 21–23 for theory.  
> **This folder = its own GitHub repository** with self-hosted runner on EC2.

Deploy a **Flask** application to AWS EC2 **without Docker** using a **GitHub Actions self-hosted runner**, **Gunicorn**, and **systemd**.

| Item | Value |
|------|-------|
| Framework | Flask + Gunicorn (WSGI) |
| Port | `8000` |
| Service name | `python-wsgi-app.service` |
| App path on EC2 | `/home/ubuntu/python-wsgi-self-hosted-runner` |
| Endpoints | `GET /` and `GET /health` |
| Deployment | Self-hosted runner (no Docker, no SSH from GitHub) |

---

## Project Structure

```
python-wsgi-self-hosted-runner/
├── README.md
├── app.py
├── requirements.txt
├── gunicorn.service.example
└── .github/
    └── workflows/
        └── self-hosted-deploy.yml
```

---

## 1. What is a Self-Hosted Runner?

A **self-hosted runner** is your own machine (EC2, laptop, on-prem server) registered with GitHub to execute workflow jobs.

```
Normal CI/CD:     GitHub cloud runner  →  SSH into your EC2  →  deploy
Self-hosted:      Your EC2 IS the runner  →  deploy directly (no SSH)
```

When a workflow uses `runs-on: self-hosted`, GitHub sends the job to **your EC2** instead of GitHub's cloud. The runner agent on EC2 pulls the job, runs the steps locally, and reports results back to GitHub.

---

## 2. GitHub-Hosted Runner vs Self-Hosted Runner

| | GitHub-Hosted | Self-Hosted |
|--|--------------|-------------|
| **Machine** | GitHub provides (`ubuntu-latest`) | You provide (your EC2) |
| **Setup** | Zero configuration | Install runner agent on server |
| **Cost** | Free minutes (limits apply) | You pay for EC2 |
| **Network** | Public internet only | Access private VPC, internal DBs |
| **Deploy method** | Usually SSH from GitHub to EC2 | Direct — runner is already on EC2 |
| **Maintenance** | GitHub manages OS | You patch and secure the server |
| **Best for** | Learning, open source, most CI | Same-server deploy, private networks |

---

## 3. Why Use a Self-Hosted Runner?

| Benefit | Explanation |
|---------|-------------|
| **Private network access** | Runner can reach internal databases, APIs, and services not exposed to the internet |
| **Deploy inside company network** | No need to open SSH from GitHub's IP ranges to your servers |
| **Custom tools** | Pre-install any software on the runner (specific Python version, company certs) |
| **Faster deployment** | No SSH hop, no Docker pull — code updates directly on the same machine |
| **No SSH from GitHub** | If the runner is on EC2, deployment steps run locally — no `appleboy/ssh-action` needed |

---

## 4. Security Concerns

Self-hosted runners are powerful. Treat them carefully.

| Risk | Mitigation |
|------|-----------|
| Runner has full server access | Use a dedicated EC2 instance — not your personal laptop |
| Untrusted code can run on your server | **Do not** use on public repos with untrusted contributors |
| Secrets exposed to runner | Limit who can push to `main`; use branch protection rules |
| Runner compromise = server compromise | Keep EC2 patched; monitor runner logs |
| Over-privileged service restarts | Use `sudoers` with least privilege (only specific commands) |

### Recommended practices

- Use self-hosted runners on **private repositories** only
- Enable **branch protection** on `main`
- Restrict deployment workflow to `main` branch pushes
- Give `ubuntu` user sudo only for the specific `systemctl` command (see Section 8)
- Rotate GitHub tokens if runner is re-registered

---

## 5. AWS EC2 Setup

### Launch EC2 instance

| Setting | Value |
|---------|-------|
| AMI | Ubuntu Server 22.04 LTS |
| Instance type | `t2.micro` (free tier) |
| Key pair | Create and download `.pem` file |

### Security Group — open these ports

| Type | Port | Source | Purpose |
|------|------|--------|---------|
| SSH | 22 | My IP | SSH access |
| Custom TCP | 8000 | 0.0.0.0/0 | Gunicorn app (direct access) |
| HTTP | 80 | 0.0.0.0/0 | Nginx reverse proxy (optional) |

### Connect to EC2 (Git Bash on Windows)

```bash
chmod 400 ~/Downloads/my-ec2-key.pem
ssh -i ~/Downloads/my-ec2-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### Install required packages

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip nginx curl git
```

Verify:

```bash
python3 --version
nginx -v
```

---

## 6. GitHub Self-Hosted Runner Setup

### Step 1 — Create GitHub repository

```bash
# On your laptop (Git Bash)
cd python-wsgi-self-hosted-runner
git init
git add .
git commit -m "Initial commit: WSGI self-hosted runner app"
git branch -M main
git remote add origin https://github.com/<your-username>/python-wsgi-self-hosted-runner.git
git push -u origin main
```

### Step 2 — Get runner registration commands from GitHub

1. Go to your repo on GitHub
2. **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Select **Linux** and **x64**
5. Copy the commands shown (example below — use the exact commands from your GitHub UI)

### Step 3 — Run on EC2

```bash
# SSH into EC2 first
ssh -i ~/Downloads/my-ec2-key.pem ubuntu@<EC2_PUBLIC_IP>

# Create a folder for the runner
mkdir -p ~/actions-runner && cd ~/actions-runner

# Download runner (version from GitHub UI — example version shown)
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

# Configure — paste URL and token from GitHub UI
./config.sh --url https://github.com/<your-username>/python-wsgi-self-hosted-runner --token <TOKEN>
```

When prompted:

- Runner group: press Enter (default)
- Runner name: `ec2-wsgi-runner` (or press Enter for default)
- Labels: press Enter (default includes `self-hosted`)
- Work folder: press Enter (default `_work`)

### Step 4 — Install as a background service

```bash
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
```

Verify in GitHub: **Settings → Actions → Runners** — status should show **Idle** (green).

---

## 7. Application Setup on EC2

Clone the repo and set up the Python virtual environment:

```bash
cd /home/ubuntu
git clone https://github.com/<your-username>/python-wsgi-self-hosted-runner.git
cd python-wsgi-self-hosted-runner

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Test Gunicorn manually (before systemd)

```bash
source venv/bin/activate
gunicorn --workers 2 --bind 0.0.0.0:8000 app:app
```

In another terminal (or from laptop):

```bash
curl http://<EC2_PUBLIC_IP>:8000/health
```

Press `Ctrl+C` to stop Gunicorn after testing.

---

## 8. systemd Setup

### Copy and enable the service

```bash
cd /home/ubuntu/python-wsgi-self-hosted-runner
sudo cp gunicorn.service.example /etc/systemd/system/python-wsgi-app.service
sudo systemctl daemon-reload
sudo systemctl enable python-wsgi-app
sudo systemctl start python-wsgi-app
sudo systemctl status python-wsgi-app
```

Expected output: `Active: active (running)`

### Allow ubuntu to restart service without password (for GitHub Actions)

The workflow runs as `ubuntu` and needs `sudo systemctl restart`. Add a sudoers rule:

```bash
sudo visudo -f /etc/sudoers.d/python-wsgi-app
```

Add this line:

```
ubuntu ALL=(ALL) NOPASSWD: /bin/systemctl restart python-wsgi-app, /bin/systemctl status python-wsgi-app, /bin/systemctl is-active python-wsgi-app
```

Save and verify:

```bash
sudo systemctl restart python-wsgi-app   # Should not ask for password
```

### Useful systemd commands

```bash
sudo systemctl start python-wsgi-app
sudo systemctl stop python-wsgi-app
sudo systemctl restart python-wsgi-app
sudo systemctl status python-wsgi-app
sudo journalctl -u python-wsgi-app -f    # Live logs
```

---

## 9. GitHub Actions Deployment

File: `.github/workflows/self-hosted-deploy.yml`

```mermaid
flowchart LR
    A[git push main] --> B[GitHub detects push]
    B --> C[Send job to self-hosted runner on EC2]
    C --> D[Checkout code]
    D --> E[Create/update venv]
    E --> F[pip install requirements]
    F --> G[systemctl restart python-wsgi-app]
    G --> H[curl /health]
    H --> I[Deploy complete]
```

### What happens on every push to `main`

1. GitHub sends the workflow job to your EC2 runner (not GitHub cloud)
2. Runner checks out latest code into its work directory
3. Creates or updates Python `venv`
4. Installs packages from `requirements.txt`
5. Restarts `python-wsgi-app` systemd service
6. Verifies `/health` endpoint with `curl`

### Key difference from Docker deploy (Phase 2)

| Phase 2 (Docker) | Phase 3 (WSGI Self-Hosted) |
|-----------------|---------------------------|
| Runs on `ubuntu-latest` (GitHub cloud) | Runs on `self-hosted` (your EC2) |
| Builds Docker image | Uses Python venv directly |
| SSH into EC2 to deploy | No SSH — runner is on EC2 |
| `docker pull` + `docker run` | `pip install` + `systemctl restart` |

### Trigger a deploy

```bash
# Make a change locally
echo "# updated" >> README.md
git add .
git commit -m "Trigger self-hosted deploy"
git push origin main
```

Watch progress: GitHub → **Actions** → **Self-Hosted WSGI Deploy**

---

## 10. Optional Nginx Reverse Proxy

Nginx listens on port 80 and forwards traffic to Gunicorn on port 8000.

### Create Nginx config

```bash
sudo nano /etc/nginx/sites-available/python-wsgi-app
```

Paste:

```nginx
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Enable the site

```bash
sudo ln -s /etc/nginx/sites-available/python-wsgi-app /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

Now students can access the app on port 80 (no `:8000` needed).

---

## 11. Verification

### Direct Gunicorn (port 8000)

```bash
# On EC2
curl http://localhost:8000/
curl http://localhost:8000/health

# From laptop (Git Bash)
curl http://<EC2_PUBLIC_IP>:8000/
curl http://<EC2_PUBLIC_IP>:8000/health
```

Expected:

```
Hello from Python WSGI Self-Hosted Deployment!
{"status":"healthy","app":"python-wsgi-self-hosted-runner"}
```

### Through Nginx (port 80) — if configured

```bash
curl http://<EC2_PUBLIC_IP>/
curl http://<EC2_PUBLIC_IP>/health
```

### In browser

- Direct: `http://<EC2_PUBLIC_IP>:8000/`
- Via Nginx: `http://<EC2_PUBLIC_IP>/`

---

## 12. Troubleshooting

| Problem | Solution |
|---------|----------|
| **Runner offline** | On EC2: `sudo ./svc.sh status` in `~/actions-runner`. Restart: `sudo ./svc.sh start` |
| **Runner not picking up jobs** | Check GitHub → Settings → Runners shows **Idle**. Re-register if needed |
| **Permission denied for systemctl** | Add sudoers rule (Section 8). Workflow user must be `ubuntu` |
| **Port 8000 not reachable** | Open port 8000 in EC2 security group |
| **Gunicorn service failed** | `sudo journalctl -u python-wsgi-app -n 50` — check error message |
| **Python venv missing** | Workflow creates venv automatically. Manual fix: `python3 -m venv venv` |
| **Wrong working directory** | Service `WorkingDirectory` must match repo path on EC2 |
| **Workflow not triggering** | Ensure `.github/workflows/self-hosted-deploy.yml` is on `main` branch |
| **Module not found after deploy** | Runner work dir may differ from service dir — ensure `pip install` runs in correct path |
| **Nginx 502 Bad Gateway** | Gunicorn not running: `sudo systemctl status python-wsgi-app` |

### Debug commands

```bash
# Service logs
sudo journalctl -u python-wsgi-app -f

# Check if Gunicorn is listening
ss -tlnp | grep 8000

# Check runner service
cd ~/actions-runner && sudo ./svc.sh status

# Test venv manually
cd /home/ubuntu/python-wsgi-self-hosted-runner
source venv/bin/activate
gunicorn --workers 2 --bind 0.0.0.0:8000 app:app
```

### How code reaches Gunicorn

The self-hosted runner checks out code to its `_work/` folder, but systemd runs Gunicorn from `/home/ubuntu/python-wsgi-self-hosted-runner/`. The workflow **syncs** `app.py` and `requirements.txt` to that fixed path before updating the venv and restarting the service. Do not change `WorkingDirectory` in `gunicorn.service.example` unless you also update the workflow sync path.

---

## Student Practice Tasks

- [ ] Register self-hosted runner on EC2 and verify **Idle** status in GitHub
- [ ] Start Gunicorn via systemd and verify `curl /health`
- [ ] Push a code change and watch the self-hosted workflow deploy automatically
- [ ] Add optional Nginx reverse proxy and access app on port 80
- [ ] Compare this deploy with Phase 2 Docker deploy — list 3 differences

---

## Quick Reference

| Task | Command |
|------|---------|
| Start app | `sudo systemctl start python-wsgi-app` |
| Restart app | `sudo systemctl restart python-wsgi-app` |
| View logs | `sudo journalctl -u python-wsgi-app -f` |
| Runner status | `cd ~/actions-runner && sudo ./svc.sh status` |
| Health check | `curl http://localhost:8000/health` |
| Manual deploy trigger | GitHub → Actions → Run workflow |

---

*Part of the GitHub Actions Basic Tutorial — see [`../../README.md`](../../README.md)*
