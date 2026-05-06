#!/bin/bash

set -e

echo "Preparing labels and selectors exercise..."

kubectl delete namespace app-space --ignore-not-found=true

kubectl create namespace app-space

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: frontend-pod
  namespace: app-space
  labels:
    app: frontend
    tier: web
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: app-space
spec:
  type: ClusterIP
  selector:
    app: backend
    tier: api
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl wait --for=condition=Ready pod/frontend-pod -n app-space --timeout=120s >/dev/null 2>&1 || true

echo "Environment ready."
