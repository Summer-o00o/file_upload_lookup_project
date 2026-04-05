# File Upload Lookup Project

This project lets users upload files to S3 and look up previously uploaded files through a small React frontend, a Spring Boot backend, and AWS serverless components.

## Structure

| Path | Description |
| --- | --- |
| `frontend/` | React application for upload and lookup screens |
| `backend/` | Spring Boot API for presigned uploads and metadata writes |
| `lambdas/` | Lambda functions for file lookup and stream notifications |
| `terraform/` | Infrastructure as Code for API Gateway, S3, DynamoDB, Lambda, SNS, and networking |
| `docs/` | Architecture notes and diagrams |
| `scripts/` | Deployment helper scripts |

## Architecture overview

The system has two main request paths:

- Upload requests go through API Gateway to the Spring Boot backend running behind an internal ALB.
- File lookup requests go from API Gateway directly to a Lambda that reads DynamoDB.
- After metadata is written, DynamoDB Streams triggers another Lambda that publishes an SNS notification.

```mermaid
flowchart LR
    User[User Browser] --> Frontend[React Frontend]

    Frontend --> Api[API Gateway HTTP API]
    Api -->|POST /api/upload/url\nPOST /api/metadata| Vpc[VPC Link]
    Vpc --> Alb[Internal ALB]
    Alb --> Backend[Spring Boot on EC2]

    Backend -->|Generate presigned URL| Frontend
    Frontend -->|PUT file with presigned URL| S3[(S3 Bucket)]
    Backend -->|Save metadata| Dynamo[(DynamoDB file_metadata)]

    Api -->|GET /api/files| Lookup[Lambda: file_lookup]
    Lookup --> Dynamo
    Frontend -->|Open object URL| S3

    Dynamo --> Stream[DynamoDB Stream]
    Stream --> Notify[Lambda: stream_notification]
    Notify --> Sns[SNS Topic]
    Sns --> Email[Email Subscription]
```

## Upload flow

The upload path is split into two stages: the backend creates a presigned URL, then the browser uploads the file directly to S3 and records metadata separately.

```mermaid
sequenceDiagram
    participant U as User
    participant F as React Frontend
    participant A as API Gateway
    participant B as Spring Boot Backend
    participant S as S3 Bucket
    participant D as DynamoDB
    participant N as Notification Pipeline

    U->>F: Choose file and click upload
    F->>A: POST /api/upload/url
    A->>B: Forward request through VPC Link + ALB
    B-->>F: Return presigned uploadUrl + s3Key
    F->>S: PUT file to presigned URL
    F->>A: POST /api/metadata with fileName + s3Key
    A->>B: Forward request through VPC Link + ALB
    B->>D: PutItem(fileId, fileName, s3Key, uploadTime)
    D-->>N: Emit INSERT on DynamoDB Stream
```

## Lookup and notification flow

Lookup is intentionally separated from the Spring Boot backend. API Gateway routes `GET /api/files` straight to Lambda, which reads DynamoDB and returns the saved file metadata. The frontend then builds direct S3 object links from the returned `s3Key` values.

```mermaid
flowchart LR
    Frontend[React Frontend] -->|GET /api/files| Api[API Gateway]
    Api -->|AWS_PROXY| Lookup[Lambda: file_lookup]
    Lookup -->|Scan file_metadata| Dynamo[(DynamoDB)]
    Dynamo --> Lookup
    Lookup -->|JSON metadata list| Frontend
    Frontend -->|View file link| S3[(S3 Bucket)]

    Dynamo --> Stream[DynamoDB Stream]
    Stream --> Notify[Lambda: stream_notification]
    Notify --> Sns[SNS Topic]
    Sns --> Email[Email inbox]
```

## Build outputs (ignored by git)

- Frontend: `node_modules/`, `build/`, `dist/`
- Backend: `target/`, `build/`, `out/`
- Terraform: `.terraform/`, `*.tfstate`, `*.tfplan`

See `.gitignore` for the full list.

## Terraform setup

Set the SNS email subscription outside the tracked Terraform files before running `terraform plan` or `terraform apply`.

```hcl
# terraform/terraform.tfvars
sns_subscription_email = "you@example.com"
```

You can copy [`terraform/terraform.tfvars.example`](terraform/terraform.tfvars.example) to a local `terraform/terraform.tfvars` file, or provide the value through `TF_VAR_sns_subscription_email`.
