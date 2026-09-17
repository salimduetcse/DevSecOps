# AWS Basic for DevOps Professionals

A hands-on, classroom-ready foundation course for fresh DevOps engineers learning AWS from zero. You will start in the AWS Console, move to the AWS CLI, then automate with Terraform, and finish with capstone projects.

This repo focuses on foundational AWS operations and lab execution. It is not meant to replace deeper production topics such as multi-account governance, advanced IAM design, remote-state platform design, or full observability engineering.

## Who This Course Is For

- Fresh DevOps engineers starting their cloud journey
- Students who already know basic **Linux**, **Git**, **Docker**, and **CI/CD** concepts
- Anyone learning AWS from scratch in a structured, lab-first way
- Instructors teaching AWS in a classroom or bootcamp setting

## Course Flow

```
Fundamentals -> Console Labs -> AWS CLI -> Terraform -> Capstone Projects
```

| Phase | Module | What You Learn |
|-------|--------|----------------|
| 1 | [00-course-setup](00-course-setup/) | Account safety, prerequisites, naming conventions |
| 2 | [01-cloud-fundamentals](01-cloud-fundamentals/) | Cloud concepts, pricing, deployment models |
| 3 | [02-aws-foundation](02-aws-foundation/) | AWS global infrastructure, security, frameworks |
| 4 | [03-console-labs](03-console-labs/) | Hands-on labs via AWS Management Console |
| 5 | [04-aws-cli](04-aws-cli/) | Same labs using AWS CLI |
| 6 | [05-terraform](05-terraform/) | Same labs using Infrastructure as Code |
| 7 | [06-capstone-project](06-capstone-project/) | End-to-end projects combining all skills |

See [COURSE-ROADMAP.md](COURSE-ROADMAP.md) for the full phase-wise plan.

## Required Tools

| Tool | Purpose |
|------|---------|
| AWS Account | Free Tier eligible account for labs |
| Web browser | AWS Management Console |
| Git | Clone this repo and track your work |
| SSH client | Connect to EC2 instances (Git Bash on Windows works) |
| Text editor | VS Code or similar for Markdown and config files |
| AWS CLI v2 | Module 04 - install guide included |
| Terraform | Module 05 - install guide included |
| Docker | Module 03 (ECS lab) and capstone projects |

## Safety Warning - AWS Costs

> **You are responsible for every resource you create.** Labs use Free Tier or lowest-cost options where possible, but mistakes (forgotten instances, open RDS databases, load balancers left running) can generate charges.

Before starting:

1. Read [COST-AND-SAFETY-GUIDE.md](COST-AND-SAFETY-GUIDE.md)
2. Set up billing alerts in your AWS account
3. Complete the **cleanup section** at the end of every lab
4. Never commit real AWS access keys or secret keys to Git

## Recommended Lab Region

**Default region: `ap-southeast-1` (Singapore)**

You may use a different region if your instructor allows it. Keep one region for all labs to avoid confusion and extra cross-region costs. Update region settings in the Console, CLI profile, and Terraform provider consistently.

## Suggested Git Workflow

```bash
# Clone the course repo
git clone <your-repo-url>
cd aws-basic

# Create your own branch for notes and lab artifacts
git checkout -b student/<your-name>

# After each module, commit your notes (never commit credentials)
git add .
git commit -m "Complete module 03-console-labs/02-ec2-default-vpc"

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

**Instructor note:** Teach theory first, then lab. Console -> CLI -> Terraform reinforces the same services in three ways.
