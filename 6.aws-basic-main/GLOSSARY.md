# Glossary

Alphabetical reference for **AWS Basic for DevOps Professionals**. Terms link to course modules where they are taught in depth.

---

## A

| Term | Definition | Learn more |
|------|------------|------------|
| **ALB (Application Load Balancer)** | Layer 7 HTTP/HTTPS load balancer that distributes traffic across targets and runs health checks. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |
| **AMI (Amazon Machine Image)** | Template containing OS and configuration used to launch EC2 instances. | [03-console-labs/02](../03-console-labs/02-ec2-default-vpc/) |
| **ASG (Auto Scaling Group)** | Automatically adds or removes EC2 instances based on demand or schedule. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |
| **Availability Zone (AZ)** | Isolated data center(s) within a Region; use multiple AZs for high availability. | [02-aws-foundation/02](../02-aws-foundation/02-region-az-edge-location.md) |
| **AWS CLI** | Command-line tool to manage AWS services; profile `aws-basic-lab` in this course. | [04-aws-cli](../04-aws-cli/) |

---

## B

| Term | Definition | Learn more |
|------|------------|------------|
| **Backend (Terraform)** | Where Terraform stores state; local `terraform.tfstate` in labs. | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Block Public Access (S3)** | Account/bucket setting preventing accidental public S3 exposure. | [03-console-labs/05](../03-console-labs/05-s3/) |
| **Bucket (S3)** | Container for objects; name must be globally unique. | [03-console-labs/05](../03-console-labs/05-s3/) |

---

## C

| Term | Definition | Learn more |
|------|------------|------------|
| **CIDR** | IP range notation (e.g. `10.0.0.0/16`); defines VPC and subnet sizes. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |
| **Cloud Computing** | On-demand IT resources over the internet with pay-as-you-go pricing. | [01-cloud-fundamentals/01](../01-cloud-fundamentals/01-what-is-cloud.md) |
| **Console (AWS Management Console)** | Web UI for AWS; first hands-on method in this course. | [03-console-labs](../03-console-labs/) |

---

## D

| Term | Definition | Learn more |
|------|------------|------------|
| **Data Source (Terraform)** | Reads existing AWS info without creating resources (`data "aws_ami"`). | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Default VPC** | Auto-created VPC in each Region for quick starts. | [03-console-labs/02](../03-console-labs/02-ec2-default-vpc/) |
| **Desired Capacity (ASG)** | Target number of instances Auto Scaling maintains. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |

---

## E

| Term | Definition | Learn more |
|------|------------|------------|
| **EBS (Elastic Block Store)** | Persistent block storage volumes attached to EC2; AZ-bound. | [03-console-labs/04](../03-console-labs/04-ebs/) |
| **EC2 (Elastic Compute Cloud)** | Virtual servers in AWS; choose AMI, instance type, and security groups. | [03-console-labs/02](../03-console-labs/02-ec2-default-vpc/) |
| **ECR (Elastic Container Registry)** | Private Docker image registry integrated with ECS. | [03-console-labs/08](../03-console-labs/08-ecs/) |
| **ECS (Elastic Container Service)** | AWS container orchestration; runs tasks and services on Fargate or EC2. | [03-console-labs/08](../03-console-labs/08-ecs/) |
| **Edge Location** | CDN cache site for CloudFront; not for running EC2. | [02-aws-foundation/02](../02-aws-foundation/02-region-az-edge-location.md) |
| **Elastic IP** | Static public IPv4; charged if allocated but not attached to running instance. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |
| **Elasticity** | Ability to scale resources up or down based on demand. | [01-cloud-fundamentals/01](../01-cloud-fundamentals/01-what-is-cloud.md) |

---

## F

| Term | Definition | Learn more |
|------|------------|------------|
| **Fargate** | Serverless compute engine for ECS — no EC2 instances to manage. | [03-console-labs/08](../03-console-labs/08-ecs/) |
| **Free Tier** | Limited free AWS usage for new accounts; has caps and time limits. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |

---

## H

| Term | Definition | Learn more |
|------|------------|------------|
| **Health Check** | ALB/target group probe (e.g. HTTP `/`) to detect unhealthy instances. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |
| **Hybrid Cloud** | Mix of on-premises and public cloud connected together. | [01-cloud-fundamentals/03](../01-cloud-fundamentals/03-public-private-hybrid-cloud.md) |

---

## I

| Term | Definition | Learn more |
|------|------------|------------|
| **IaaS** | Infrastructure as a Service — you manage OS and above (e.g. EC2). | [01-cloud-fundamentals/02](../01-cloud-fundamentals/02-saas-paas-iaas.md) |
| **IAM (Identity and Access Management)** | Users, groups, roles, and policies controlling AWS access. | [03-console-labs/01](../03-console-labs/01-iam-basics/) |
| **IaC (Infrastructure as Code)** | Defining infrastructure in versioned files (Terraform). | [05-terraform/01](../05-terraform/01-terraform-theory.md) |
| **IGW (Internet Gateway)** | VPC component allowing public internet access for public subnets. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |
| **Instance Type** | EC2 size/family (e.g. `t3.micro`); affects CPU, RAM, and cost. | [03-console-labs/02](../03-console-labs/02-ec2-default-vpc/) |

---

## K

| Term | Definition | Learn more |
|------|------------|------------|
| **Key Pair** | Public/private SSH key pair for Linux EC2 login (`.pem` file). | [03-console-labs/02](../03-console-labs/02-ec2-default-vpc/) |

---

## L

| Term | Definition | Learn more |
|------|------------|------------|
| **Launch Template** | EC2 configuration template used by Auto Scaling to launch identical instances. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |
| **Listener (ALB)** | ALB rule accepting traffic on a port (e.g. HTTP 80) and forwarding to target group. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |

---

## M

| Term | Definition | Learn more |
|------|------------|------------|
| **MFA (Multi-Factor Authentication)** | Second factor (app/token) required at login; enable on root and IAM users. | [00-course-setup/aws-account-safety](00-course-setup/aws-account-safety.md) |
| **Managed Service** | AWS operates part of the stack (e.g. RDS patches database engine). | [03-console-labs/06](../03-console-labs/06-rds/) |

---

## N

| Term | Definition | Learn more |
|------|------------|------------|
| **NACL (Network Access Control List)** | Stateless subnet-level firewall; optional defense in depth with security groups. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |
| **NAT Gateway** | Allows private subnet outbound internet; **expensive** — avoid in beginner labs. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |

---

## O

| Term | Definition | Learn more |
|------|------------|------------|
| **Object (S3)** | File stored in a bucket with a key (path). | [03-console-labs/05](../03-console-labs/05-s3/) |
| **On-Demand (pricing)** | Pay per use with no commitment; default for labs. | [01-cloud-fundamentals/05](../01-cloud-fundamentals/05-cloud-pricing-basics.md) |
| **Output (Terraform)** | Exported value after apply (e.g. `public_ip`). | [05-terraform/05](../05-terraform/05-variable-output-tfvars.md) |

---

## P

| Term | Definition | Learn more |
|------|------------|------------|
| **PaaS** | Platform as a Service — provider manages OS/runtime (e.g. RDS, Beanstalk). | [01-cloud-fundamentals/02](../01-cloud-fundamentals/02-saas-paas-iaas.md) |
| **Private Subnet** | Subnet without direct route to Internet Gateway; for app/DB tiers. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |
| **Provider (Terraform)** | Plugin connecting Terraform to AWS API. | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Public Subnet** | Subnet with route `0.0.0.0/0` → IGW; instances can get public IPs. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |

---

## R

| Term | Definition | Learn more |
|------|------------|------------|
| **RDS (Relational Database Service)** | Managed relational databases (MySQL, PostgreSQL, etc.). | [03-console-labs/06](../03-console-labs/06-rds/) |
| **Region** | Geographic AWS area containing multiple AZs (e.g. `ap-southeast-1`). | [02-aws-foundation/02](../02-aws-foundation/02-region-az-edge-location.md) |
| **Resource (Terraform)** | Infrastructure object Terraform creates (`aws_instance`, etc.). | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Root User** | AWS account owner with full access; emergency use only. | [03-console-labs/01](../03-console-labs/01-iam-basics/) |
| **Route Table** | Rules directing traffic from subnet to IGW, NAT, or internal targets. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |

---

## S

| Term | Definition | Learn more |
|------|------------|------------|
| **S3 (Simple Storage Service)** | Object storage for files, backups, static assets. | [03-console-labs/05](../03-console-labs/05-s3/) |
| **SaaS** | Software as a Service — ready-to-use apps (e.g. Gmail, GitHub). | [01-cloud-fundamentals/02](../01-cloud-fundamentals/02-saas-paas-iaas.md) |
| **Security Group** | Stateful virtual firewall for EC2/RDS ENIs; allow rules only. | [03-console-labs/02](../03-console-labs/02-ec2-default-vpc/) |
| **Service (ECS)** | Maintains desired number of running tasks; can attach to ALB. | [03-console-labs/08](../03-console-labs/08-ecs/) |
| **Shared Responsibility Model** | AWS secures cloud; customer secures data/config in the cloud. | [02-aws-foundation/05](../02-aws-foundation/05-shared-responsibility-model.md) |
| **Snapshot (EBS/RDS)** | Point-in-time backup of storage or database. | [03-console-labs/04](../03-console-labs/04-ebs/) |
| **Spot Instance** | Discounted EC2 that can be interrupted; not used in beginner labs. | [01-cloud-fundamentals/05](../01-cloud-fundamentals/05-cloud-pricing-basics.md) |
| **State (Terraform)** | `terraform.tfstate` — maps code to real resource IDs; do not commit. | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Subnet** | Segment of VPC IP space in one AZ. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |

---

## T

| Term | Definition | Learn more |
|------|------------|------------|
| **Target Group** | Collection of instances or IPs ALB forwards traffic to. | [03-console-labs/07](../03-console-labs/07-load-balancer-auto-scaling/) |
| **Task (ECS)** | Running containers from a task definition. | [03-console-labs/08](../03-console-labs/08-ecs/) |
| **Task Definition (ECS)** | Blueprint for container image, CPU, memory, and ports. | [03-console-labs/08](../03-console-labs/08-ecs/) |
| **Terraform** | IaC tool using HCL; `init/plan/apply/destroy` workflow. | [05-terraform](../05-terraform/) |

---

## V

| Term | Definition | Learn more |
|------|------------|------------|
| **Variable (Terraform)** | Input parameter for modules/labs (`var.aws_region`). | [05-terraform/05](../05-terraform/05-variable-output-tfvars.md) |
| **Versioning (S3)** | Keeps multiple versions of objects when overwritten or deleted. | [03-console-labs/05](../03-console-labs/05-s3/) |
| **VPC (Virtual Private Cloud)** | Isolated virtual network in AWS; you define CIDR, subnets, routing. | [03-console-labs/03](../03-console-labs/03-custom-vpc-ec2/) |

---

## W

| Term | Definition | Learn more |
|------|------------|------------|
| **Well-Architected Framework** | AWS best practices across six pillars (security, reliability, cost, etc.). | [02-aws-foundation/03](../02-aws-foundation/03-aws-well-architected-framework.md) |

---

## Course Acronyms Quick List

```
ALB  → Application Load Balancer
AMI  → Amazon Machine Image
ASG  → Auto Scaling Group
AZ   → Availability Zone
EBS  → Elastic Block Store
EC2  → Elastic Compute Cloud
ECR  → Elastic Container Registry
ECS  → Elastic Container Service
IAM  → Identity and Access Management
IGW  → Internet Gateway
NACL → Network Access Control List
RDS  → Relational Database Service
S3   → Simple Storage Service
VPC  → Virtual Private Cloud
```

---

## References to Verify

- [AWS Official Glossary](https://docs.aws.amazon.com/general/latest/gr/glos-chap.html)
- [Terraform Glossary](https://developer.hashicorp.com/terraform/docs/glossary)
