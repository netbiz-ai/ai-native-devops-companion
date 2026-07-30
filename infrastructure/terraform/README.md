# Terraform network exercise

This directory contains one focused AWS network module and a development root.
It creates one VPC and exactly two private subnets—no compute, gateway,
application, public routing, secrets, or IAM roles.

Offline/static route:

```bash
terraform -chdir=infrastructure/terraform/environments/dev fmt -check -recursive
terraform -chdir=infrastructure/terraform/environments/dev init -backend=false
terraform -chdir=infrastructure/terraform/environments/dev validate
```

The apply route is opt-in. Replace ownership and expiry tags, use a disposable
approved account, inspect the exact saved plan, apply only that plan, confirm a
second plan is empty, destroy through the same state, and independently inspect
the account for residual resources. Never commit state, plans, credentials, or
private account data.
