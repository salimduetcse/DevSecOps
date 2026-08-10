# AWS Foundation — Diagrams

Visual reference for Module 02. All diagrams use [Mermaid](https://mermaid.js.org/) syntax and render on GitHub.

---

## 1. AWS Global Infrastructure Overview

```mermaid
flowchart TB
    GLOBAL[AWS Global Infrastructure]

    GLOBAL --> REGIONS[Regions<br/>30+ worldwide]
    GLOBAL --> EDGE[Edge Locations<br/>400+ for CDN]

    REGIONS --> AZ[Availability Zones<br/>3+ per Region typically]

    AZ --> DC[Discrete Data Centers<br/>Independent power & networking]
```

---

## 2. Region and Availability Zones (Required)

**Diagram 2:** How components span AZs in one Region.

```mermaid
flowchart TB
    subgraph Region["Region: ap-southeast-1"]
        direction LR

        subgraph AZa["ap-southeast-1a"]
            EC2_1[EC2 Web 1]
        end

        subgraph AZb["ap-southeast-1b"]
            EC2_2[EC2 Web 2]
        end

        subgraph AZc["ap-southeast-1c"]
            EC2_3[EC2 Web 3]
        end
    end

    USERS[Internet Users] --> ALB[Application Load Balancer<br/>spans multiple AZs]
    ALB --> EC2_1
    ALB --> EC2_2
    ALB --> EC2_3

    EC2_1 & EC2_2 --> RDS[(Amazon RDS Multi-AZ<br/>Primary in 1a, Standby in 1b)]
```

**Key takeaway:** Load balancer and compute spread across AZs → survives single data center failure.

---

## 3. Region vs Edge Location

```mermaid
flowchart LR
  subgraph Origin["Origin — Region ap-southeast-1"]
    S3[(S3 Bucket)]
    EC2[EC2 API]
  end

  subgraph Edge["Edge Locations — Global"]
    E1[Tokyo]
    E2[Singapore]
    E3[Sydney]
  end

  USER_JP[User in Japan] --> E1
  E1 -->|cache miss| S3
  E1 -->|cache hit| USER_JP

  S3 --- EC2
```

Edge locations cache content; Regions run your workloads.

---

## 4. Shared Responsibility Model (Required)

**Diagram 3:** Security OF vs IN the cloud.

```mermaid
flowchart TB
    subgraph AWS["AWS — Security OF the Cloud"]
        direction TB
        A1[Physical data centers]
        A2[Hardware & global network]
        A3[Virtualization layer]
        A4[Managed service operations]
    end

    subgraph CUSTOMER["Customer — Security IN the Cloud"]
        direction TB
        C1[IAM & access management]
        C2[VPC, security groups, NACLs]
        C3[Guest OS & patching — EC2]
        C4[Application code & data]
        C5[Encryption configuration]
        C6[S3 bucket policies & public access]
    end

    AWS --- BOUNDARY["Responsibility boundary<br/>varies by service"]
    BOUNDARY --- CUSTOMER
```

### By Service (Quick View)

```mermaid
flowchart LR
    subgraph EC2["EC2"]
        E_AWS[AWS: hypervisor, physical]
        E_YOU[You: OS, SG, app, data]
    end

    subgraph S3["S3"]
        S_AWS[AWS: storage infra]
        S_YOU[You: policies, access, data]
    end

    subgraph RDS["RDS"]
        R_AWS[AWS: engine patch, hardware]
        R_YOU[You: SG, users, schema, network]
    end

    subgraph IAM["IAM"]
        I_AWS[AWS: IAM service]
        I_YOU[You: users, policies, MFA, keys]
    end
```

---

## 5. Basic AWS Account and Security Flow (Required)

**Diagram 4:** How identity flows to services and controls.

```mermaid
sequenceDiagram
    actor User as DevOps Engineer
    participant MFA as MFA Device
    participant Console as AWS Console
    participant IAM as AWS IAM
    participant API as AWS API
    participant EC2 as Amazon EC2
    participant CT as CloudTrail

    User->>Console: Login with IAM user
    Console->>MFA: Verify second factor
    MFA-->>Console: Approved
    User->>Console: Launch EC2 instance
    Console->>IAM: Evaluate permissions
    IAM-->>API: Allow ec2:RunInstances
    API->>EC2: Create instance
    API->>CT: Log API call
    EC2-->>User: Instance running
```

### CI/CD Path (Role-Based)

```mermaid
flowchart LR
    GH[GitHub Actions] -->|OIDC token| STS[AWS STS]
    STS -->|Temporary credentials| ROLE[IAM Role]
    ROLE --> TF[Terraform Apply]
    TF --> AWS[AWS Resources]
```

Preferred over long-lived access keys in pipelines.

---

## 6. Well-Architected — Six Pillars

```mermaid
flowchart TB
    WA((Well-Architected))

    WA --- OE[Operational Excellence]
    WA --- SEC[Security]
    WA --- REL[Reliability]
    WA --- PERF[Performance Efficiency]
    WA --- COST[Cost Optimization]
    WA --- SUS[Sustainability]

    OE --- OE1[Automate / Monitor / Improve]
    SEC --- SEC1[IAM / Encrypt / Detect]
    REL --- REL1[Multi-AZ / Backup / Recover]
    PERF --- PERF1[Right-size / Serverless]
    COST --- COST1[Tag / Budget / Optimize]
    SUS --- SUS1[Utilize / Reduce waste]
```

---

## 7. AWS CAF — Six Perspectives

```mermaid
flowchart TB
    CAF((AWS CAF))

    CAF --- B[Business<br/>Value & strategy]
    CAF --- P[People<br/>Skills & culture]
    CAF --- G[Governance<br/>Policies & compliance]
    CAF --- PL[Platform<br/>Shared infrastructure]
    CAF --- S[Security<br/>Protect workloads]
    CAF --- O[Operations<br/>Run production]

    PL --- PL1[VPC / Landing zone / IaC]
    S --- S1[IAM / Detective controls]
    O --- O1[Monitoring / Incident response]
```

---

## 8. VPC Security Layers (Preview for Module 03)

```mermaid
flowchart TB
    INTERNET[Internet] --> IGW[Internet Gateway]
    IGW --> NACL_PUB[NACL — Public Subnet]
    NACL_PUB --> SG_ALB[Security Group — ALB]
    SG_ALB --> ALB[ALB]

    ALB --> SG_APP[Security Group — App EC2]
    SG_APP --> EC2[EC2 Instances]

    EC2 --> SG_DB[Security Group — RDS]
    SG_DB --> RDS[(RDS in Private Subnet)]
```

Defense in depth: NACL + security groups + private subnets for data tier.

---

## Cross-Module Diagram Index

| Diagram | Also In |
|---------|---------|
| SaaS / PaaS / IaaS responsibility | [01-cloud-fundamentals/diagrams.md](../01-cloud-fundamentals/diagrams.md) |
| Region / AZ | This file + [02-region-az-edge-location.md](02-region-az-edge-location.md) |
| Shared responsibility | This file + [05-shared-responsibility-model.md](05-shared-responsibility-model.md) |
| Account security flow | This file + [06-basic-aws-security.md](06-basic-aws-security.md) |

---

## How to Practice

1. Open any diagram in VS Code with Mermaid preview
2. Cover the labels and redraw from memory on paper
3. Explain each diagram to a classmate in under 2 minutes
4. Link diagram concepts to an upcoming lab (e.g., diagram 2 → ALB lab)

---

## References to Verify

- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/) — build professional diagrams
- [Mermaid Live Editor](https://mermaid.live/) — test diagram syntax
- [AWS Well-Architected Labs](https://www.wellarchitectedlabs.com/) — hands-on pillar exercises (advanced)

---

**Modules 01 and 02 complete.** Start hands-on work: [03-console-labs/01-iam-basics](../03-console-labs/01-iam-basics/README.md)
