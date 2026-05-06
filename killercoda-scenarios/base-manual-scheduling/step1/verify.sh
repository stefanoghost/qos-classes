#!/bin/bash
set -e
fail() {
  echo "❌ $1"
  exit 1
}
pass() {
  echo "✅ $1"
}

NS="manual-scheduling"
POD="manual-nginx"
EXPECTED_IMAGE="nginx:1.25"

[ -f /root/target-node.txt ] || fail "/root/target-node.txt does not exist"

TARGET_NODE=$(cat /root/target-node.txt | tr -d '[:space:]')

[ -n "$TARGET_NODE" ] || fail "Target node file is empty"

kubectl get namespace "$NS" >/dev/null 2>&1 || fail "Namespace '$NS' does not exist"

kubectl get pod "$POD" -n "$NS" >/dev/null 2>&1 || fail "Pod '$POD' does not exist in namespace '$NS'"

OWNER_REFS=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.metadata.ownerReferences}')

[ -z "$OWNER_REFS" ] || fail "Pod '$POD' must be a standalone Pod, not created by a Deployment, ReplicaSet, Job, or other controller"

IMAGE=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.containers[0].image}')

[ "$IMAGE" = "$EXPECTED_IMAGE" ] || fail "Pod '$POD' must use image '$EXPECTED_IMAGE'"

NODE_NAME=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.nodeName}')

[ -n "$NODE_NAME" ] || fail "Pod '$POD' does not have spec.nodeName set"

[ "$NODE_NAME" = "$TARGET_NODE" ] || fail "Pod '$POD' is scheduled on '$NODE_NAME', expected '$TARGET_NODE'"

kubectl get node "$TARGET_NODE" >/dev/null 2>&1 || fail "Target node '$TARGET_NODE' does not exist"

PHASE=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.status.phase}')

[ "$PHASE" = "Running" ] || fail "Pod '$POD' is not Running. Current phase: $PHASE"

READY_STATUS=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.status.containerStatuses[0].ready}')

[ "$READY_STATUS" = "true" ] || fail "Container in Pod '$POD' is not Ready"

SCHEDULER_NAME=$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.schedulerName}')

if [ -n "$SCHEDULER_NAME" ] && [ "$SCHEDULER_NAME" != "default-scheduler" ]; then
  fail "Pod '$POD' should not use a custom scheduler"
fi

pass "Namespace exists"
pass "Standalone Pod exists"
pass "Pod image is correct"
pass "Pod has been manually assigned using spec.nodeName"
pass "Pod is running on the expected target node"
pass "Pod is Ready"

echo "🎉 Scenario completed successfully!"
exit 0
