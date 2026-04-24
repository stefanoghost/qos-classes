#!/bin/bash
set -e

FAIL=0

echo "Checking ClusterIP service..."

TYPE=$(kubectl get svc web-clusterip -n services -o jsonpath='{.spec.type}' 2>/dev/null || true)

if [ "$TYPE" != "ClusterIP" ]; then
  echo "Service is not ClusterIP"
  FAIL=1
fi

PORT=$(kubectl get svc web-clusterip -n services -o jsonpath='{.spec.ports[0].port}' 2>/dev/null || true)

if [ "$PORT" != "80" ]; then
  echo "Service port is not 80"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 1 Success"
  exit 0
else
  echo "❌ Step 1 Failed"
  exit 1
fi
