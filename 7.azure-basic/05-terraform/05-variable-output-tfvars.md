# Variables, Outputs, and tfvars

## Learning Goal

Use **variables** for inputs, **outputs** for results, and **`.tfvars`** files for lab-specific values.

---

## 1. Variable

```hcl
# variables.tf
variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "southeastasia"
}

variable "allowed_ssh_cidr" {
  description = "Your IP for SSH — e.g. 203.0.113.10/32"
  type        = string
}
```

Usage in resources:

```hcl
resource "azurerm_network_security_rule" "ssh" {
  name                       = "SSH"
  priority                   = 1001
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  destination_port_range     = "22"
  source_address_prefix      = var.allowed_ssh_cidr
  # ...
}
```

---

## 2. Output

```hcl
# outputs.tf
output "public_ip" {
  description = "Public IP for SSH and browser"
  value       = azurerm_public_ip.web.ip_address
}
```

After apply:

```bash
terraform output public_ip
```

---

## 3. terraform.tfvars

Real values for your machine — **not committed to Git**.

```hcl
# terraform.tfvars (local only)
location         = "southeastasia"
allowed_ssh_cidr = "203.0.113.10/32"
student_name     = "faizul"
```

### Example file (safe to commit)

```hcl
# terraform.tfvars.example
location         = "southeastasia"
allowed_ssh_cidr = "YOUR_IP/32"
student_name     = "yourname"
```

Copy to start:

```bash
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

---

## 4. Variable Priority (highest wins)

1. `-var` on command line
2. `terraform.tfvars`
3. `TF_VAR_*` environment variables
4. `default` in `variables.tf`

---

## 5. Types (Common)

| Type | Example |
|------|---------|
| `string` | `"Standard_B1s"` |
| `number` | `8` |
| `bool` | `true` |
| `list(string)` | `["a", "b"]` |
| `map(string)` | `{ Name = "web" }` |

---

## 6. Sensitive Output

```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

Still avoid putting passwords in Git — use `TF_VAR_db_password` locally.

---

## Interview Questions

1. **tfvars vs variables.tf?** — *variables.tf declares; tfvars assigns values.*
2. **Why terraform.tfvars.example?** — *Documents required vars without secrets.*

---

## What We Achieved

- Learned variables, outputs, and tfvars pattern used in all labs

**Next:** [06-terraform-labs-same-order-as-console.md](06-terraform-labs-same-order-as-console.md)
