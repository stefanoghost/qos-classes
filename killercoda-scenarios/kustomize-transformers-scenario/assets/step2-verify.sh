#!/bin/bash
set -e

kubectl get ns api-gateway-prod >/dev/null 2>&1

kubectl get deploy prod-api-gateway -n api-gateway-prod >/dev/null 2>&1
kubectl get svc prod-api-gateway -n api-gateway-prod >/dev/null 2>&1

POD_COUNT=$(kubectl get pods -n api-gateway-prod --no-headers 2>/dev/null | wc -l)
test "$POD_COUNT" -ge 1

IMAGE=$(kubectl get deploy prod-api-gateway -n api-gateway-prod -o jsonpath='{.spec.template.spec.containers[0].image}')
test "$IMAGE" = "nginx:1.25"

ANNOTATION=$(kubectl get deploy prod-api-gateway -n api-gateway-prod -o jsonpath='{.metadata.annotations.owner}')
test "$ANNOTATION" = "team-platform"

POD_LABELS=$(kubectl get pods -n api-gateway-prod --show-labels --no-headers 2>/dev/null || true)
echo "$POD_LABELS" | grep -q 'env=prod'

ENDPOINTS=$(kubectl get endpoints prod-api-gateway -n api-gateway-prod -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null || true)
test -n "$ENDPOINTS"

echo "Step 2 completed successfully"
