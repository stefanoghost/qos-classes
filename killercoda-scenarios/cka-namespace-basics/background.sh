#!/bin/bash

set -e

echo "Preparing Kubernetes namespace exercise..."

kubectl delete ns dev test production --ignore-not-found=true

kubectl create namespace existing-ns

kubectl run existing-pod \
  --image=nginx:1.25 \
  --namespace=existing-ns \
  --restart=Never \
  --labels=app=existing-demo \
  >/dev/null 2>&1 || true

kubectl wait --for=condition=Ready pod/existing-pod -n existing-ns --timeout=120s >/dev/null 2>&1 || true

echo "Environment ready."
