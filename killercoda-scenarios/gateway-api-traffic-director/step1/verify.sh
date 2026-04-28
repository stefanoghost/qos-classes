#!/bin/bash
set -e

FAIL=0
NS="project-r500"

echo "Checking HTTPRoute..."

kubectl get httproute traffic-director -n $NS >/dev/null 2>&1 || {
  echo "HTTPRoute not found"
  FAIL=1
}

echo "Checking host..."

HOST=$(kubectl get httproute traffic-director -n $NS -o jsonpath='{.spec.hostnames[0]}' 2>/dev/null || true)

[ "$HOST" = "r500.gateway" ] || {
  echo "Hostname incorrect"
  FAIL=1
}

echo "Checking paths..."

ROUTE=$(kubectl get httproute traffic-director -n $NS -o yaml)

echo "$ROUTE" | grep -q "/desktop" || FAIL=1
echo "$ROUTE" | grep -q "/mobile" || FAIL=1
echo "$ROUTE" | grep -q "/auto" || FAIL=1

echo "Checking header match..."

echo "$ROUTE" | grep -q "user-agent" || {
  echo "Header match missing"
  FAIL=1
}

echo "Checking backend mapping..."

echo "$ROUTE" | grep -q "web-desktop" || FAIL=1
echo "$ROUTE" | grep -q "web-mobile" || FAIL=1

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
