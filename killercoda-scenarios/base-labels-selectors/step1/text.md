# Task

A Pod and a Service already exist in namespace:

```bash
app-space

The Pod is named:

frontend-pod

The Service is named:

frontend-service

The Service currently has no working endpoints because its selector does not match the Pod labels.

Your task is to fix the configuration so that:

The Pod frontend-pod has these labels:
app=frontend
tier=web
environment=production
The Service frontend-service selects the Pod using:
app=frontend
tier=web
The Service must expose port 80.
The Pod must remain in namespace app-space.
The Service must remain in namespace app-space.

Useful commands:

kubectl get pod frontend-pod -n app-space --show-labels
kubectl describe svc frontend-service -n app-space
kubectl get endpoints frontend-service -n app-space
