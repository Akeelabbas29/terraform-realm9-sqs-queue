# Terraform AWS SQS Queue (terraform-realm9-2)

Terraform module for provisioning AWS SQS queues. Fully idempotent — safe to apply multiple times across multiple projects.

## Resources Created

- **SQS Queue** — standard or FIFO, with SSE encryption
- **Dead Letter Queue** (optional) — with configurable redrive policy

No IAM roles, no security groups, no globally-scoped resources. Every resource uses a random suffix to guarantee uniqueness.

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `project_name` | Project name for naming | `realm9` |
| `environment` | Environment (dev, staging, prod) | `dev` |
| `fifo_queue` | Create FIFO queue | `false` |
| `delay_seconds` | Message delay | `0` |
| `max_message_size` | Max message size (bytes) | `262144` |
| `message_retention_seconds` | Message retention | `345600` |
| `visibility_timeout_seconds` | Visibility timeout | `30` |
| `kms_key_id` | KMS key for encryption (sensitive) | `""` |
| `create_dlq` | Create dead letter queue | `false` |
| `max_receive_count` | Max receives before DLQ | `3` |
| `tags` | Additional tags | `{}` |

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Security

- SSE encryption enabled by default (SQS-managed or KMS)
- No public access — SQS queues are private by default
- All resource names include random suffix to prevent conflicts
