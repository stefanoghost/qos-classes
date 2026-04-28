#!/bin/bash
set -e

echo "Preparing storage scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete deployment safari -n project-t230 --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete pvc safari-pvc -n project-t230 --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete pv safari-pv --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete namespace project-t230 --ignore-not-found=true >/dev/null 2>&1 || true

kubectl create namespace project-t230

mkdir -p /Volumes/Data
chmod 777 /Volumes/Data

echo "Scenario ready."
