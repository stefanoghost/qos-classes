#!/bin/bash
set -e

echo "Preparing scenario..."

# wait cluster ready
for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

# crea namespace
kubectl create namespace maintenance --dry-run=client -o yaml | kubectl apply -f -

# deployment con 3 repliche
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: maintenance
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:stable
EOF

# pod "database" con emptyDir (simula local data)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: database
  namespace: maintenance
spec:
  nodeSelector:
    kubernetes.io/hostname: node01
  containers:
  - name: db
    image: busybox
    command: ["sh", "-c", "echo DB running; sleep 3600"]
    volumeMounts:
    - mountPath: /data
      name: db-data
  volumes:
  - name: db-data
    emptyDir: {}
EOF

kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-

echo "Scenario ready"
kubectl get pods -n maintenance -o wide
