# Lab 08 — Azure Container Apps

## What This Module Teaches

Container deployment on Azure: ACR for images, Container Apps environments, Container Apps, and exposing an app via built-in ingress (HTTPS/FQDN) — without managing a separate load balancer for the basic path.

## Learning Objectives

- Explain Azure Container Apps vs managing Kubernetes yourself (intro level)
- Push a Docker image to Azure Container Registry (ACR)
- Create a Container Apps environment
- Deploy a Container App from ACR
- Test ingress FQDN / HTTPS and understand basic scaling

## Lab Outcome

A containerized web application running on Azure Container Apps, reachable through the app’s ingress FQDN, with the image stored in ACR.

## Estimated Time

4–5 hours

## Cost Warning

**Container Apps + ACR costs add up while the app is running.** Use smallest CPU/memory, min replicas **1** (or 0 with scale-to-zero if offered), and delete environment/app/ACR per [cleanup.md](cleanup.md). ACR storage is modest; running replicas and the environment’s Log Analytics can cost more than students expect.

## Cleanup Reminder

Delete Container App → environment → ACR (or at least images) → Log Analytics if lab-owned. See [cleanup.md](cleanup.md).

## Lessons

| # | File | Topic |
|---|------|-------|
| 1 | [01-container-apps-theory.md](01-container-apps-theory.md) | Container Apps theory |
| 2 | [02-acr-theory.md](02-acr-theory.md) | ACR theory |
| 3 | [03-create-acr.md](03-create-acr.md) | Create ACR |
| 4 | [04-create-container-apps-environment.md](04-create-container-apps-environment.md) | Create environment |
| 5 | [05-create-container-app.md](05-create-container-app.md) | Create Container App |
| 6 | [06-ingress-and-test.md](06-ingress-and-test.md) | Ingress and test |
| — | [cleanup.md](cleanup.md) | Lab cleanup |
