# AWS Account Safety

## Learning Goal

Set up your AWS account so you can learn safely: **MFA**, **billing alerts**, **IAM lab user**, and **no secrets in Git**.

---

## Golden Rules

| Rule | Why |
|------|-----|
| **Enable MFA on root** | Stolen password alone cannot take account |
| **Do not use root daily** | Unlimited access — one mistake is catastrophic |
| **No root access keys** | Full programmatic access if leaked |
| **Set billing alerts** | Know about charges before surprise bill |
| **Use IAM lab user** | Limited blast radius; auditable actions |
| **Never commit credentials** | Bots scan GitHub for AWS keys in minutes |

---

## Step 1 — Create or Access Your AWS Account

1. Go to [https://aws.amazon.com/](https://aws.amazon.com/)
2. **Create an AWS Account** (or sign in if you have one)
3. Complete email, password, and payment verification
4. Choose **Basic support** (free) unless your company requires otherwise

> Use a personal email you control for training accounts, or your company's training OU if provided.

---

## Step 2 — Enable MFA on Root User

1. Sign in as **root user** (account email + password)
2. Top right → account name → **Security credentials**
3. **Multi-factor authentication (MFA)** → **Assign MFA device**
4. Choose **Authenticator app** (Google Authenticator, Microsoft Authenticator, Authy)
5. Scan QR code → enter two consecutive codes → **Assign MFA**

**Test:** Sign out and sign in again — MFA prompt should appear.

---

## Step 3 — Do NOT Create Root Access Keys

On the same **Security credentials** page:

1. Find **Access keys** section for root
2. If any keys exist → **Delete**
3. If none exist → leave it that way

Root should never have programmatic keys.

---

## Step 4 — Set Billing Alerts (AWS Budgets)

1. Sign in (root or admin IAM user)
2. Search **Billing** → **Budgets**
3. **Create budget** → **Customize (advanced)**
4. **Budget types** → **Cost budget** → Next
5. **Budget name:** `devops-lab-monthly-alert`
6. **Period:** Monthly
7. **Budgeted amount:** e.g. **$10 USD** (adjust with instructor)
8. **Threshold:** 80% and 100% → email alerts
9. **Email recipients:** your email
10. Create budget

### Optional: Free Tier usage alerts

1. **Billing** → **Billing preferences**
2. Enable **Receive Free Tier Usage Alerts**
3. Enable **Receive Billing Alerts** if available

---

## Step 5 — Set Default Region

1. Console top-right region dropdown
2. Select **Asia Pacific (Singapore) `ap-southeast-1`**
3. Keep this region for **all labs** unless instructor says otherwise

Using one region avoids:

- Cross-region data transfer charges
- Confusion ("where did I create that instance?")

---

## Step 6 — Create IAM Lab User (Preview)

Full steps in [Module 03 IAM lab](../03-console-labs/01-iam-basics/02-create-iam-user-for-lab.md). Summary:

| Item | Value |
|------|-------|
| User name | `devops-lab-<yourname>-user` |
| Console access | Yes + MFA |
| Admin for training | Group `devops-lab-admin-group` with `AdministratorAccess` **training only** |
| Access keys | Create in Module 04 only — not now |

**After IAM setup:** Sign out of root → use IAM user for daily labs.

---

## Step 7 — Secure Your Laptop

| Item | Action |
|------|--------|
| `.pem` SSH keys | Store in `~/.ssh/` — never in Git repo |
| AWS credentials | `~/.aws/credentials` — chmod 600 |
| `terraform.tfvars` | Local only — in `.gitignore` |
| Downloads folder | Do not leave credential CSV files |

Repo [`.gitignore`](../.gitignore) already excludes common secret files.

---

## Account Safety Checklist

Complete before Module 03:

- [ ] Root MFA enabled
- [ ] No root access keys
- [ ] Billing budget alert configured ($10 or instructor amount)
- [ ] Free Tier alerts enabled (optional)
- [ ] Default region `ap-southeast-1`
- [ ] IAM lab user created with MFA (Module 03)
- [ ] `.gitignore` understood — no keys in Git

---

## What If You See Unexpected Charges?

1. **Billing** → **Bills** → view by service (EC2, RDS, ELB common culprits)
2. Switch regions — students often leave resources in wrong region
3. **EC2** → Instances → terminate all lab instances
4. **RDS** → delete databases
5. **EC2** → Load Balancers → delete ALBs
6. Follow [final cleanup checklist](../06-capstone-project/final-cleanup-checklist.md)

---

## Common Mistakes

| Mistake | Consequence |
|---------|-------------|
| Leave EC2 running overnight | $0.01–$0.05+/hr adds up |
| Leave RDS running | Often **most expensive** student mistake |
| Leave ALB running | ~$18+/month even idle |
| Create NAT Gateway | ~$32+/month + data processing |
| Commit access key to GitHub | Account compromise within minutes |
| SSH open to `0.0.0.0/0` | Brute-force attacks (not direct billing, but risk) |

---

## Shared Responsibility Reminder

AWS secures the **cloud** (physical data centers, hypervisor). **You** secure:

- IAM users and keys
- Security group rules
- S3 bucket public access
- What you deploy and when you delete it

See [02-aws-foundation/05-shared-responsibility-model.md](../02-aws-foundation/05-shared-responsibility-model.md).

---

## Interview-Style Questions

1. **Why enable MFA on root?**
   - *Second factor prevents account takeover with password alone.*

2. **Should root have access keys?**
   - *No — AWS best practice.*

3. **First thing to check if bill is high?**
   - *EC2, RDS, ELB running in any region.*

---

## References to Verify

- [AWS Account Best Practices](https://docs.aws.amazon.com/accounts/latest/reference/best-practices.html)
- [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

---

**Next:** [lab-naming-convention.md](lab-naming-convention.md)
