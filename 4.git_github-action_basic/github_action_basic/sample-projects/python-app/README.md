# Python Basic App — Docker CI/CD to AWS EC2

> **Phase 2a** — Start here for Docker deployment practice.  
> **Prerequisites:** Complete Phase 1 in the master guide [`../../README.md`](../../README.md) (workflows `01`–`16`).  
> **This folder = its own GitHub repository** (not the Phase 1 learning repo).

A minimal **Flask** web application for learning GitHub Actions CI/CD.

| Item | Value |
|------|-------|
| Framework | Flask + Gunicorn |
| Port | `8000` |
| Container name | `python-basic-app` |
| Docker image | `<dockerhub-username>/python-basic-app:latest` |
| Endpoints | `GET /` and `GET /health` |

---

## Project Structure

```
python-app/
├── README.md
├── app.py
├── requirements.txt
├── Dockerfile
└── .github/
    └── workflows/
        └── ci-cd.yml
```

---

## 1. Run Locally (Git Bash on Windows)

### Without Docker

```bash
cd python-app

# Create virtual environment
python -m venv venv
source venv/Scripts/activate

# Install dependencies
pip install -r requirements.txt

# Run the app
python app.py
```

Open in browser:

- http://127.0.0.1:8000/
- http://127.0.0.1:8000/health

Press `Ctrl+C` to stop.

---

## 2. Docker Build and Run (Local)

### Build image

```bash
cd python-app
docker build -t python-basic-app:latest .
```

### Run container

```bash
docker run -d --name python-basic-app -p 8000:8000 python-basic-app:latest
```

### Test

```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

### Stop and remove

```bash
docker stop python-basic-app
docker rm python-basic-app
```

---

## 3. Create GitHub Repository

```bash
cd python-app

git init
git add .
git commit -m "Initial commit: Python Flask app with CI/CD"

# Create repo on GitHub (browser: https://github.com/new)
# Repository name: python-basic-app

git branch -M main
git remote add origin https://github.com/<your-username>/python-basic-app.git
git push -u origin main
```

---

## 4. GitHub Secrets Setup

Go to your repo → **Settings** → **Secrets and variables** → **Actions** → **Secrets** → **New repository secret**

| Secret | Value | Description |
|--------|-------|-------------|
| `DOCKERHUB_USERNAME` | `myusername` | Your DockerHub account name |
| `DOCKERHUB_TOKEN` | `dckr_pat_xxxxx` | DockerHub → Account Settings → Security → Access Token |
| `EC2_HOST` | `54.123.45.67` | EC2 public IPv4 address |
| `EC2_USER` | `ubuntu` | SSH username (Ubuntu AMI default) |
| `EC2_SSH_KEY` | Full PEM key content | Private key file content (see below) |

### How to copy SSH private key

```bash
# Git Bash — display your EC2 key file
cat ~/Downloads/my-ec2-key.pem
```

Copy **everything** including the header and footer:

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
...
-----END RSA PRIVATE KEY-----
```

Or OpenSSH format:

```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

Paste the full content into the `EC2_SSH_KEY` secret. **Never commit this file to Git.**

---

## 5. AWS EC2 Setup (Ubuntu)

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
| Custom TCP | 8000 | 0.0.0.0/0 | Python app |
| HTTP | 80 | 0.0.0.0/0 | Optional (Nginx later) |

### Connect to EC2

```bash
chmod 400 ~/Downloads/my-ec2-key.pem
ssh -i ~/Downloads/my-ec2-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### Install Docker on EC2

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
```

**Important:** Log out and log back in (or reboot) so the `docker` group takes effect:

```bash
exit
ssh -i ~/Downloads/my-ec2-key.pem ubuntu@<EC2_PUBLIC_IP>

# Verify Docker works without sudo
docker --version
docker ps
```

---

## 6. GitHub Actions Workflow Explained

File: `.github/workflows/ci-cd.yml`

```mermaid
flowchart LR
    A[git push main] --> B[Job 1: build-and-push]
    B --> C[Checkout code]
    C --> D[Docker Buildx]
    D --> E[Login DockerHub]
    E --> F[Build image]
    F --> G[Push to DockerHub]
    G --> H[Job 2: deploy-to-ec2]
    H --> I[SSH to EC2]
    I --> J[docker pull]
    J --> K[Stop old container]
    K --> L[Run new container]
    L --> M[curl /health]
```

### Job 1: `build-and-push`

1. Checkout your code from GitHub
2. Set up Docker Buildx (modern Docker builder)
3. Login to DockerHub using secrets
4. Build image from `Dockerfile`
5. Push as `<username>/python-basic-app:latest`

### Job 2: `deploy-to-ec2`

Runs only after Job 1 succeeds (`needs: build-and-push`).

1. SSH into EC2 using `appleboy/ssh-action`
2. `docker pull` the latest image
3. Stop and remove old `python-basic-app` container
4. Start new container on port `8000`
5. Run `curl` health check on EC2

---

## 7. How Deployment Works

```
Your Laptop  →  git push  →  GitHub Repo  →  GitHub Actions
                                                    ↓
                                              Build Docker Image
                                                    ↓
                                              Push to DockerHub
                                                    ↓
                                              SSH into EC2
                                                    ↓
                                              docker pull + docker run
                                                    ↓
                                              App live on EC2:8000
```

Every `git push` to `main` triggers a full redeploy automatically.

---

## 8. Verify Deployment

### From your laptop (Git Bash)

```bash
curl http://<EC2_PUBLIC_IP>:8000/
curl http://<EC2_PUBLIC_IP>:8000/health
```

Expected:

```
Hello from Python Flask App!
{"status":"healthy","app":"python-basic-app"}
```

### On EC2 (SSH)

```bash
docker ps
docker logs python-basic-app
curl http://localhost:8000/health
```

### In browser

Open: `http://<EC2_PUBLIC_IP>:8000/`

---

## 9. Common Troubleshooting

| Problem | Solution |
|---------|----------|
| Workflow fails at Docker login | Check `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets |
| SSH connection failed | Verify `EC2_HOST`, `EC2_USER`, `EC2_SSH_KEY`; check security group port 22 |
| `permission denied` on Docker (EC2) | Run `sudo usermod -aG docker ubuntu`, then logout/login |
| App not reachable in browser | Open port `8000` in EC2 security group |
| `curl: connection refused` | Wait 10 seconds; check `docker ps` and `docker logs python-basic-app` |
| Old code still showing | Workflow may have failed; check Actions tab for red X |
| PEM key error in SSH action | Paste full key including BEGIN/END lines; no extra spaces |

### Useful debug commands on EC2

```bash
docker ps -a
docker logs python-basic-app
docker images | grep python-basic-app
sudo systemctl status docker
```

---

## 10. Student Practice

1. Change the message in `app.py` → push → watch GitHub Actions redeploy
2. Break the Dockerfile intentionally → observe failed build in Actions tab
3. Add a new route `/version` → push → verify on EC2

---

*Part of the GitHub Actions Basic Tutorial — see [`../../README.md`](../../README.md)*
