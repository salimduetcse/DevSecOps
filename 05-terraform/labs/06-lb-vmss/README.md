# Terraform Lab 06 — Load Balancer and VM Scale Set

> **Cost warning:** Load Balancer + 2 VMs — destroy same day.

## 1. Architecture

Azure Load Balancer (public HTTP) → Backend pool → VM Scale Set (2 instances) with nginx custom_data.

## 2. Files

VMSS custom_data installs nginx — no golden image step for simplicity.

## 3. Commands

```bash
cd 05-terraform/labs/06-lb-vmss
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform apply
# Wait 3-5 min for healthy instances
```

## 4. Expected Output

`frontend_public_ip`, `http_url` = `http://20.x.x.x`

## 5. Validation

```bash
curl $(terraform output -raw http_url)
az network lb show \
  --resource-group $(terraform output -raw resource_group_name) \
  --name $(terraform output -raw lb_name) \
  -o table
```

## 6. Cleanup

```bash
terraform destroy
```

Removes VMSS, Load Balancer, Public IP, NSG, and Resource Group.

## 7. Troubleshooting

| Issue | Fix |
|-------|-----|
| No response from LB | Wait for VMSS instances to finish cloud-init |
| Health probe failing | NSG must allow AzureLoadBalancer on port 80 |

## 8. What We Achieved

- Azure LB + VM Scale Set entirely in Terraform

**Next:** [../07-container-apps/](../07-container-apps/)
