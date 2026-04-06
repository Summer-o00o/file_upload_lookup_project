# File Upload Lookup Project

## Structure

| Path       | Description                |
| ---------- | -------------------------- |
| `frontend/` | React application          |
| `backend/`  | Spring Boot API            |
| `terraform/` | Infrastructure as Code   |
| `docs/`     | Architecture diagrams & notes |
| `scripts/`  | Deployment helper scripts  |

## Build outputs (ignored by git)

- **Frontend:** `node_modules/`, `build/`, `dist/`
- **Backend:** `target/`, `build/`, `out/`
- **Terraform:** `.terraform/`, `*.tfstate`, `*.tfplan`

See `.gitignore` for the full list.

## Terraform setup

Set the SNS email subscription outside the tracked Terraform files before running `terraform plan` or `terraform apply`.

```hcl
# terraform/terraform.tfvars
sns_subscription_email = "you@example.com"
```

You can copy [`terraform/terraform.tfvars.example`](terraform/terraform.tfvars.example) to a local `terraform/terraform.tfvars` file, or provide the value through `TF_VAR_sns_subscription_email`.
