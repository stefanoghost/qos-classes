# Question 6: Helm Chart Deployment

Deploy a Helm chart with custom configuration.

## Tasks

1. Create a namespace named `monitoring`
2. Deploy the Helm chart located at:


./helm-charts/monitoring


3. Override the following values:

- replica_count = 3
- storage_size = 50Gi
- persistence = true

## Requirements

- Release name: `monitoring-stack`
- Namespace: `monitoring`

## Verify

- Helm release exists
- Deployment has 3 replicas

## Commands

```bash
kubectl create namespace monitoring

helm install monitoring-stack ./helm-charts/monitoring \
  -n monitoring \
  --set replica_count=3 \
  --set storage_size=50Gi \
  --set persistence=true

Check:

helm list -n monitoring
kubectl get deployment -n monitoring
