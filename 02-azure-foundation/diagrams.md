# Azure Foundation — Diagrams

Visual reference for Module 02. All diagrams use [Mermaid](https://mermaid.js.org/) syntax and render on GitHub.

---

## 1. Azure Global Infrastructure Overview

```mermaid
flowchart TB
    GLOBAL[Azure Global Infrastructure]

    GLOBAL --> REGIONS[Regions<br/>60+ worldwide]
    GLOBAL --> EDGE[Edge / CDN POPs<br/>Global for CDN / Front Door]

    REGIONS --> AZ[Availability Zones<br/>Typically 3 per enabled Region]

    AZ --> DC[Discrete Datacenters<br/>Independent power & networking]
```

---

## 2. Region and Availability Zones (Required)

**Diagram 2:** How components span AZs in one Region.

```mermaid
flowchart TB
    subgraph Region["Region: southeastasia"]
        direction LR

        subgraph AZa["Zone 1"]
            VM_1[VM Web 1]
        end

        subgraph AZb["Zone 2"]
            VM_2[VM Web 2]
        end

        subgraph AZc["Zone 3"]
            VM_3[VM Web 3]
        end
    end

    USERS[Internet Users] --> LB[Azure Load Balancer<br/>spans multiple AZs]
    LB --> VM_1
    LB --> VM_2
    LB --> VM_3

    VM_1 & VM_2 --> MYSQL[(MySQL Flexible Server HA<br/>Zone-redundant when configured)]
```

**Key takeaway:** Load balancer and compute spread across AZs → survives single datacenter failure.

---

## 3. Region vs Edge Location

```mermaid
flowchart LR
  subgraph Origin["Origin — Region southeastasia"]
    BLOB[(Blob Storage)]
    VM[VM API]
  end

  subgraph Edge["Edge / CDN POPs — Global"]
    E1[Tokyo]
    E2[Singapore]
    E3[Sydney]
  end

  USER_JP[User in Japan] --> E1
  E1 -->|cache miss| BLOB
  E1 -->|cache hit| USER_JP

  BLOB --- VM
```

Edge locations cache content; Regions run your workloads.

---

## 4. Shared Responsibility Model (Required)

**Diagram 3:** Security OF vs IN the cloud.

```mermaid
flowchart TB
    subgraph MS["Microsoft — Security OF the Cloud"]
        direction TB
        A1[Physical data centers]
        A2[Hardware & global network]
        A3[Virtualization layer]
        A4[Managed service operations]
    end

    subgraph CUSTOMER["Customer — Security IN the Cloud"]
        direction TB
        C1[Entra ID & RBAC]
        C2[VNet, NSGs]
        C3[Guest OS & patching — VM]
        C4[Application code & data]
        C5[Encryption configuration]
        C6[Blob public access & policies]
    end

    MS --- BOUNDARY["Responsibility boundary<br/>varies by service"]
    BOUNDARY --- CUSTOMER
```

### By Service (Quick View)

```mermaid
flowchart LR
    subgraph VM["Virtual Machine"]
        E_MS[Microsoft: hypervisor, physical]
        E_YOU[You: OS, NSG, app, data]
    end

    subgraph BLOB["Blob"]
        S_MS[Microsoft: storage infra]
        S_YOU[You: access, policies, data]
    end

    subgraph MYSQL["MySQL Flexible"]
        R_MS[Microsoft: engine patch, hardware]
        R_YOU[You: network, users, schema]
    end

    subgraph ID["Entra + RBAC"]
        I_MS[Microsoft: identity platform]
        I_YOU[You: users, roles, MFA, secrets]
    end
```

---

## 5. Basic Azure Account and Security Flow (Required)

**Diagram 4:** How identity flows to services and controls.

```mermaid
sequenceDiagram
    actor User as DevOps Engineer
    participant MFA as MFA Device
    participant Portal as Azure Portal
    participant RBAC as Entra + RBAC
    participant ARM as Azure Resource Manager
    participant VM as Azure VM
    participant AL as Activity Log

    User->>Portal: Login with Entra user
    Portal->>MFA: Verify second factor
    MFA-->>Portal: Approved
    User->>Portal: Create VM
    Portal->>RBAC: Evaluate role assignments
    RBAC-->>ARM: Allow Microsoft.Compute/virtualMachines/write
    ARM->>VM: Create instance
    ARM->>AL: Log operation
    VM-->>User: VM running
```

### CI/CD Path (Identity-Based)

```mermaid
flowchart LR
    GH[GitHub Actions] -->|OIDC / federation| ENTRA[Entra App]
    ENTRA -->|Temporary token| ROLE[RBAC on RG]
    ROLE --> TF[Terraform Apply]
    TF --> AZ[Azure Resources]
```

Preferred over long-lived client secrets in pipelines.

---

## 6. Well-Architected — Five Pillars

```mermaid
flowchart TB
    WA((Well-Architected))

    WA --- REL[Reliability]
    WA --- SEC[Security]
    WA --- COST[Cost Optimization]
    WA --- OE[Operational Excellence]
    WA --- PERF[Performance Efficiency]

    REL --- REL1[Multi-AZ / Backup / Recover]
    SEC --- SEC1[Entra / Encrypt / Detect]
    COST --- COST1[Tag / Budget / Optimize]
    OE --- OE1[Automate / Monitor / Improve]
    PERF --- PERF1[Right-size / Serverless]
```

---

## 7. Microsoft CAF — Methodologies

```mermaid
flowchart TB
    CAF((Microsoft CAF))

    CAF --- S[Strategy<br/>Value & business case]
    CAF --- P[Plan<br/>Skills & roadmap]
    CAF --- R[Ready<br/>Landing zone]
    CAF --- A[Adopt<br/>Migrate & innovate]
    CAF --- G[Govern<br/>Policies & compliance]
    CAF --- M[Manage<br/>Run production]

    R --- R1[VNet / Landing zone / IaC]
    G --- G1[Tags / Policy / Budgets]
    M --- M1[Monitoring / Incident response]
```

---

## 8. VNet Security Layers (Preview for Module 03)

```mermaid
flowchart TB
    INTERNET[Internet] --> PIP[Public IP / Front end]
    PIP --> NSG_PUB[NSG — Public Subnet]
    NSG_PUB --> LB[Load Balancer]
    LB --> NSG_APP[NSG — App VM]
    NSG_APP --> VM[Virtual Machines]
    VM --> NSG_DB[NSG / Firewall — MySQL]
    NSG_DB --> MYSQL[(MySQL in Private Subnet)]
```

Defense in depth: NSGs + private subnets for data tier.

---

## Cross-Module Diagram Index

| Diagram | Also In |
|---------|---------|
| SaaS / PaaS / IaaS responsibility | [01-cloud-fundamentals/diagrams.md](../01-cloud-fundamentals/diagrams.md) |
| Region / AZ | This file + [02-region-az-edge-location.md](02-region-az-edge-location.md) |
| Shared responsibility | This file + [05-shared-responsibility-model.md](05-shared-responsibility-model.md) |
| Account security flow | This file + [06-basic-azure-security.md](06-basic-azure-security.md) |

---

## How to Practice

1. Open any diagram in VS Code with Mermaid preview
2. Cover the labels and redraw from memory on paper
3. Explain each diagram to a classmate in under 2 minutes
4. Link diagram concepts to an upcoming lab (e.g., diagram 2 → Load Balancer lab)

---

## References to Verify

- [Azure Architecture icons](https://learn.microsoft.com/azure/architecture/icons/) — build professional diagrams
- [Mermaid Live Editor](https://mermaid.live/) — test diagram syntax
- [Azure Well-Architected](https://learn.microsoft.com/azure/well-architected/) — pillar exercises and guidance

---

**Modules 01 and 02 complete.** Start hands-on work: [03-console-labs/01-entra-rbac-basics](../03-console-labs/01-entra-rbac-basics/README.md)
