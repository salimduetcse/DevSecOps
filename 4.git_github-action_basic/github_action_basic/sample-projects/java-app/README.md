# Java Basic App — Docker CI/CD to AWS EC2

> **Phase 2c** — Do after Phase 2a or 2b.  
> **Prerequisites:** Phase 1 complete — see master guide [`../../README.md`](../../README.md).  
> **This folder = its own GitHub repository.**

A minimal **Java HTTP server** (Maven) for learning GitHub Actions CI/CD.

| Item | Value |
|------|-------|
| Build tool | Maven |
| Java version | 17 |
| Port | `8080` |
| Container name | `java-basic-app` |
| Docker image | `<dockerhub-username>/java-basic-app:latest` |
| Endpoints | `GET /` and `GET /health` |

---

## Project Structure

```
java-app/
├── README.md
├── pom.xml
├── Dockerfile
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── example/
│                   └── App.java
└── .github/
    └── workflows/
        └── ci-cd.yml
```

---

## 1. Run Locally (Git Bash on Windows)

### Prerequisites

- Java 17+ (`java -version`)
- Maven 3.8+ (`mvn -version`)

### Build and run

```bash
cd java-app

# Build JAR
mvn clean package

# Run the app
java -jar target/java-basic-app-1.0.0.jar
```

Open in browser:

- http://127.0.0.1:8080/
- http://127.0.0.1:8080/health

Press `Ctrl+C` to stop.

---

## 2. Docker Build and Run (Local)

### Build image

```bash
cd java-app
docker build -t java-basic-app:latest .
```

The Dockerfile uses a **multi-stage build**:

1. **Stage 1 (builder):** Maven compiles and packages the JAR
2. **Stage 2 (runtime):** Lightweight JRE runs the JAR

### Run container

```bash
docker run -d --name java-basic-app -p 8080:8080 java-basic-app:latest
```

### Test

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
```

### Stop and remove

```bash
docker stop java-basic-app
docker rm java-basic-app
```

---

## 3. Create GitHub Repository

```bash
cd java-app

git init
git add .
git commit -m "Initial commit: Java app with CI/CD"

# Create repo on GitHub (browser: https://github.com/new)
# Repository name: java-basic-app

git branch -M main
git remote add origin https://github.com/<your-username>/java-basic-app.git
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
| Custom TCP | 8080 | 0.0.0.0/0 | Java app |
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
    E --> F[Build image - Maven inside Docker]
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
2. Set up Docker Buildx
3. Login to DockerHub using secrets
4. Build image (Maven compiles Java inside Docker — no Java needed on EC2)
5. Push as `<username>/java-basic-app:latest`

### Job 2: `deploy-to-ec2`

Runs only after Job 1 succeeds (`needs: build-and-push`).

1. SSH into EC2 using `appleboy/ssh-action`
2. `docker pull` the latest image
3. Stop and remove old `java-basic-app` container
4. Start new container on port `8080`
5. Run `curl` health check on EC2

---

## 7. How Deployment Works

```
Your Laptop  →  git push  →  GitHub Repo  →  GitHub Actions
                                                    ↓
                                    Docker build (Maven + JRE inside)
                                                    ↓
                                              Push to DockerHub
                                                    ↓
                                              SSH into EC2
                                                    ↓
                                              docker pull + docker run
                                                    ↓
                                              App live on EC2:8080
```

EC2 only needs Docker — Java and Maven run inside the container during build (on GitHub runner) and at runtime (JRE in container).

---

## 8. Verify Deployment

### From your laptop (Git Bash)

```bash
curl http://<EC2_PUBLIC_IP>:8080/
curl http://<EC2_PUBLIC_IP>:8080/health
```

Expected:

```
Hello from Java App!
{"status":"healthy","app":"java-basic-app"}
```

### On EC2 (SSH)

```bash
docker ps
docker logs java-basic-app
curl http://localhost:8080/health
```

### In browser

Open: `http://<EC2_PUBLIC_IP>:8080/`

---

## 9. Common Troubleshooting

| Problem | Solution |
|---------|----------|
| Workflow fails at Docker login | Check `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets |
| SSH connection failed | Verify `EC2_HOST`, `EC2_USER`, `EC2_SSH_KEY`; check security group port 22 |
| `permission denied` on Docker (EC2) | Run `sudo usermod -aG docker ubuntu`, then logout/login |
| App not reachable in browser | Open port `8080` in EC2 security group |
| `curl: connection refused` | Wait 10–15 seconds (Java startup); check `docker logs java-basic-app` |
| Maven build fails locally | Check Java 17: `java -version` and Maven: `mvn -version` |
| Docker build slow | Normal — Maven downloads dependencies on first build |
| PEM key error in SSH action | Paste full key including BEGIN/END lines; no extra spaces |

### Useful debug commands on EC2

```bash
docker ps -a
docker logs java-basic-app
docker images | grep java-basic-app
sudo systemctl status docker
```

---

## 10. Student Practice

1. Change the home page message in `App.java` → push → verify redeploy on EC2
2. Study the multi-stage `Dockerfile` — why is it smaller than a single-stage build?
3. Add a `/time` endpoint returning current timestamp

---

*Part of the GitHub Actions Basic Tutorial — see [`../../README.md`](../../README.md)*
