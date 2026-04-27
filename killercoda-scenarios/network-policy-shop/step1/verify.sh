#!/bin/bash
set -e

FAIL=0

echo "Checking NetworkPolicies exist..."

for policy in frontend-policy backend-policy database-policy; do
  kubectl get networkpolicy "$policy" -n shop >/dev/null 2>&1 || {
    echo "Missing NetworkPolicy: $policy"
    FAIL=1
  }
done

echo "Checking policy selectors..."

FRONT_SELECTOR=$(kubectl get netpol frontend-policy -n shop -o jsonpath='{.spec.podSelector.matchLabels.tier}' 2>/dev/null || true)
BACK_SELECTOR=$(kubectl get netpol backend-policy -n shop -o jsonpath='{.spec.podSelector.matchLabels.tier}' 2>/dev/null || true)
DB_SELECTOR=$(kubectl get netpol database-policy -n shop -o jsonpath='{.spec.podSelector.matchLabels.tier}' 2>/dev/null || true)

[ "$FRONT_SELECTOR" = "frontend" ] || {
  echo "frontend-policy does not select tier=frontend"
  FAIL=1
}

[ "$BACK_SELECTOR" = "backend" ] || {
  echo "backend-policy does not select tier=backend"
  FAIL=1
}

[ "$DB_SELECTOR" = "database" ] || {
  echo "database-policy does not select tier=database"
  FAIL=1
}

echo "Checking allowed traffic..."

kubectl exec -n shop test-client -- nc -z -w 2 frontend 80 >/dev/null 2>&1 || {
  echo "test-client cannot reach frontend:80"
  FAIL=1
}

kubectl exec -n shop frontend -- nc -z -w 2 backend 3000 >/dev/null 2>&1 || {
  echo "frontend cannot reach backend:3000"
  FAIL=1
}

kubectl exec -n shop backend -- nc -z -w 2 database 5432 >/dev/null 2>&1 || {
  echo "backend cannot reach database:5432"
  FAIL=1
}

echo "Checking denied traffic..."

if kubectl exec -n shop test-client -- nc -z -w 2 backend 3000 >/dev/null 2>&1; then
  echo "test-client should not reach backend:3000"
  FAIL=1
fi

if kubectl exec -n shop test-client -- nc -z -w 2 database 5432 >/dev/null 2>&1; then
  echo "test-client should not reach database:5432"
  FAIL=1
fi

if kubectl exec -n shop frontend -- nc -z -w 2 database 5432 >/dev/null 2>&1; then
  echo "frontend should not reach database:5432"
  FAIL=1
fi

echo "Checking denied wrong ports..."

if kubectl exec -n shop frontend -- nc -z -w 2 backend 80 >/dev/null 2>&1; then
  echo "frontend should not reach backend:80"
  FAIL=1
fi

if kubectl exec -n shop backend -- nc -z -w 2 database 3000 >/dev/null 2>&1; then
  echo "backend should not reach database:3000"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
