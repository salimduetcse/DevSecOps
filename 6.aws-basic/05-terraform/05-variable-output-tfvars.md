# Variables, Outputs, and tfvars

## Learning Goal

Use **variables** for inputs, **outputs** for results, and **`.tfvars`** files for lab-specific values.

---

## 1. Variable

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS Region for all resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "allowed_ssh_cidr" {
  description = "Your IP for SSH — e.g. 203.0.113.10/32"
  type        = string
}
```

Usage in resources:

```hcl
resource "aws_security_group" "web" {
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.allowed_ssh_cidr]
  }
}
```

---

## 2. Output

```hcl
# outputs.tf
output "instance_public_ip" {
  description = "Public IP for SSH and browser"
  value       = aws_instance.web.public_ip
}
```

After apply:

```bash
terraform output instance_public_ip
```

---

## 3. terraform.tfvars

Real values for your machine — **not committed to Git**.

```hcl
# terraform.tfvars (local only)
aws_profile      = "aws-basic-lab"
aws_region       = "ap-southeast-1"
allowed_ssh_cidr = "203.0.113.10/32"
student_name     = "faizul"
```

### Example file (safe to commit)

```hcl
# terraform.tfvars.example
aws_profile      = "aws-basic-lab"
aws_region       = "ap-southeast-1"
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
| `string` | `"t3.micro"` |
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

**Next:** [04-terraform-workflow.md](04-terraform-workflow.md)
