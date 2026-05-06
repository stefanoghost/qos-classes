#!/bin/bash

set -e

fail() {
  echo "❌ $1"
  exit 1
}

pass() {
  echo "✅ $1"
}

for ns in dev test production; do
  kubectl get namespace "$ns" >/dev/null 2>&1 || fail "Namespace '$ns' does not exist"
done

pass "Required namespaces exist"

kubectl get pod web-dev -n dev >/dev/null 2>&1 || fail "Pod 'web-dev' does not exist in namespace 'dev'"
kubectl get pod web-prod -n production >/dev/null 2>&1 || fail "Pod 'web-prod' does not exist in namespace 'production'"

pass "Required Pods exist in the correct namespaces"

DEV_IMAGE=$(kubectl get pod web-dev -n dev -o jsonpath='{.spec.containers[0].image}')
PROD_IMAGE=$(kubectl get pod web-prod -n production -o jsonpath='{.spec.containers[0].image}')

[ "$DEV_IMAGE" = "nginx:1.25" ] || fail "Pod 'web-dev' must use image nginx:1.25"
[ "$PROD_IMAGE" = "nginx:1.25" ] || fail "Pod 'web-prod' must use image nginx:1.25"

pass "Pods use the correct image"

DEV_LABEL=$(kubectl get pod web-dev -n dev -o jsonpath='{.metadata.labels.app}')
PROD_LABEL=$(kubectl get pod web-prod -n production -o jsonpath='{.metadata.labels.app}')

[ "$DEV_LABEL" = "web" ] || fail "Pod 'web-dev' must have label app=web"
[ "$PROD_LABEL" = "web" ] || fail "Pod 'web-prod' must have label app=web"

pass "Pods have the correct labels"

kubectl wait --for=condition=Ready pod/web-dev -n dev --timeout=60s >/dev/null 2>&1 || fail "Pod 'web-dev' is not Ready"
kubectl wait --for=condition=Ready pod/web-prod -n production --timeout=60s >/dev/null 2>&1 || fail "Pod 'web-prod' is not Ready"

pass "Pods are Ready"

kubectl get service web-prod-svc -n production >/dev/null 2>&1 || fail "Service 'web-prod-svc' does not exist in namespace 'production'"

SVC_PORT=$(kubectl get service web-prod-svc -n production -o jsonpath='{.spec.ports[0].port}')
SVC_TARGET_PORT=$(kubectl get service web-prod-svc -n production -o jsonpath='{.spec.ports[0].targetPort}')
SVC_SELECTOR=$(kubectl get service web-prod-svc -n production -o jsonpath='{.spec.selector.app}')

[ "$SVC_PORT" = "80" ] || fail "Service 'web-prod-svc' must expose port 80"
[ "$SVC_SELECTOR" = "web" ] || fail "Service 'web-prod-svc' must select app=web"

if [ "$SVC_TARGET_PORT" != "80" ] && [ "$SVC_TARGET_PORT" != "" ]; then
  fail "Service 'web-prod-svc' targetPort must be 80 or omitted when using default behavior"
fi

pass "Service is correctly configured"

if kubectl get pod web-dev -n default >/dev/null 2>&1; then
  fail "Pod 'web-dev' must not exist in the default namespace"
fi

if kubectl get pod web-prod -n default >/dev/null 2>&1; then
  fail "Pod 'web-prod' must not exist in the default namespace"
fi

pass "No required Pods were created in the default namespace"

echo "🎉 Scenario completed successfully!"
exit 0
