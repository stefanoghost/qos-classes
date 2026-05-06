#!/bin/bash

set -e

echo "Preparing taints and tolerations exercise..."

kubectl delete namespace taint-lab --ignore-not-found=true

kubectl create namespace taint-lab

WORKER_NODE=$(kubectl get nodes -o jsonpath='{.items[1].metadata.name}')

kubectl taint nodes $WORKER_NODE dedicated=database:NoSchedule --overwrite

cat > /root/db-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: database-pod
  namespace: taint-lab
spec:
  nodeName: $WORKER_NODE
  containers:
  - name: nginx
    image: nginx:1.25
EOF

echo "$WORKER_NODE" > /root/tainted-node.txt

echo "Environment ready."
echo "Tainted node saved in /root/tainted-node.txt"
echo "Pod manifest available at /root/db-pod.yaml"
