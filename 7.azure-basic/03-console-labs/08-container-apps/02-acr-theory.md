# ACR Theory

## 1. Concept Overview

**Azure Container Registry (ACR)** is a private Docker image registry hosted by Azure. Push images from your laptop/CI; Container Apps (or AKS/ACI) pulls images to run containers.

---

## 2. Why DevOps Engineers Use ACR

- Same Azure ecosystem as Container Apps — close pulls, RBAC, private networking options
- Entra ID / managed identity for pull (prefer over admin user)
- Integrated with Azure DevOps / GitHub Actions tasks

---

## 3. Important Terms

| Term | Meaning |
|------|---------|
| **Registry** | ACR resource (name globally unique DNS) |
| **Repository** | Image name inside registry (e.g. `devops-lab-app`) |
| **Tag** | Version label (`latest`, `v1`) |
| **Login server** | `devopslab<yourname>acr.azurecr.io` |

---

## 4. Architecture Diagram

```mermaid
flowchart LR
    DEV[Docker build] -->|docker push| ACR[ACR]
    ACR -->|pull| CA[Container App]
```

---

## 5. Before You Start

Docker Desktop or Docker in Git Bash/WSL.

> **Cost warning:** ACR Basic is cheapest for labs; storage + operations bill — still delete when done.

---

## 6. Concept — Sample Dockerfile (local, not Azure)

Create on laptop `app/` folder:

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

`index.html`:

```html
<h1>devops-lab-<yourname> — Container Apps</h1>
```

Build locally:

```bash
docker build -t devops-lab-<yourname>-app .
```

---

## 10. Interview Questions

1. **ACR vs Docker Hub?**
   - *ACR is private Azure-integrated registry; Docker Hub is public/default SaaS registry.*

---

## 11. What We Achieved

- Understood ACR and image push flow

**Next:** [03-create-acr.md](03-create-acr.md)
