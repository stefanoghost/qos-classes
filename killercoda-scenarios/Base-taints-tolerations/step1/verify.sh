#!/bin/bash

set -e

fail() {
  echo "❌ $1"
  exit 1
}

pass() {
  echo "✅ $1"
}

NS="taint-lab"
POD="database-pod"

kubectl get namespace "$NS" >/dev/null 2>&1 || fail "Namespace '$NS' does not exist"

kubectl get pod "$POD" -n "$NS" >/dev/null 2>&1 || fail "Pod '$POD' does not exist"

TARGET_NODE=$(cat /root/tainted-node.txt | tr -d '[:space:]')

[ -n "$TARGET_NODE" ] || fail "Target node information missing"

kubectl get node "$TARGET_NODE" >/dev/null 2>&1 || fail "Target node '$TARGET_NODE' does not exist"

TAINT_EXISTS=$(kubectl get node "$TARGET_NODE" -o jsonpath='{.spec.taints[?(@.key=="dedicated")].value}')

[ "$TAINT_EXISTS" = "database" ] || fail "Expected taint dedicated=database not found on node '$TARGET_NODE'"

pass "Node taint exists"

IMAGE=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.containers[0].image}')

[ "$IMAGE" = "nginx:1.25" ] || fail "Pod must use image nginx:1.25"

pass "Pod image is correct"

NODE_ASSIGNED=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.nodeName}')

[ "$NODE_ASSIGNED" = "$TARGET_NODE" ] || fail "Pod is not running on the expected tainted node"

pass "Pod scheduled on correct node"

TOL_KEY=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.tolerations[0].key}')
TOL_OPERATOR=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.tolerations[0].operator}')
TOL_VALUE=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.tolerations[0].value}')
TOL_EFFECT=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.tolerations[0].effect}')

[ "$TOL_KEY" = "dedicated" ] || fail "Toleration key must be 'dedicated'"
[ "$TOL_OPERATOR" = "Equal" ] || fail "Toleration operator must be 'Equal'"
[ "$TOL_VALUE" = "database" ] || fail "Toleration value must be 'database'"
[ "$TOL_EFFECT" = "NoSchedule" ] || fail "Toleration effect must be 'NoSchedule'"

pass "Correct toleration configured"

kubectl wait --for=condition=Ready pod/"$POD" -n "$NS" --timeout=90s >/dev/null 2>&1 || fail "Pod is not Ready"

PHASE=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.status.phase}')

[ "$PHASE" = "Running" ] || fail "Pod is not Running"

pass "Pod is Running"

echo "🎉 Scenario completed successfully!"
exit 0
