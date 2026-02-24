# Databricks Workspaces with Terraform (Dev & Prod)

This project provisions **Databricks workspaces on AWS** using Terraform with a clean, modular, multi-environment architecture.

It supports:

- Shared VPC networking
- Separate Dev and Prod environments
- Isolated Terraform state per stack
- Account-level Databricks provisioning

---

## Architecture Overview

The infrastructure is organized into separate Terraform stacks:

```
├── stacks/
│   ├── shared/  → Shared VPC + Subnets + NAT Gateway
│   ├── dev/     → Dev Databricks workspace
│   └── prod/    → Prod Databricks workspace
└── modules/     → Reusable Terraform modules
```

### Shared Networking (Classic Deployment)

The `shared` stack creates:

- 1 VPC
- Public subnet
- Private subnets for Dev and Prod
- 1 NAT Gateway (shared)
- Route tables and Internet Gateway

Both Dev and Prod workspaces attach to this shared VPC.

This allows:

- Cost-efficient NAT usage
- Clear separation of environments
- Independent lifecycle management

---

## Authentication

This project relies on **environment variables** for authentication.
No secrets are stored in Terraform files.

---

### AWS Credentials

Export your AWS credentials before running Terraform:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_REGION="us-east-1"  
```

Export your Databricks credentials:
```bash
export DATABRICKS_ACCOUNT_ID="your_account_id"
export DATABRICKS_CLIENT_ID="your_client_id"
export DATABRICKS_CLIENT_SECRET="your_client_secret"
```