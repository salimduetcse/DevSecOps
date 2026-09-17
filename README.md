# Azure Basic for DevOps Professionals

A hands-on, classroom-ready foundation course for fresh DevOps engineers learning Azure from zero. You will start in the Azure Portal, move to the Azure CLI, then automate with Terraform, and finish with capstone projects.

This repo focuses on foundational Azure operations and lab execution. It is not meant to replace deeper production topics such as multi-subscription governance, advanced Entra ID design, remote-state platform design, or full observability engineering.

## Who This Course Is For

- Fresh DevOps engineers starting their cloud journey
- Students who already know basic **Linux**, **Git**, **Docker**, and **CI/CD** concepts
- Anyone learning Azure from scratch in a structured, lab-first way
- Instructors teaching Azure in a classroom or bootcamp setting

## Course Flow

```
Fundamentals -> Portal Labs -> Azure CLI -> Terraform -> Capstone Projects
```

| Phase | Module | What You Learn |
|-------|--------|----------------|
| 1 | [00-course-setup](00-course-setup/) | Subscription safety, prerequisites, naming conventions |
| 2 | [01-cloud-fundamentals](01-cloud-fundamentals/) | Cloud concepts, pricing, deployment models |
| 3 | [02-azure-foundation](02-azure-foundation/) | Azure global infrastructure, security, frameworks |
| 4 | [03-console-labs](03-console-labs/) | Hands-on labs via Azure Portal |
| 5 | [04-azure-cli](04-azure-cli/) | Same labs using Azure CLI |
| 6 | [05-terraform](05-terraform/) | Same labs using Infrastructure as Code |
| 7 | [06-capstone-project](06-capstone-project/) | End-to-end projects combining all skills |

See [COURSE-ROADMAP.md](COURSE-ROADMAP.md) for the full phase-wise plan.

## Required Tools

| Tool | Purpose |
|------|---------|
| Azure Subscription | Free trial or pay-as-you-go subscription for labs |
| Web browser | Azure Portal |
| Git | Clone this repo and track your work |
| SSH client | Connect to Azure VMs (Git Bash on Windows works) |
| Text editor | VS Code or similar for Markdown and config files |
| Azure CLI | Module 04 - install guide included |
| Terraform | Module 05 - install guide included |
| Docker | Module 03 (Container Apps lab) and capstone projects |

## Safety Warning - Azure Costs

> **You are responsible for every resource you create.** Labs use Free trial credits or lowest-cost options where possible, but mistakes (forgotten VMs, open MySQL servers, load balancers left running) can generate charges.

Before starting:

1. Read [COST-AND-SAFETY-GUIDE.md](COST-AND-SAFETY-GUIDE.md)
2. Set up budgets and cost alerts in your Azure subscription
3. Complete the **cleanup section** at the end of every lab
4. Never commit real Azure credentials, service principal secrets, or SSH keys to Git

## Recommended Lab Region

**Default region: `southeastasia` (Southeast Asia)**

You may use a different region if your instructor allows it. Keep one region for all labs to avoid confusion and extra cross-region costs. Update region settings in the Portal, Azure CLI defaults, and Terraform provider consistently.

## Suggested Git Workflow

```bash
# Clone the course repo
git clone <your-repo-url>
cd azure-basic

# Create your own branch for notes and lab artifacts
git checkout -b student/<your-name>

# After each module, commit your notes (never commit credentials)
git add .
git commit -m "Complete module 03-console-labs/02-vm-default-vnet"

# Push to your fork or branch
git push -u origin student/<your-name>
```

**Rules:**

- Use a `.gitignore` for local secrets (e.g. `*.pem`, `.env`, `terraform.tfstate`)
- Use placeholder values in configs - see [00-course-setup/lab-naming-convention.md](00-course-setup/lab-naming-convention.md)
- Fork or branch; do not push secrets to shared repos

## Quick Links

- [Course Roadmap](COURSE-ROADMAP.md)
- [Cost and Safety Guide](COST-AND-SAFETY-GUIDE.md)
- [Glossary](GLOSSARY.md)
- [Student Prerequisites](00-course-setup/student-prerequisites.md)

---

**Instructor note:** Teach theory first, then lab. Portal -> CLI -> Terraform reinforces the same services in three ways.
