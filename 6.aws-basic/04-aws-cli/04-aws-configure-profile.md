# Configure Named Profile

## Learning Goal

Configure profile **`aws-basic-lab`**, set region **`ap-southeast-1`**, test with **`sts get-caller-identity`**, and understand CLI command structure.

---

## Step 1 — Run `aws configure` for Named Profile

In Git Bash:

```bash
aws configure --profile aws-basic-lab
```

Answer prompts:

| Prompt | Value |
|--------|-------|
| AWS Access Key ID | Your key (placeholder in docs: `AKIAIOSFODNN7EXAMPLE`) |
| AWS Secret Access Key | Your secret (enter manually — never commit) |
| Default region name | `ap-southeast-1` |
| Default output format | `json` |

This writes to:

- `~/.aws/credentials` — keys
- `~/.aws/config` — region and output

---

## Step 2 — Verify Config Files

```bash
cat ~/.aws/config
```

**Expected (no secrets in config file):**

```ini
[profile aws-basic-lab]
region = ap-southeast-1
output = json
```

```bash
# Do NOT paste output publicly — contains key IDs
grep -A1 '\[aws-basic-lab\]' ~/.aws/credentials
```

---

## Step 3 — Test Identity with STS

```bash
aws sts get-caller-identity --profile aws-basic-lab
```

**Example output:**

```json
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/devops-lab-yourname-user"
}
```

| Field | Meaning |
|-------|---------|
| `Account` | Your 12-digit AWS account ID |
| `Arn` | Full identity path — confirms correct IAM user |
| `UserId` | Unique IAM user ID |

If this works, credentials and profile are correct.

---

## Step 4 — Region and Output Format

### Region

Always use **`ap-southeast-1`** for labs unless instructor says otherwise.

```bash
aws ec2 describe-regions --profile aws-basic-lab --query "Regions[?RegionName=='ap-southeast-1'].RegionName" --output text
```

**Expected:** `ap-southeast-1`

### Output formats

| Format | Use |
|--------|-----|
| `json` | Default for labs — full detail |
| `table` | Human-readable lists |
| `text` | Scripts |
| `yaml` | Readable alternative |

Examples:

```bash
aws sts get-caller-identity --profile aws-basic-lab --output table

aws sts get-caller-identity --profile aws-basic-lab --output text
```

### Override region per command

```bash
aws s3 ls --profile aws-basic-lab --region us-east-1
```

---

## Step 5 — CLI Command Structure

```bash
aws <service> <operation> [options] --profile aws-basic-lab --region ap-southeast-1
```

| Part | Example |
|------|---------|
| Service | `ec2`, `s3`, `rds`, `ecs`, `elbv2` |
| Operation | `describe-instances`, `create-bucket`, `run-instances` |
| Options | `--instance-ids i-xxx`, `--query`, `--output` |
| Global options | `--profile`, `--region`, `--dry-run` |

### Get help

```bash
aws ec2 help
aws ec2 run-instances help
```

### Query and filter (JMESPath)

```bash
aws ec2 describe-instances \
  --profile aws-basic-lab \
  --region ap-southeast-1 \
  --query "Reservations[].Instances[].{Id:InstanceId,State:State.Name}" \
  --output table
```

### Session environment variables (optional)

```bash
export AWS_PROFILE=aws-basic-lab
export AWS_DEFAULT_REGION=ap-southeast-1

aws sts get-caller-identity
```

---

## Step 6 — Dry Run (Safety)

Test permissions without creating resources:

```bash
aws ec2 run-instances \
  --image-id ami-0abcdef1234567890 \
  --instance-type t3.micro \
  --profile aws-basic-lab \
  --region ap-southeast-1 \
  --dry-run
```

If authorized, you get `DryRunOperation` error (that means it would work).

---

## Validation Checklist

- [ ] `aws configure --profile aws-basic-lab` completed
- [ ] `~/.aws/config` has `region = ap-southeast-1`
- [ ] `sts get-caller-identity` returns your lab user ARN
- [ ] Output format `json` works

---

## Troubleshooting

| Error | Solution |
|-------|----------|
| `Unable to locate credentials` | Run `aws configure --profile aws-basic-lab` |
| `InvalidClientTokenId` | Wrong access key — recreate key |
| `SignatureDoesNotMatch` | Wrong secret key |
| `AccessDenied` | IAM user lacks permissions — check admin group |
| Wrong account in ARN | Wrong profile — add `--profile aws-basic-lab` |

---

## Cost Warning

`sts get-caller-identity` is free. Other commands may create paid resources.

---

## What We Achieved

- Configured profile **`aws-basic-lab`**
- Set region **`ap-southeast-1`** and output **`json`**
- Verified identity with **`aws sts get-caller-identity`**
- Learned CLI command structure and `--query`

**Next:** [05-cli-command-cheatsheet.md](05-cli-command-cheatsheet.md)
