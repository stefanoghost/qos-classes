
# Step 2: Install Specific Version

Install the nginx chart from Bitnami.

## Requirements

- Release name: nginx-test
- Namespace: helm-search
- Use a specific version (not latest)

## Tasks

1. Choose a version of the nginx chart
2. Install it using Helm

## Command example

```bash
helm install nginx-test bitnami/nginx \
  --version <VERSION> \
  -n helm-search
