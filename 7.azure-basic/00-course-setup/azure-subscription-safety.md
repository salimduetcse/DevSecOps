# Azure Subscription Safety

## Learning Goal

Set up your Azure subscription so you can learn safely: **MFA on Entra**, **Cost Management budgets**, **Contributor lab user (not Owner daily)**, **resource groups**, and **no secrets in Git**.

---

## Golden Rules

| Rule | Why |
|------|-----|
| **Enable MFA on Entra** | Stolen password alone cannot take subscription |
| **Do not use Owner for daily labs** | Owner can change RBAC and billing access — one mistake is large |
| **Prefer Contributor on a lab resource group** | Enough to create/delete lab resources; smaller blast radius |
| **Set Cost Management budgets** | Know about charges before surprise bill |
| **Use a dedicated lab user** | Auditable actions; separate from personal admin |
| **Never commit credentials** | Bots scan GitHub for secrets in minutes |
| **Use resource groups** | Delete one RG to clean an entire lab |

---

## Step 1 — Create or Access Your Azure Subscription

1. Go to [https://azure.microsoft.com/free/](https://azure.microsoft.com/free/)
2. **Start free** or sign in with a Microsoft / work account
3. Complete email, identity, and payment verification
4. Confirm you have an active **subscription** in the Azure Portal

> Use a personal Microsoft account you control for training, or your company's training subscription if provided.

---

## Step 2 — Enable MFA on Entra ID

1. Sign in to the Azure Portal as subscription admin
2. Open **Microsoft Entra ID** → **Users** → your admin user
3. Or go to [https://aka.ms/mfasetup](https://aka.ms/mfasetup) for security info
4. **Add MFA method** — Authenticator app (Microsoft Authenticator, Google Authenticator)
5. Complete registration

**Test:** Sign out and sign in again — MFA prompt should appear.

---

## Step 3 — Do NOT Use Global Admin Secrets for Daily Labs

| Practice | Detail |
|----------|--------|
| Avoid storing Global Admin passwords in scripts | Use interactive login or least-privilege identities |
| Avoid permanent Owner on personal laptop profile | Assign Contributor on lab RG for daily work |
| Service principal secrets | Create only when Module 04 needs them; rotate and delete after |

Global Admin / Owner should be for subscription setup and recovery — not for every Portal click.

---

## Step 4 — Set Billing Alerts (Cost Management Budgets)

1. Sign in as Owner or Billing Contributor
2. Search **Cost Management + Billing** → **Budgets**
3. **Add** → scope = your subscription (or management group if provided)
4. **Budget name:** `devops-lab-monthly-alert`
5. **Reset period:** Monthly
6. **Amount:** e.g. **$10 USD** (adjust with instructor)
7. **Alert conditions:** 80% and 100% → email alerts
8. **Email recipients:** your email
9. Create budget

### Optional: free credit / spending limits

1. Check **Subscriptions** → your subscription → free trial credit remaining
2. Note when credits expire — pay-as-you-go may start after trial
3. Keep budgets active even after free credits end

---

## Step 5 — Set Default Region

1. When creating resources, choose **Southeast Asia (`southeastasia`)**
2. Keep this region for **all labs** unless instructor says otherwise
3. Optionally set Azure CLI default: `az configure --defaults location=southeastasia`

Using one region avoids:

- Cross-region data transfer charges
- Confusion ("where did I create that VM?")

---

## Step 6 — Create Lab Resource Group and Lab User (Preview)

Full steps in [Module 03 Entra/RBAC lab](../03-console-labs/01-entra-rbac-basics/). Summary:

| Item | Value |
|------|-------|
| Resource group | `devops-lab-<yourname>-rg` in `southeastasia` |
| Lab user | `devops-lab-<yourname>-user` (or guest / collaborator identity) |
| Daily role | **Contributor** on the lab resource group — not Subscription Owner |
| MFA | Yes on the lab user |
| App registration / SP | Create in Module 04 only — not now |

**After setup:** Use the lab user + Contributor scope for daily labs. Keep Owner login rare.

---

## Step 7 — Secure Your Laptop

| Item | Action |
|------|--------|
| SSH private keys | Store in `~/.ssh/` — never in Git repo |
| Azure CLI tokens / SP secrets | Local only — not committed |
| `terraform.tfvars` | Local only — in `.gitignore` |
| Downloads folder | Do not leave credential files sitting around |

Repo [`.gitignore`](../.gitignore) already excludes common secret files.

---

## Subscription Safety Checklist

Complete before Module 03:

- [ ] MFA enabled on Entra admin and lab user
- [ ] Cost Management budget alert configured ($10 or instructor amount)
- [ ] Default region `southeastasia`
- [ ] Lab resource group created
- [ ] Lab user with Contributor (not daily Owner) planned / created (Module 03)
- [ ] `.gitignore` understood — no secrets in Git

---

## What If You See Unexpected Charges?

1. **Cost Management** → **Cost analysis** → view by service (Virtual Machines, MySQL, Load Balancer common culprits)
2. Check all resource groups — students often leave resources outside the lab RG
3. **Virtual machines** → stop/delete all lab VMs
4. **Azure Database for MySQL** → delete flexible servers
5. **Load balancers** → delete
6. Or delete the entire lab resource group
7. Follow [final cleanup checklist](../06-capstone-project/final-cleanup-checklist.md)

---

## Common Mistakes

| Mistake | Consequence |
|---------|-------------|
| Leave VM running overnight | Compute hours add up; disks bill even when deallocated |
| Leave MySQL Flexible Server running | Often **most expensive** student mistake |
| Leave Load Balancer running | Charges continue even with little traffic |
| Create NAT Gateway | High monthly cost + data processing |
| Create Application Gateway “for fun” | Higher cost than Basic/Standard LB for labs |
| Commit client secret to GitHub | Subscription compromise within minutes |
| SSH open to `0.0.0.0/0` | Brute-force attacks (not direct billing, but risk) |

---

## Shared Responsibility Reminder

Microsoft secures the **cloud** (physical data centers, hypervisor). **You** secure:

- Entra users, roles, and secrets
- NSG rules
- Blob public access / anonymous access
- What you deploy and when you delete it

See [02-azure-foundation/05-shared-responsibility-model.md](../02-azure-foundation/05-shared-responsibility-model.md).

---

## Interview-Style Questions

1. **Why enable MFA on Entra?**
   - *Second factor prevents account takeover with password alone.*

2. **Should you use Subscription Owner for daily labs?**
   - *No — use Contributor on a lab resource group; keep Owner for admin tasks.*

3. **First thing to check if bill is high?**
   - *VMs, MySQL Flexible Server, Load Balancer — and delete unused resource groups.*

---

## References to Verify

- [Azure security best practices](https://learn.microsoft.com/azure/security/fundamentals/best-practices-and-patterns)
- [Create and manage budgets](https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-acm-create-budgets)
- [Azure RBAC](https://learn.microsoft.com/azure/role-based-access-control/overview)

---

**Next:** [lab-naming-convention.md](lab-naming-convention.md)
