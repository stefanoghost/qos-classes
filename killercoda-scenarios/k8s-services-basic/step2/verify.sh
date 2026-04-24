#!/bin/bash
set -e

FAIL=0

echo "Checking NodePort service..."

TYPE=$(kubectl get svc web-nodeport -n services -o jsonpath='{.spec.type}' 2>/dev/null || true)

if [ "$TYPE" != "NodePort" ]; then
  echo "Service is not NodePort"
  FAIL=1
fi

NODEPORT=$(kubectl get svc web-nodeport -n services -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || true)

if [ -z "$NODEPORT" ]; then
  echo "NodePort not assigned"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 2 Success"
  exit 0
else
  echo "❌ Step 2 Failed"
  exit 1
fi
