#!/bin/bash
set -e

echo "Preparing scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete role list-resources -n staging --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete rolebinding dev-user-binding -n staging --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete namespace staging --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete namespace production --ignore-not-found=true >/dev/null 2>&1 || true

kubectl create namespace staging >/dev/null 2>&1 || true
kubectl create namespace production >/dev/null 2>&1 || true

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: demo-pod
  namespace: staging
spec:
  containers:
  - name: nginx
    image: nginx:stable
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-deploy
  namespace: staging
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-deploy
  template:
    metadata:
      labels:
        app: demo-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:stable
---
apiVersion: v1
kind: Pod
metadata:
  name: prod-pod
  namespace: production
spec:
  containers:
  - name: nginx
    image: nginx:stable
EOF

echo "Scenario ready."
