#!/bin/bash
set -e

echo "Preparing Helm search scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl create namespace helm-search --dry-run=client -o yaml | kubectl apply -f -

echo "Scenario ready"
