# Cloud Fundamentals — Diagrams

Visual reference for Module 01. Copy these into slides or docs. All diagrams use [Mermaid](https://mermaid.js.org/) syntax.

---

## 1. Cloud Computing Flow (DevOps View)

How code reaches users in the cloud:

```mermaid
flowchart LR
    DEV[Developer] -->|git push| GIT[Git Repository]
    GIT --> CI[CI/CD Pipeline]
    CI --> BUILD[Build & Test]
    BUILD --> DEPLOY[Deploy to Cloud]
    DEPLOY --> COMPUTE[Compute — VM / Container Apps]
    COMPUTE --> USER[End Users]
```

---

## 2. Five Characteristics of Cloud (Summary)

```mermaid
mindmap
  root((Cloud Computing))
    On-Demand Self-Service
    Broad Network Access
    Resource Pooling
    Rapid Elasticity
    Measured Service
```

---

## 3. SaaS / PaaS / IaaS — Responsibility Stack

**Diagram 1 (required):** Who manages each layer.

```mermaid
flowchart TB
    subgraph Layers["Application Stack"]
        direction TB
        L1["Applications & Data"]
        L2["Runtime / Middleware"]
        L3["Operating System"]
        L4["Virtualization"]
        L5["Servers & Storage"]
        L6["Networking"]
    end

    subgraph IaaS["IaaS — You manage top 4 layers"]
        direction TB
        I_Y1["🟦 Applications & Data"]
        I_Y2["🟦 Runtime"]
        I_Y3["🟦 OS"]
        I_P1["⬜ Virtualization"]
        I_P2["⬜ Servers & Storage"]
        I_P3["⬜ Networking"]
    end

    subgraph PaaS["PaaS — You manage apps & data only"]
        direction TB
        P_Y1["🟦 Applications & Data"]
        P_P1["⬜ Runtime"]
        P_P2["⬜ OS"]
        P_P3["⬜ Virtualization"]
        P_P4["⬜ Servers & Storage"]
        P_P5["⬜ Networking"]
    end

    subgraph SaaS["SaaS — Provider manages all"]
        direction TB
        S_P1["⬜ Applications through Networking — all provider"]
    end
```

**Legend:** 🟦 = Customer manages | ⬜ = Provider manages

---

## 4. Deployment Models

```mermaid
flowchart TB
    subgraph Public["Public Cloud — Azure, AWS, GCP"]
        P1[Multi-tenant]
        P2[Pay-as-you-go]
        P3[Global scale]
    end

    subgraph Private["Private Cloud — Single organization"]
        PR1[Dedicated hardware]
        PR2[On-prem or hosted]
        PR3[Full control]
    end

    subgraph Hybrid["Hybrid Cloud"]
        H1[Public + Private connected]
        H2[VPN / ExpressRoute]
        H3[Gradual migration]
    end

    Public --- Hybrid
    Private --- Hybrid
```

---

## 5. On-Prem vs Cloud — Capacity Over Time

```mermaid
xychart-beta
    title "Capacity vs Demand"
    x-axis ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    y-axis "Capacity" 0 --> 100
    line "On-Prem (fixed)" [50, 50, 50, 50, 50, 50]
    line "Actual demand" [20, 30, 45, 90, 40, 25]
    line "Cloud (elastic)" [20, 30, 45, 90, 40, 25]
```

On-prem line stays flat (waste or shortage). Cloud line follows demand.

---

## 6. Cloud Pricing Models

```mermaid
flowchart LR
    subgraph Models["Azure Pricing Models"]
        OD[Pay-as-you-go<br/>Flexible, highest $/hr]
        RI[Reservations / Savings Plan<br/>Commitment, lower $/hr]
        SP[Spot VMs<br/>Cheapest, eviction risk]
        FT[Free Account<br/>Limited, for learning]
    end

    OD --> USE1[Labs & unknown load]
    RI --> USE2[Steady production]
    SP --> USE3[Batch / CI jobs]
    FT --> USE4[Training account]
```

---

## 7. What Makes Up an Azure Bill

```mermaid
pie title Typical DevOps Workload Cost Areas
    "Compute (VM/Container Apps)" : 40
    "Database (MySQL/SQL)" : 25
    "Storage (Disks/Blob)" : 15
    "Networking (transfer, LB)" : 15
    "Monitoring & other" : 5
```

> Percentages vary by architecture. Use Cost analysis for real data.

---

## 8. Migration Path (CAF — Preview)

```mermaid
flowchart LR
    A[On-Prem App] --> B{Strategy?}
    B -->|Rehost| C[Lift to Azure VM]
    B -->|Replatform| D[Move DB to MySQL Flexible Server]
    B -->|Refactor| E[Containers / microservices]
    B -->|Retire| F[Shut down]
    B -->|Retain| G[Stay on-prem]
```

Full migration guidance appears in Microsoft CAF (Module 02).

---

## How to Use These Diagrams

| Audience | Tip |
|----------|-----|
| **Self-study** | Render in VS Code with a Mermaid preview extension or on GitHub |
| **Instructor** | Copy one diagram per slide; explain before lab |
| **Students** | Redraw on whiteboard from memory — best interview prep |

---

## References to Verify

- [Mermaid Documentation](https://mermaid.js.org/intro/) — syntax and diagram types
- [Azure Architecture Center icons](https://learn.microsoft.com/azure/architecture/icons/) — official icons for your own diagrams

---

**Module complete.** Continue to [02-azure-foundation](../02-azure-foundation/README.md).
