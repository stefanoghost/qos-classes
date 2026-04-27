#!/bin/bash
set -e

echo "Preparing NetworkPolicy scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete namespace shop --ignore-not-found=true >/dev/null 2>&1 || true
kubectl create namespace shop

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: shop
  labels:
    tier: frontend
    app: frontend
spec:
  containers:
  - name: server
    image: busybox:1.36
    command:
    - sh
    - -c
    - |
      while true; do echo "frontend ok" | nc -l -p 80; done
---
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: shop
  labels:
    tier: backend
    app: backend
spec:
  containers:
  - name: server
    image: busybox:1.36
    command:
    - sh
    - -c
    - |
      while true; do echo "backend ok" | nc -l -p 3000; done
---
apiVersion: v1
kind: Pod
metadata:
  name: database
  namespace: shop
  labels:
    tier: database
    app: database
spec:
  containers:
  - name: server
    image: busybox:1.36
    command:
    - sh
    - -c
    - |
      while true; do echo "database ok" | nc -l -p 5432; done
---
apiVersion: v1
kind: Pod
metadata:
  name: test-client
  namespace: shop
  labels:
    tier: external
spec:
  containers:
  - name: client
    image: busybox:1.36
    command: ["sh", "-c", "sleep 3600"]
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: shop
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: shop
spec:
  selector:
    app: backend
  ports:
  - port: 3000
    targetPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: database
  namespace: shop
spec:
  selector:
    app: database
  ports:
  - port: 5432
    targetPort: 5432
EOF

kubectl wait --for=condition=Ready pod/frontend -n shop --timeout=120s
kubectl wait --for=condition=Ready pod/backend -n shop --timeout=120s
kubectl wait --for=condition=Ready pod/database -n shop --timeout=120s
kubectl wait --for=condition=Ready pod/test-client -n shop --timeout=120s

echo "Scenario ready."
kubectl get pods -n shop -o wide
