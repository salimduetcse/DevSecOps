# Glossary

Alphabetical reference for **Azure Basic for DevOps Professionals**. Terms link to course modules where they are taught in depth.

---

## A

| Term | Definition | Learn more |
|------|------------|------------|
| **ACR (Azure Container Registry)** | Private Docker image registry integrated with Container Apps and other Azure compute. | [03-console-labs/08](../03-console-labs/08-container-apps/) |
| **Application Gateway** | Layer 7 HTTP/HTTPS load balancer/WAF; richer than Basic Load Balancer — avoid in beginner labs unless assigned. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |
| **Availability Zone (AZ)** | Isolated data center(s) within a Region; use multiple AZs for high availability. | [02-azure-foundation/02](../02-azure-foundation/02-region-az-edge-location.md) |
| **Azure CLI** | Command-line tool to manage Azure services; defaults toward `southeastasia` in this course. | [04-azure-cli](../04-azure-cli/) |
| **Azure Database for MySQL Flexible Server** | Managed MySQL PaaS; Azure operates OS and engine patching. | [03-console-labs/06](../03-console-labs/06-mysql/) |

---

## B

| Term | Definition | Learn more |
|------|------------|------------|
| **Backend (Terraform)** | Where Terraform stores state; local `terraform.tfstate` in labs. | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Blob (Azure Blob Storage)** | Object storage for files, backups, static assets. | [03-console-labs/05](../03-console-labs/05-blob-storage/) |
| **Blob Container** | Container for blobs inside a storage account; analogous to an S3 “folder/bucket space.” | [03-console-labs/05](../03-console-labs/05-blob-storage/) |

---

## C

| Term | Definition | Learn more |
|------|------------|------------|
| **CIDR** | IP range notation (e.g. `10.0.0.0/16`); defines VNet and subnet sizes. | [03-console-labs/03](../03-console-labs/03-custom-vnet-vm/) |
| **Cloud Computing** | On-demand IT resources over the internet with pay-as-you-go pricing. | [01-cloud-fundamentals/01](../01-cloud-fundamentals/01-what-is-cloud.md) |
| **Container Apps** | Managed container hosting (Kubernetes-based platform without managing clusters). | [03-console-labs/08](../03-console-labs/08-container-apps/) |
| **Cost Management** | Azure billing, budgets, and cost analysis tools. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |

---

## D

| Term | Definition | Learn more |
|------|------------|------------|
| **Data Source (Terraform)** | Reads existing Azure info without creating resources (`data "azurerm_image"`). | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Default VNet** | Auto-associated network when you create a quick VM without a custom network design. | [03-console-labs/02](../03-console-labs/02-vm-default-vnet/) |

---

## E

| Term | Definition | Learn more |
|------|------------|------------|
| **Edge Location / CDN POP** | CDN cache site for Azure Front Door or CDN; not for running VMs. | [02-azure-foundation/02](../02-azure-foundation/02-region-az-edge-location.md) |
| **Elasticity** | Ability to scale resources up or down based on demand. | [01-cloud-fundamentals/01](../01-cloud-fundamentals/01-what-is-cloud.md) |
| **Microsoft Entra ID** | Identity platform (formerly Azure AD) for users, groups, and app registrations. | [03-console-labs/01](../03-console-labs/01-entra-rbac-basics/) |

---

## F

| Term | Definition | Learn more |
|------|------------|------------|
| **Free Account / Free Trial** | Limited free Azure usage and credits for new accounts; has caps and time limits. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |

---

## H

| Term | Definition | Learn more |
|------|------------|------------|
| **Health Probe** | Load Balancer probe (e.g. HTTP `/` or TCP) to detect unhealthy instances. | [03-console-labs/07](../03-console-labs/07-load-balancer-vmss/) |
| **Hybrid Cloud** | Mix of on-premises and public cloud connected together. | [01-cloud-fundamentals/03](../01-cloud-fundamentals/03-public-private-hybrid-cloud.md) |

---

## I

| Term | Definition | Learn more |
|------|------------|------------|
| **IaaS** | Infrastructure as a Service — you manage OS and above (e.g. Azure VM). | [01-cloud-fundamentals/02](../01-cloud-fundamentals/02-saas-paas-iaas.md) |
| **IaC (Infrastructure as Code)** | Defining infrastructure in versioned files (Terraform). | [05-terraform/01](../05-terraform/01-terraform-theory.md) |
| **Image (Managed / Gallery)** | Template containing OS and configuration used to launch VMs or fill a scale set. | [03-console-labs/02](../03-console-labs/02-vm-default-vnet/) |

---

## K

| Term | Definition | Learn more |
|------|------------|------------|
| **Key Pair / SSH Key** | Public/private SSH key pair for Linux VM login (`.pem` / private key file). | [03-console-labs/02](../03-console-labs/02-vm-default-vnet/) |
| **Key Vault** | Azure service for secrets, keys, and certificates (awareness in this course). | [02-azure-foundation/06](../02-azure-foundation/06-basic-azure-security.md) |

---

## L

| Term | Definition | Learn more |
|------|------------|------------|
| **Load Balancer (Azure)** | Distributes traffic across VMs or scale set instances; Layer 4 for Standard/Basic LB. | [03-console-labs/07](../03-console-labs/07-load-balancer-vmss/) |

---

## M

| Term | Definition | Learn more |
|------|------------|------------|
| **Managed Disks** | Persistent block storage volumes attached to Azure VMs; zone-aware options. | [03-console-labs/04](../03-console-labs/04-managed-disks/) |
| **Managed Service** | Azure operates part of the stack (e.g. MySQL Flexible Server patches the engine). | [03-console-labs/06](../03-console-labs/06-mysql/) |
| **MFA (Multi-Factor Authentication)** | Second factor (app/token) required at login; enable on Entra users. | [00-course-setup/azure-subscription-safety](00-course-setup/azure-subscription-safety.md) |

---

## N

| Term | Definition | Learn more |
|------|------------|------------|
| **NAT Gateway** | Allows private subnet outbound internet; **expensive** — avoid in beginner labs. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |
| **NSG (Network Security Group)** | Stateful-style firewall rules for NIC or subnet; allow/deny inbound and outbound. | [03-console-labs/02](../03-console-labs/02-vm-default-vnet/) |

---

## O

| Term | Definition | Learn more |
|------|------------|------------|
| **On-Demand (pay-as-you-go)** | Pay per use with no commitment; default for labs. | [01-cloud-fundamentals/05](../01-cloud-fundamentals/05-cloud-pricing-basics.md) |
| **Output (Terraform)** | Exported value after apply (e.g. `public_ip`). | [05-terraform/05](../05-terraform/05-variable-output-tfvars.md) |
| **Owner (RBAC)** | Highest built-in role on a subscription/resource group; prefer Contributor for daily labs. | [03-console-labs/01](../03-console-labs/01-entra-rbac-basics/) |

---

## P

| Term | Definition | Learn more |
|------|------------|------------|
| **PaaS** | Platform as a Service — provider manages OS/runtime (e.g. App Service, MySQL Flexible Server). | [01-cloud-fundamentals/02](../01-cloud-fundamentals/02-saas-paas-iaas.md) |
| **Portal (Azure Portal)** | Web UI for Azure; first hands-on method in this course. | [03-console-labs](../03-console-labs/) |
| **Private Subnet** | Subnet without direct internet route; for app/DB tiers. | [03-console-labs/03](../03-console-labs/03-custom-vnet-vm/) |
| **Provider (Terraform)** | Plugin connecting Terraform to Azure API (`azurerm`). | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Public IP** | Static or dynamic public IPv4; charged if allocated unused. | [COST-AND-SAFETY-GUIDE](COST-AND-SAFETY-GUIDE.md) |
| **Public Subnet** | Subnet whose NICs can have public IPs and internet route. | [03-console-labs/03](../03-console-labs/03-custom-vnet-vm/) |

---

## R

| Term | Definition | Learn more |
|------|------------|------------|
| **RBAC (Role-Based Access Control)** | Azure authorization model: who can do what on which scope. | [03-console-labs/01](../03-console-labs/01-entra-rbac-basics/) |
| **Region** | Geographic Azure area containing datacenters / AZs (e.g. `southeastasia`). | [02-azure-foundation/02](../02-azure-foundation/02-region-az-edge-location.md) |
| **Reservations** | Commit 1 or 3 years for lower rates on compute/SQL and more. | [01-cloud-fundamentals/05](../01-cloud-fundamentals/05-cloud-pricing-basics.md) |
| **Resource (Terraform)** | Infrastructure object Terraform creates (`azurerm_linux_virtual_machine`, etc.). | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Resource Group** | Container for related Azure resources; delete RG to delete contents. | [00-course-setup/azure-subscription-safety](00-course-setup/azure-subscription-safety.md) |
| **Route Table** | Rules directing traffic from subnet to internet, NVA, or internal targets. | [03-console-labs/03](../03-console-labs/03-custom-vnet-vm/) |

---

## S

| Term | Definition | Learn more |
|------|------------|------------|
| **SaaS** | Software as a Service — ready-to-use apps (e.g. Gmail, GitHub, Microsoft 365). | [01-cloud-fundamentals/02](../01-cloud-fundamentals/02-saas-paas-iaas.md) |
| **Shared Responsibility Model** | Azure secures cloud; customer secures data/config in the cloud. | [02-azure-foundation/05](../02-azure-foundation/05-shared-responsibility-model.md) |
| **Snapshot (Managed Disk)** | Point-in-time backup of a managed disk. | [03-console-labs/04](../03-console-labs/04-managed-disks/) |
| **Spot VM** | Discounted VM that can be evicted; not used in beginner labs. | [01-cloud-fundamentals/05](../01-cloud-fundamentals/05-cloud-pricing-basics.md) |
| **State (Terraform)** | `terraform.tfstate` — maps code to real resource IDs; do not commit. | [05-terraform/03](../05-terraform/03-provider-backend-state.md) |
| **Storage Account** | Parent resource for Blob, File, Queue, Table; name must be globally unique. | [03-console-labs/05](../03-console-labs/05-blob-storage/) |
| **Subnet** | Segment of VNet IP space in one region (zone-aware placement on NICs/VMs). | [03-console-labs/03](../03-console-labs/03-custom-vnet-vm/) |
| **Subscription Owner** | Highest control over subscription billing and RBAC; emergency / admin use. | [03-console-labs/01](../03-console-labs/01-entra-rbac-basics/) |

---

## T

| Term | Definition | Learn more |
|------|------------|------------|
| **Terraform** | IaC tool using HCL; `init/plan/apply/destroy` workflow. | [05-terraform](../05-terraform/) |

---

## V

| Term | Definition | Learn more |
|------|------------|------------|
| **Variable (Terraform)** | Input parameter for modules/labs (`var.location`). | [05-terraform/05](../05-terraform/05-variable-output-tfvars.md) |
| **Versioning (Blob)** | Keeps multiple versions of blobs when overwritten or deleted. | [03-console-labs/05](../03-console-labs/05-blob-storage/) |
| **VM (Virtual Machine)** | Virtual servers in Azure; choose image, size, and NSG. | [03-console-labs/02](../03-console-labs/02-vm-default-vnet/) |
| **VM Size** | VM SKU (e.g. `Standard_B1s`); affects CPU, RAM, and cost. | [03-console-labs/02](../03-console-labs/02-vm-default-vnet/) |
| **VMSS (Virtual Machine Scale Sets)** | Automatically adds or removes VM instances based on demand or schedule. | [03-console-labs/07](../03-console-labs/07-load-balancer-vmss/) |
| **VNet (Virtual Network)** | Isolated virtual network in Azure; you define CIDR, subnets, routing. | [03-console-labs/03](../03-console-labs/03-custom-vnet-vm/) |

---

## W

| Term | Definition | Learn more |
|------|------------|------------|
| **Well-Architected Framework** | Azure best practices across five pillars (reliability, security, cost, ops, performance). | [02-azure-foundation/03](../02-azure-foundation/03-azure-well-architected-framework.md) |

---

## Course Acronyms Quick List

```
ACR  → Azure Container Registry
AZ   → Availability Zone
CAF  → Cloud Adoption Framework (Microsoft)
LB   → Load Balancer
MFA  → Multi-Factor Authentication
NSG  → Network Security Group
RBAC → Role-Based Access Control
RG   → Resource Group
VM   → Virtual Machine
VMSS → Virtual Machine Scale Set
VNet → Virtual Network
```

---

## References to Verify

- [Azure Glossary](https://learn.microsoft.com/azure/cloud-adoption-framework/glossary/)
- [Terraform Glossary](https://developer.hashicorp.com/terraform/docs/glossary)
