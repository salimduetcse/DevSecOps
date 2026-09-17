# What Is Cloud Computing?

## Learning Goal

By the end of this lesson, you can explain cloud computing in simple words and connect it to real DevOps work.

---

## Simple Definition

**Cloud computing** is the on-demand delivery of IT resources over the internet. You pay only for what you use, and you can scale up or down quickly.

Instead of buying your own servers and keeping them in your office, you use resources from a cloud provider like **Microsoft Azure**, Amazon Web Services (AWS), or Google Cloud.

Think of it like electricity:

- You do not build your own power plant.
- You plug into the grid and pay for what you consume.
- If you need more power, you do not wait months to build new capacity.

Cloud works the same way for servers, storage, databases, and networking.

---

## Five Key Characteristics of Cloud

| Characteristic | What It Means | DevOps Example |
|----------------|---------------|----------------|
| **On-demand self-service** | You provision resources yourself without calling a vendor | A DevOps engineer launches a Virtual Machine from the Azure Portal in minutes |
| **Broad network access** | Access services over the internet from many devices | Your team deploys from a laptop using Git, CI/CD, and SSH |
| **Resource pooling** | The provider shares hardware across many customers | Your `Standard_B1s` VM runs on shared physical servers managed by Azure |
| **Rapid elasticity** | Scale out or in quickly based on demand | VM Scale Sets add instances during a traffic spike, remove them after |
| **Measured service** | Usage is tracked and billed | Azure Cost Management shows how much each service cost last month |

---

## What Problems Does Cloud Solve?

### Before Cloud (Traditional IT)

A company wanted a new web application. The process looked like this:

1. Request budget for servers (weeks or months)
2. Buy hardware
3. Wait for delivery and rack installation
4. Install OS, patch, configure networking
5. Finally deploy the application

If traffic grew, they had to repeat much of this process. If traffic dropped, expensive servers sat idle.

### With Cloud

The same company today can:

1. Open the Azure Portal (or run Terraform)
2. Launch compute, storage, and database resources in minutes
3. Scale automatically with load
4. Pay only for active usage
5. Shut everything down when the project ends

This is why startups and enterprises both use cloud: **speed, flexibility, and cost control**.

---

## Cloud Is Not Just "Someone Else's Computer"

You will hear this joke in engineering teams. It is partly true, but incomplete.

Cloud gives you more than rented hardware:

- **Managed services** — Azure Database for MySQL manages database patching; Blob Storage manages durability
- **Global infrastructure** — deploy closer to users worldwide
- **API-driven automation** — everything can be scripted (perfect for DevOps)
- **Built-in security building blocks** — Microsoft Entra ID, RBAC, encryption, VNet, monitoring

As a DevOps engineer, you care about cloud because it lets you **automate infrastructure** the same way developers automate application code.

---

## Real-World DevOps Examples

| Scenario | Cloud Approach |
|----------|----------------|
| New staging environment for testing | Spin up VM + Azure Database for MySQL for 2 hours, destroy after CI pipeline finishes |
| Website traffic spike on launch day | VM Scale Set adds instances behind a load balancer |
| Backup storage for build artifacts | Push Docker images and release packages to Blob Storage / ACR |
| Disaster recovery | Replicate data to another Azure Region |
| Internal tool hosting | Run containers on Container Apps instead of maintaining physical servers |

---

## How Cloud Fits Your DevOps Journey

You already know Linux, Git, Docker, and CI/CD. Cloud is where those skills run in production.

```mermaid
flowchart LR
    A[Developer pushes code] --> B[CI/CD Pipeline]
    B --> C[Build Docker image]
    C --> D[Push to cloud registry]
    D --> E[Deploy to cloud compute]
    E --> F[Users access app over internet]
```

In this course, you will learn Azure step by step: Portal first, then CLI, then Terraform.

---

## Common Confusion

| Confusion | Clarification |
|-----------|---------------|
| "Cloud means no servers exist" | Servers still exist — they are in Azure data centers, not your office |
| "Cloud is always cheaper" | Not always. Poorly designed workloads can cost more than on-premises |
| "Cloud removes the need for ops" | Wrong. DevOps work shifts to automation, security, monitoring, and cost control |
| "One cloud provider does everything best" | Most companies use one primary provider (here: Azure) but may use SaaS tools from others |
| "Free trial means everything is free" | Free Account has limits and time bounds. Always check pricing |

---

## Small Example (Conceptual)

Your team needs a Linux server to test nginx for one afternoon.

**On-premises:** Wait for IT to provision a VM — might take days.

**Cloud:** Launch an Azure VM at 10:00 AM, test nginx, delete at 4:00 PM. You pay for roughly 6 hours of a small instance.

No lab steps yet — this is the *idea* you will practice in Module 03.

---

## Interview-Style Questions

1. **What is cloud computing in one sentence?**
   - *On-demand IT resources delivered over the internet with pay-as-you-go pricing.*

2. **Name three benefits of cloud for a DevOps team.**
   - *Speed of provisioning, elasticity/scaling, and automation through APIs.*

3. **What is elasticity?**
   - *The ability to increase or decrease resources based on demand.*

4. **Is cloud the same as virtualization?**
   - *No. Virtualization is one technology. Cloud adds self-service, elasticity, measured billing, and broad network access.*

5. **Why do companies still hire DevOps engineers if cloud is "managed"?**
   - *Someone must design, deploy, secure, monitor, and optimize workloads. Cloud manages the platform; you manage the workload.*

---

## References to Verify

- [NIST Definition of Cloud Computing (SP 800-145)](https://csrc.nist.gov/publications/detail/sp/800-145/final) — official characteristics of cloud
- [Azure — What is cloud computing?](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-cloud-computing/) — Azure overview
- [Microsoft Learn — Azure fundamentals](https://learn.microsoft.com/training/paths/azure-fundamentals-describe-cloud-concepts/) — beginner-friendly Azure learning path

---

**Next:** [02-saas-paas-iaas.md](02-saas-paas-iaas.md) — understand *who manages what* in the cloud.
