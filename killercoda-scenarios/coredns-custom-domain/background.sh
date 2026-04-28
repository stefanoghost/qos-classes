#!/bin/bash
set -e

echo "Preparing CoreDNS scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

mkdir -p /opt/course/16

# test pod
kubectl run bb --image=busybox:1 --restart=Never -- sleep 1d || true

kubectl wait --for=condition=Ready pod/bb --timeout=120s

echo "Scenario ready"
