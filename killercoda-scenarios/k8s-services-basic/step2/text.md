# Step 2: NodePort Service

Expose the application externally using NodePort.

## Requirements

- Service name: `web-nodeport`
- Namespace: `services`
- Type: `NodePort`
- Port: 80
- Target port: 80

## Verify

- Service type is NodePort
- A nodePort is assigned

## Useful command

```bash
kubectl expose deployment web \
  --type=NodePort \
  --port=80 \
  --target-port=80 \
  --name=web-nodeport \
  -n services
Check:

kubectl get svc -n services
