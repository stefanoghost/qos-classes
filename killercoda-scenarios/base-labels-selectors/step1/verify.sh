#!/bin/bash

set -e

fail() {
  echo "❌ $1"
  exit 1
}

pass() {
  echo "✅ $1"
}

NS="app-space"
POD="frontend-pod"
SVC="frontend-service"

kubectl get namespace "$NS" >/dev/null 2>&1 || fail "Namespace '$NS' does not exist"

kubectl get pod "$POD" -n "$NS" >/dev/null 2>&1 || fail "Pod '$POD' does not exist in namespace '$NS'"

kubectl get service "$SVC" -n "$NS" >/dev/null 2>&1 || fail "Service '$SVC' does not exist in namespace '$NS'"

POD_APP_LABEL=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.metadata.labels.app}')
POD_TIER_LABEL=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.metadata.labels.tier}')
POD_ENV_LABEL=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.metadata.labels.environment}')

[ "$POD_APP_LABEL" = "frontend" ] || fail "Pod '$POD' must have label app=frontend"
[ "$POD_TIER_LABEL" = "web" ] || fail "Pod '$POD' must have label tier=web"
[ "$POD_ENV_LABEL" = "production" ] || fail "Pod '$POD' must have label environment=production"

pass "Pod has the required labels"

SVC_SELECTOR_APP=$(kubectl get service "$SVC" -n "$NS" -o jsonpath='{.spec.selector.app}')
SVC_SELECTOR_TIER=$(kubectl get service "$SVC" -n "$NS" -o jsonpath='{.spec.selector.tier}')

[ "$SVC_SELECTOR_APP" = "frontend" ] || fail "Service '$SVC' selector must include app=frontend"
[ "$SVC_SELECTOR_TIER" = "web" ] || fail "Service '$SVC' selector must include tier=web"

pass "Service has the correct selector"

SVC_PORT=$(kubectl get service "$SVC" -n "$NS" -o jsonpath='{.spec.ports[0].port}')
SVC_TARGET_PORT=$(kubectl get service "$SVC" -n "$NS" -o jsonpath='{.spec.ports[0].targetPort}')

[ "$SVC_PORT" = "80" ] || fail "Service '$SVC' must expose port 80"

if [ "$SVC_TARGET_PORT" != "80" ] && [ -n "$SVC_TARGET_PORT" ]; then
  fail "Service '$SVC' targetPort must be 80 or omitted"
fi

pass "Service port is correct"

kubectl wait --for=condition=Ready pod/"$POD" -n "$NS" --timeout=60s >/dev/null 2>&1 || fail "Pod '$POD' is not Ready"

ENDPOINT_IPS=$(kubectl get endpoints "$SVC" -n "$NS" -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null || true)

[ -n "$ENDPOINT_IPS" ] || fail "Service '$SVC' has no endpoints. Selector may not match the Pod labels"

POD_IP=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.status.podIP}')

echo "$ENDPOINT_IPS" | grep -qw "$POD_IP" || fail "Service '$SVC' endpoints do not include Pod '$POD'"

pass "Service endpoints correctly include the Pod"

echo "🎉 Scenario completed successfully!"
exit 0
