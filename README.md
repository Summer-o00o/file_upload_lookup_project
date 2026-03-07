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
