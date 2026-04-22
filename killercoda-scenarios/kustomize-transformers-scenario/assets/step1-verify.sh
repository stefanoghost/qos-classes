#!/bin/bash
set -e

kubectl get ns api-gateway-staging >/dev/null 2>&1

kubectl get deploy api-gateway -n api-gateway-staging >/dev/null 2>&1
kubectl get svc api-gateway -n api-gateway-staging >/dev/null 2>&1

POD_COUNT=$(kubectl get pods -n api-gateway-staging --no-headers 2>/dev/null | wc -l)
test "$POD_COUNT" -ge 1

POD_LABELS=$(kubectl get pods -n api-gateway-staging --show-labels --no-headers 2>/dev/null || true)
echo "$POD_LABELS" | grep -q 'env=staging'

ENDPOINTS=$(kubectl get endpoints api-gateway -n api-gateway-staging -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null || true)
test -n "$ENDPOINTS"

echo "Step 1 completed successfully"
