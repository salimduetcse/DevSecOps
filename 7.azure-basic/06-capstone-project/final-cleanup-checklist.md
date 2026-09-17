# Final Cleanup Checklist

Use this checklist **after all labs, capstones, and course completion** in location **`southeastasia`** (and any other region you used).

> **Cost warning:** Any resource left running continues to charge your subscription.

---

## How to Use

1. Open Azure Portal → correct subscription
2. Work through each section below
3. Check box when verified **empty** or **deleted**
4. Repeat for other regions if you experimented elsewhere

Fast option for training RGs:

```bash
az group list --query "[?contains(name,'devops-lab')].name" -o tsv
# az group delete --name devops-lab-<yourname>-rg --yes --no-wait
```

---

## 1. Virtual Machines

**Portal:** Virtual machines → filter `devops-lab`

```bash
az vm list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup,Location:location}" -o table
```

- [ ] All lab/capstone VMs **deleted** (not only stopped)
- [ ] No unexpected running VMs

---

## 2. Managed Disks

**Portal:** Disks → unattached

```bash
az disk list --query "[?diskState=='Unattached' || contains(name,'devops-lab')].{Name:name,RG:resourceGroup,State:diskState}" -o table
```

- [ ] No unattached lab disks
- [ ] Delete orphaned OS/data disks

---

## 3. Snapshots

**Portal:** Snapshots

```bash
az snapshot list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
```

- [ ] Lab Managed Disk snapshots deleted
- [ ] No unexpected snapshot costs

---

## 4. Storage Accounts / Blob

**Portal:** Storage accounts → search `devopslab` / `devops`

```bash
az storage account list --query "[?contains(name,'devopslab') || contains(name,'devops')].{Name:name,RG:resourceGroup}" -o table
```

- [ ] All lab storage accounts deleted
- [ ] Static website accounts removed after capstone

---

## 5. MySQL Flexible Server

**Portal:** Azure Database for MySQL flexible servers

```bash
az mysql flexible-server list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup,State:state}" -o table
```

- [ ] No lab MySQL servers (high cost risk)
- [ ] Firewall rules gone with server delete

---

## 6. Load Balancers

**Portal:** Load balancers

```bash
az network lb list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
```

- [ ] All lab load balancers deleted

---

## 7. Virtual Machine Scale Sets

**Portal:** Virtual machine scale sets

```bash
az vmss list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
```

- [ ] All lab VMSS deleted (instances removed)

---

## 8. Container Apps and Environments

**Portal:** Container Apps / Container Apps Environments

```bash
az containerapp list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
az containerapp env list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
```

- [ ] Apps deleted
- [ ] Environments deleted
- [ ] Related Log Analytics workspaces deleted if created for labs

---

## 9. Azure Container Registry (ACR)

**Portal:** Container registries

```bash
az acr list --query "[?contains(name,'devopslab') || contains(name,'devops')].{Name:name,RG:resourceGroup}" -o table
```

- [ ] Images deleted (or registry deleted)
- [ ] Registries deleted

---

## 10. Public IPs

**Portal:** Public IP addresses

```bash
az network public-ip list --query "[?contains(name,'devops-lab') || ipConfiguration==null].{Name:name,RG:resourceGroup,IP:ipAddress}" -o table
```

- [ ] No unused Standard public IPs (can incur cost when idle depending on SKU/config)

---

## 11. VNets / NICs / NSGs

**Portal:** Virtual networks / Network interfaces / Network security groups

- [ ] Custom lab VNets deleted (after VMs/NICs)
- [ ] Orphan NICs deleted
- [ ] Unused `devops-lab-*` NSGs deleted

```bash
az network vnet list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
az network nic list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
az network nsg list --query "[?contains(name,'devops-lab')].{Name:name,RG:resourceGroup}" -o table
```

---

## 12. NAT Gateways (If Any)

**Portal:** NAT gateways

> NAT Gateway can be **expensive** — delete immediately if created by mistake.

- [ ] No lab NAT Gateways
- [ ] Associated public IPs cleaned up

---

## 13. Resource Groups

**Portal:** Resource groups → filter `devops-lab`

```bash
az group list --query "[?contains(name,'devops-lab')].{Name:name,Location:location}" -o table
```

- [ ] Lab RGs empty or deleted (`az group delete`)

---

## 14. Service Principals / App Registrations (Lab)

**Portal:** Microsoft Entra ID → App registrations → `devops-lab-<yourname>-cli-sp`

```bash
az ad sp list --display-name "devops-lab-<yourname>-cli-sp" --query "[].{AppId:appId,Display:displayName}" -o table
# az ad sp delete --id <appId>
```

- [ ] Lab service principals deleted
- [ ] Client secrets rotated/removed
- [ ] Prefer `az login` for remaining casual use

---

## 15. Local Machine Cleanup

- [ ] Unset `AZURE_CLIENT_SECRET` / related env vars
- [ ] Delete `terraform.tfstate` backup copies from lab folders
- [ ] Delete `*.pem`, secret `.json`, `.env` from Downloads/repo
- [ ] Confirm `.gitignore` prevented credential commits
- [ ] Optional: `az logout` / clear unused Azure CLI accounts

```bash
git status   # no .pem, .tfstate, terraform.tfvars, secrets staged
```

---

## 16. Billing Check

**Portal:** Cost Management + Billing → Cost analysis

- [ ] Review charges by service (VMs, Disks, MySQL, LB, Container Apps, ACR, Bandwidth)
- [ ] Budget alert still configured

---

# Final Revision Questions

Use these to prepare for interviews and course assessment.

## Cloud Fundamentals

1. What are the five characteristics of cloud computing?
2. Difference between SaaS, PaaS, and IaaS?
3. Public vs private vs hybrid cloud?
4. Pay-as-you-go vs reserved vs spot/spot-like savings?
5. Why can cloud cost more than on-prem if poorly managed?

## Azure Foundation

6. Region vs Availability Zone vs edge/CDN location?
7. Name Well-Architected pillars relevant to Azure.
8. What is the Cloud Adoption Framework used for?
9. Shared responsibility: who patches VM OS? MySQL Flexible Server engine?
10. Why protect privileged accounts with MFA?

## VM / VNet

11. What is an NSG? Stateful or mostly evaluate as stateful-like rules engine?
12. What makes a subnet effectively public?
13. Why not SSH from `0.0.0.0/0`?
14. Public IP + system routes vs NAT Gateway?

## Storage

15. Managed Disks vs Blob — when to use each?
16. Why delete unused disks and snapshots?
17. Why be careful with anonymous blob public access?

## Database

18. MySQL Flexible Server vs MySQL on a VM?
19. Why prefer private access / firewall restrictions?

## Load Balancing

20. What does an LB health probe do?
21. What happens when a VMSS instance fails a probe?

## Container Apps

22. Container App vs Environment?
23. Why use ACR instead of only public images?
24. What does external ingress provide?

## CLI

25. Command to show current subscription identity?
26. Why prefer `az login` for students and never commit client secrets?

## Terraform

27. `terraform plan` vs `terraform apply`?
28. Why not commit `terraform.tfstate`?
29. Resource vs data source?
30. What does `terraform destroy` do?

---

## Sign-Off

| Item | Done |
|------|------|
| All checklist sections verified | ☐ |
| Billing reviewed | ☐ |
| Revision questions attempted | ☐ |
| Course complete | ☐ |

**Congratulations — you completed Azure Basic for DevOps Professionals.**
