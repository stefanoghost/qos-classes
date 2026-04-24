# Helm Debug Challenge

A Helm release has already been deployed:


monitoring-stack


However, the application is not running correctly.

## Tasks

1. Investigate the issue
2. Identify what is wrong
3. Fix the problem
4. Ensure the application is running

## Expected Result

- Deployment must have **3 replicas**

## Useful commands

```bash
helm list -n monitoring
helm get values monitoring-stack -n monitoring
helm get manifest monitoring-stack -n monitoring

kubectl get deploy -n monitoring
kubectl get pods -n monitoring
Fix

Use:

helm upgrade monitoring-stack /root/helm-charts/monitoring \
  -n monitoring \
  --set replica_count=3
