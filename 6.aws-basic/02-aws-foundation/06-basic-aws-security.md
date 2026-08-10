# Basic AWS Security

## Learning Goal

Learn practical AWS security fundamentals every DevOps engineer applies **before** the first console lab: identity, access, network, encryption, and monitoring basics.

---

## Security Is Your Job in the Cloud

AWS provides powerful security **tools**. You must **configure** them correctly.

Remember from the shared responsibility model:

- **AWS** → security **OF** the cloud
- **You** → security **IN** the cloud

This lesson focuses on what **you** control from day one.

---

## Diagram 4 (Required): Basic AWS Account and Security Flow

```mermaid
flowchart TB
    USER[Human User / CI/CD] --> AUTH{Authenticate}
    AUTH -->|Console password + MFA| CONSOLE[AWS Management Console]
    AUTH -->|Access key / IAM role| CLI[AWS CLI / SDK / Terraform]

    CONSOLE --> IAM[IAM evaluates identity & policies]
    CLI --> IAM

    IAM -->|Allowed| API[AWS Service APIs]
    IAM -->|Denied| DENY[Access Denied]

    API --> EC2[EC2]
    API --> S3[S3]
    API --> RDS[RDS]

    EC2 --> SG[Security Groups]
    RDS --> SG
    S3 --> BP[Bucket Policy + Block Public Access]

    API --> CT[CloudTrail — API audit log]
    API --> CW[CloudWatch — metrics & logs]

    ROOT[Root User] -.->|Emergency only| CONSOLE
```

---

## 1. Identity — Root User vs IAM

| Identity | When to Use | Rules |
|----------|-------------|-------|
| **Root user** | Account creation, billing, rare recovery tasks | Enable MFA; do not use for daily work; no access keys |
| **IAM user** | Individual human access (lab, work) | MFA; least privilege; one user per person |
| **IAM role** | AWS service or app access (EC2, Lambda, CI/CD) | Temporary credentials; preferred over long-lived keys |

### DevOps Example

| Bad | Good |
|-----|------|
| Whole team shares root login | Each engineer has IAM user |
| CI pipeline uses access keys in `.env` committed to Git | CI assumes IAM role via OIDC |
| Admin policy on every user | Lab admin group only for training account |

You will practice IAM in the first console lab.

---

## 2. Least Privilege

Grant **only** the permissions needed — nothing more.

### Example Policy Mindset

| Task | Permission Needed |
|------|-------------------|
| Student EC2 lab | `ec2:*` in training account only (acceptable for isolated lab) |
| CI deploy to S3 | `s3:PutObject` on one bucket — not `s3:*` on `*` |
| Read-only auditor | `ReadOnlyAccess` managed policy |

Start restrictive; add permissions when blocked — not the reverse.

---

## 3. Multi-Factor Authentication (MFA)

MFA requires a second factor (phone app, hardware token) after password.

| Account | MFA |
|---------|-----|
| Root user | **Required** — enable in first account setup |
| IAM users (Console access) | **Strongly recommended** |
| Programmatic-only CI roles | Use role + OIDC; no static passwords |

---

## 4. Credential Hygiene

| Rule | Why |
|------|-----|
| Never commit access keys to Git | Public repos are scanned by attackers in minutes |
| Rotate keys periodically | Limits blast radius if leaked |
| Delete unused keys | Reduces attack surface |
| Use placeholders in course materials | e.g. `AKIAEXAMPLE`, not real keys |
| Prefer IAM roles over keys on EC2 | Instance gets temporary credentials automatically |

### Placeholder Example (Not Real)

```ini
# ~/.aws/credentials — local file only, never commit
[devops-lab]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

---

## 5. Network Security

### Security Groups (Stateful Firewall for EC2/RDS)

| Concept | Detail |
|---------|--------|
| **Stateful** | If inbound allowed and connection established, return traffic is allowed |
| **Default** | Deny all inbound; allow outbound (default VPC setup) |
| **Best practice** | Allow SSH (22) only from **your IP**, not `0.0.0.0/0` |
| **Web traffic** | Allow 80/443 from ALB security group, not from entire internet to app tier |

### Network ACLs (Subnet Level)

Stateless firewall at subnet boundary. Used in custom VPC lab — defense in depth with security groups.

### Public vs Private Subnets

| Subnet | Route to Internet | Typical Placement |
|--------|-------------------|-------------------|
| **Public** | Yes (via Internet Gateway) | ALB, bastion (if used) |
| **Private** | No direct IGW route | Application servers, RDS |

**DevOps rule:** Databases should not be publicly accessible in production.

---

## 6. Data Protection

| Layer | Options |
|-------|---------|
| **In transit** | HTTPS/TLS, SSH |
| **At rest — EBS** | Enable encryption on volume creation |
| **At rest — S3** | SSE-S3 or SSE-KMS (default encryption recommended) |
| **At rest — RDS** | Enable encryption at launch (cannot enable later on existing unencrypted instance) |

You manage encryption **choices**. AWS provides encryption **mechanisms**.

---

## 7. S3 Public Access

S3 data leaks are a top AWS security incident pattern.

| Control | Purpose |
|---------|---------|
| **Block Public Access** (account and bucket level) | Prevent accidental public buckets |
| **Bucket policy** | Explicit allow/deny |
| **IAM policies** | Who can call `s3:GetObject` |

Always verify: "Should this bucket ever be public?" For labs: usually **no**.

---

## 8. Logging and Monitoring (Awareness)

You will use these more in production; know they exist:

| Service | Purpose |
|---------|---------|
| **AWS CloudTrail** | Audit log of API calls (who created that EC2?) |
| **Amazon CloudWatch** | Metrics and logs (CPU, disk, application logs) |
| **AWS Config** | Track resource configuration changes (advanced) |
| **Amazon GuardDuty** | Threat detection (advanced) |

**Operational Excellence:** You cannot secure what you cannot see.

---

## 9. Production Follow-Through

This course stays intentionally foundational. In production, a DevOps engineer should extend these basics with:

- Organization-wide CloudTrail enabled and reviewed
- CloudWatch alarms for important infrastructure and application signals
- IAM roles for workloads and CI/CD instead of long-lived access keys
- Encryption choices documented for S3, EBS, RDS, and backups
- Patch and vulnerability management for EC2 and container images
- Security review of public exposure, especially `0.0.0.0/0`, before deployment

The labs teach the building blocks first. Production hardening is the next layer, not a replacement for these basics.

---

## Security Checklist Before Module 03 Labs

| # | Item | Status |
|---|------|--------|
| 1 | Billing alert configured | ☐ |
| 2 | Root MFA enabled | ☐ |
| 3 | IAM lab user created (not root for labs) | ☐ |
| 4 | No access keys in Git | ☐ |
| 5 | Region set to `ap-southeast-1` (or agreed region) | ☐ |
| 6 | Understand security group basics | ☐ |
| 7 | Read [COST-AND-SAFETY-GUIDE.md](../COST-AND-SAFETY-GUIDE.md) | ☐ |

---

## Real-World DevOps Security Scenarios

| Scenario | Secure Approach |
|----------|-----------------|
| EC2 needs to read S3 | Attach IAM **role** to EC2 with `s3:GetObject` on one bucket |
| Developer needs Console | IAM user + MFA + group policy |
| Terraform in CI/CD | OIDC federation to IAM role — no static keys |
| Temporary contractor access | Time-bound IAM user; delete when project ends |
| SSH to EC2 for debugging | Your IP only in security group; use key pair |

---

## Common Confusion

| Confusion | Clarification |
|-----------|---------------|
| "Security groups and NACLs are the same" | SG = instance ENI level, stateful. NACL = subnet level, stateless |
| "My instance is private so it's secure" | Private subnet helps, but IAM and app vulnerabilities still matter |
| "HTTPS on ALB means database is encrypted" | TLS to ALB encrypts client-to-ALB; DB connections need separate TLS config |
| "AWS encrypts everything by default" | Many services offer default encryption now, but you must verify per service and historically created resources |
| "I'll add security later after the lab works" | Configure security groups and IAM correctly on first launch — retrofitting is harder |

---

## Small Example (Conceptual)

**Insecure lab setup:**

- Root user in Console
- EC2 security group: SSH from `0.0.0.0/0`
- S3 bucket public read
- Access keys in GitHub repo

**Secure lab setup:**

- IAM lab user with MFA
- EC2 security group: SSH from `203.0.113.10/32` (your IP)
- S3 Block Public Access enabled
- Keys only in `~/.aws/credentials` locally

---

## Interview-Style Questions

1. **What is least privilege?**
   - *Granting only the minimum permissions required to perform a task.*

2. **Why avoid using the root user daily?**
   - *Root has unrestricted access; compromise is catastrophic and harder to audit.*

3. **What is the difference between IAM user and IAM role?**
   - *User is long-term identity for a person; role is assumed for temporary credentials, often by services.*

4. **Why not allow SSH from 0.0.0.0/0?**
   - *Exposes SSH to the entire internet, increasing brute-force and exploit risk.*

5. **What does S3 Block Public Access do?**
   - *Prevents buckets and objects from being made public at account or bucket level.*

6. **What is CloudTrail used for?**
   - *Recording AWS API activity for audit and security investigation.*

---

## References to Verify

- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/) — architecture center
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) — official IAM guidance
- [AWS Account Root User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) — when to use root
- [S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html) — S3 public access controls
- [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) — VPC security group documentation

---

**Next:** [diagrams.md](diagrams.md) — visual summary of Module 02.

**Ready for labs:** [03-console-labs/01-iam-basics](../03-console-labs/01-iam-basics/README.md)
