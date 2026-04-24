# Step 1: ClusterIP Service

Create a Service to expose the `web` deployment internally.

## Requirements

- Service name: `web-clusterip`
- Namespace: `services`
- Type: `ClusterIP`
- Port: 80
- Target port: 80
- Selector: app=web

## Verify

- Service exists
- You can access it from inside the cluster

## Useful command

```bash
kubectl create service clusterip web-clusterip \
  --tcp=80:80 \
  -n services

Test it:

kubectl run test --rm -it --image=busybox -n services -- sh
wget -qO- web-clusterip
