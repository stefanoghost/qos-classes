#!/bin/bash

set -e

echo "Preparing manual scheduling exercise..."

kubectl delete namespace manual-scheduling --ignore-not-found=true

kubectl create namespace manual-scheduling

NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

cat > /root/target-node.txt <<EOF
$NODE_NAME
EOF

cat > /root/manual-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: manual-nginx
  namespace: manual-scheduling
  labels:
    app: manual-nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF

echo "Environment ready."
echo "Target node saved in /root/target-node.txt"
echo "Pod manifest available at /root/manual-pod.yaml"
