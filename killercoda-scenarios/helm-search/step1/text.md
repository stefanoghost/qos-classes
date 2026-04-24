
# Step 1: Search Helm Charts

You need to find a chart for **nginx**.

## Tasks

1. Search for nginx charts in Helm repositories
2. Identify available versions
3. List all versions of the chart

## Useful commands

Search charts:

```bash
helm search repo nginx

Show all versions:

helm search repo nginx --versions

Filter Bitnami:

helm search repo bitnami/nginx --versions
Goal

Find a valid chart name and available versions.
