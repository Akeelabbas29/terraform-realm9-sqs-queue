# Terraform AWS SNS Topic (terraform-realm9-2)

Creates a single AWS SNS topic. Zero cost when idle. Fully idempotent — random suffix prevents name conflicts.

## Resources Created

- **SNS Topic** — that's it

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `project_name` | Project name | `realm9` |
| `environment` | Environment | `dev` |
| `tags` | Additional tags | `{}` |

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```
