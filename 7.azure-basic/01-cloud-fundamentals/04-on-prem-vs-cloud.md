# On-Premises vs Cloud

## Learning Goal

Compare traditional on-premises IT with cloud computing so you can explain trade-offs in design meetings and interviews.

---

## Definitions

| Term | Meaning |
|------|---------|
| **On-premises (on-prem)** | IT infrastructure you own or lease, located in your office or a rented data center that you manage |
| **Cloud** | IT infrastructure owned by a provider (e.g., Azure), accessed over the internet, billed on usage |

---

## Side-by-Side Comparison

| Factor | On-Premises | Cloud (Azure) |
|--------|-------------|---------------|
| **Upfront cost** | High — buy servers, switches, racks | Low — no hardware purchase |
| **Ongoing cost** | Power, cooling, staff, hardware refresh | Pay-as-you-go monthly bill |
| **Provisioning speed** | Weeks to months | Minutes to hours |
| **Scaling** | Buy more hardware (slow, expensive) | VM Scale Sets, elastic resources |
| **Maintenance** | Your team patches OS, replaces disks, fixes hardware | Azure maintains physical layer; you manage OS and above (for IaaS) |
| **Geographic reach** | Build data centers in each region | Use existing Azure Regions worldwide |
| **Disaster recovery** | Expensive duplicate data centers | Replicate to another Region relatively easily |
| **Capital vs operational** | CapEx heavy | OpEx (operational expenditure) model |

---

## Cost Mental Model

### On-Premises

You pay whether you use the server or not:

```mermaid
flowchart LR
    A[Buy 10 servers] --> B[Traffic is low]
    B --> C[9 servers sit idle]
    C --> D[Still paying full cost]
```

### Cloud

You pay for what you consume (when designed well):

```mermaid
flowchart LR
    A[Launch 2 VMs] --> B[Traffic spikes]
    B --> C[Scale to 10 VMs]
    C --> D[Traffic drops]
    D --> E[Scale back to 2]
    E --> F[Bill matches usage]
```

> **Important:** Cloud is not automatically cheaper. Forgotten resources, oversized VMs, and always-on dev environments can make cloud *more* expensive than on-prem.

---

## When On-Premises Still Makes Sense

| Scenario | Why |
|----------|-----|
| Strict data sovereignty laws | Data must physically stay in a specific facility you control |
| Very predictable, stable workload | 24/7 constant load on owned hardware may cost less over 5+ years |
| Existing sunk investment | Data center already built; migration cost is high |
| Ultra-low-latency on local network | Microsecond-sensitive systems tied to local hardware |
| Air-gapped environments | No internet connection allowed (military, some government) |

---

## When Cloud Makes Sense

| Scenario | Why |
|----------|-----|
| Startups and new products | No upfront hardware; fast time to market |
| Variable or unknown traffic | Scale on demand |
| Global users | Deploy in multiple Regions |
| DevOps automation | APIs, Terraform, CI/CD integration |
| Short-lived environments | Staging/test environments exist only during business hours |
| Managed services | Let Azure run databases (MySQL Flexible Server / Azure SQL) instead of patching MySQL yourself |

---

## The "Lift and Shift" vs "Cloud-Native" Spectrum

When companies move from on-prem to cloud, they usually follow one of these paths:

| Approach | What Happens | DevOps Angle |
|----------|--------------|--------------|
| **Lift and shift (rehost)** | Move the same VM/app to Azure VM with minimal changes | Fast migration; may not optimize cost or scaling |
| **Replatform** | Small changes — e.g., move DB to Azure Database for MySQL | Better managed services, moderate effort |
| **Refactor / cloud-native** | Redesign for microservices, containers, serverless | Best elasticity; highest engineering effort |
| **Retire** | Shut down unused on-prem apps | Cost savings |
| **Retain** | Keep some apps on-prem | Hybrid model |

As a DevOps engineer, you will often start with **lift and shift** for learning, then improve toward **cloud-native** patterns.

---

## Real-World DevOps Scenarios

### Scenario 1: Nightly Batch Job

**On-prem:** Server runs 24/7 for a 2-hour nightly job — wasted electricity and capacity.

**Cloud:** Azure Logic Apps / Functions or a scheduled VM start at 2 AM, job finishes, resource stops. Pay for 2 hours.

### Scenario 2: Black Friday Traffic

**On-prem:** Company bought capacity for average traffic. Black Friday crashes the site OR they over-bought hardware that sits idle 364 days.

**Cloud:** VM Scale Set adds instances behind a Load Balancer for the sale weekend, scales down Monday.

### Scenario 3: Developer Test Environments

**On-prem:** IT provisions 5 VMs that developers "forget" to return.

**Cloud:** Terraform creates `dev-env-monday`, destroys `dev-env-friday` on a schedule. Tagged resources make cost visible. Resource group delete is the nuclear cleanup.

---

## Common Confusion

| Confusion | Clarification |
|-----------|---------------|
| "Cloud replaces all data centers" | Many enterprises use hybrid for years or permanently |
| "On-prem is always more secure" | Security depends on design and operations, not location alone |
| "Moving to cloud eliminates hardware teams" | Roles shift to cloud engineering, FinOps, and security — they do not disappear |
| "One migration project finishes cloud adoption" | Cloud adoption is ongoing optimization, not a single event |
| "Cloud means no capacity planning" | You still plan — but you adjust faster and pay for mistakes in the bill |

---

## Small Example (Conceptual)

| Workload | Better Fit | Reason |
|----------|------------|--------|
| Company email (standard) | SaaS (Microsoft 365) | Not core business; provider specializes |
| Custom payment API | Cloud (Container Apps / VM) | Needs scaling, CI/CD, global reach |
| 15-year-old mainframe billing | Retain on-prem (for now) | Rewrite cost is too high short-term |
| Student Azure lab | Cloud | Learn without buying hardware |

---

## Interview-Style Questions

1. **What is the main financial difference between on-prem and cloud?**
   - *On-prem is CapEx-heavy upfront; cloud is primarily OpEx based on usage.*

2. **Name two advantages of cloud over on-prem for a DevOps team.**
   - *Faster provisioning and easier automation through APIs/IaC.*

3. **Name one reason a company might keep workloads on-prem.**
   - *Regulatory requirements, legacy systems, or existing data center investment.*

4. **What is lift and shift?**
   - *Moving applications to cloud with minimal architectural changes, often VM to Azure VM.*

5. **Can cloud be more expensive than on-prem?**
   - *Yes — poorly optimized workloads, idle resources, and lack of governance increase cloud costs.*

---

## References to Verify

- [Azure Cloud Adoption Framework — Migrate](https://learn.microsoft.com/azure/cloud-adoption-framework/migrate/) — migration approaches
- [Azure pricing TCO](https://azure.microsoft.com/pricing/tco/calculator/) — TCO and cost perspectives
- [Microsoft Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/) — organizational migration guidance (covered in Module 02)

---

**Next:** [05-cloud-pricing-basics.md](05-cloud-pricing-basics.md) — how cloud bills actually work.
