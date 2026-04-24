#!/bin/bash
set -e

FAIL=0

echo "Checking namespace..."
kubectl get ns monitoring >/dev/null 2>&1 || {
  echo "Namespace monitoring not found"
  FAIL=1
}

echo "Checking Helm release..."
helm list -n monitoring | grep -q monitoring-stack || {
  echo "Helm release not found"
  FAIL=1
}

echo "Checking deployment replicas..."
REPLICAS=$(kubectl get deploy monitoring-app -n monitoring -o jsonpath='{.spec.replicas}' 2>/dev/null || true)

if [ "$REPLICAS" != "3" ]; then
  echo "Deployment does not have 3 replicas"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
