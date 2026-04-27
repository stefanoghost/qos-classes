#!/bin/bash
set -e

echo "Preparing Ingress scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete namespace ingress-lab --ignore-not-found=true >/dev/null 2>&1 || true
kubectl create namespace ingress-lab

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /tmp/api.key \
  -out /tmp/api.crt \
  -subj "/CN=api.example.com/O=training" >/dev/null 2>&1

kubectl create secret tls api-tls-cert \
  --cert=/tmp/api.crt \
  --key=/tmp/api.key \
  -n ingress-lab

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: ingress-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: nginx:stable
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api
  namespace: ingress-lab
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl wait --for=condition=Available deployment/api -n ingress-lab --timeout=120s

echo "Scenario ready."
