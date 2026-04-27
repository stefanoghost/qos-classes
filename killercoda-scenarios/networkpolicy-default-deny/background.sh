#!/bin/bash
set -e

echo "Preparing scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete namespace netpol --ignore-not-found=true >/dev/null 2>&1 || true
kubectl create namespace netpol

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: netpol
  labels:
    app: frontend
spec:
  containers:
  - name: server
    image: busybox
    command: ["sh", "-c", "while true; do echo hello | nc -l -p 80; done"]
---
apiVersion: v1
kind: Pod
metadata:
  name: client
  namespace: netpol
spec:
  containers:
  - name: client
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: netpol
spec:
  selector:
    app: frontend
  ports:
  - port: 80
EOF

kubectl wait --for=condition=Ready pod/frontend -n netpol --timeout=120s
kubectl wait --for=condition=Ready pod/client -n netpol --timeout=120s

echo "Scenario ready"
