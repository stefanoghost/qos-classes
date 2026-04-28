#!/bin/bash
set -e

echo "Preparing DaemonSet scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete daemonset ds-important -n project-tiger --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete namespace project-tiger --ignore-not-found=true >/dev/null 2>&1 || true

kubectl create namespace project-tiger

echo "Scenario ready."
kubectl get nodes
