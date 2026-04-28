#!/bin/bash
set -e

FAIL=0
NS="project-tiger"
DS="ds-important"
UUID="18426a0b-5f59-4e10-923f-c0e078e82462"

echo "Checking DaemonSet exists..."

kubectl get daemonset "$DS" -n "$NS" >/dev/null 2>&1 || {
  echo "DaemonSet ds-important not found"
  FAIL=1
}

echo "Checking labels..."

DS_ID=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.metadata.labels.id}' 2>/dev/null || true)
DS_UUID=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.metadata.labels.uuid}' 2>/dev/null || true)
POD_ID=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.template.metadata.labels.id}' 2>/dev/null || true)
POD_UUID=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.template.metadata.labels.uuid}' 2>/dev/null || true)

[ "$DS_ID" = "ds-important" ] || {
  echo "DaemonSet label id is incorrect"
  FAIL=1
}

[ "$DS_UUID" = "$UUID" ] || {
  echo "DaemonSet label uuid is incorrect"
  FAIL=1
}

[ "$POD_ID" = "ds-important" ] || {
  echo "Pod template label id is incorrect"
  FAIL=1
}

[ "$POD_UUID" = "$UUID" ] || {
  echo "Pod template label uuid is incorrect"
  FAIL=1
}

echo "Checking selector..."

SEL_ID=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.selector.matchLabels.id}' 2>/dev/null || true)
SEL_UUID=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.selector.matchLabels.uuid}' 2>/dev/null || true)

[ "$SEL_ID" = "ds-important" ] || {
  echo "Selector id is incorrect"
  FAIL=1
}

[ "$SEL_UUID" = "$UUID" ] || {
  echo "Selector uuid is incorrect"
  FAIL=1
}

echo "Checking container image..."

IMAGE=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)

[ "$IMAGE" = "httpd:2-alpine" ] || {
  echo "Container image is not httpd:2-alpine"
  FAIL=1
}

echo "Checking resource requests..."

CPU=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null || true)
MEM=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null || true)

[ "$CPU" = "10m" ] || {
  echo "CPU request is not 10m"
  FAIL=1
}

[ "$MEM" = "10Mi" ] || {
  echo "Memory request is not 10Mi"
  FAIL=1
}

echo "Checking control-plane toleration..."

TOL=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.spec.template.spec.tolerations[?(@.key=="node-role.kubernetes.io/control-plane")].effect}' 2>/dev/null || true)

if [ "$TOL" != "NoSchedule" ]; then
  echo "Missing control-plane NoSchedule toleration"
  FAIL=1
fi

echo "Checking DaemonSet runs on all nodes..."

NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
READY_DESIRED=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || true)
READY_CURRENT=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.status.currentNumberScheduled}' 2>/dev/null || true)
READY_AVAILABLE=$(kubectl get ds "$DS" -n "$NS" -o jsonpath='{.status.numberAvailable}' 2>/dev/null || true)

[ "$READY_DESIRED" = "$NODE_COUNT" ] || {
  echo "DaemonSet desired pods does not match node count"
  FAIL=1
}

[ "$READY_CURRENT" = "$NODE_COUNT" ] || {
  echo "DaemonSet current pods does not match node count"
  FAIL=1
}

[ "$READY_AVAILABLE" = "$NODE_COUNT" ] || {
  echo "Not all DaemonSet pods are available"
  FAIL=1
}

echo "Checking Pod placement..."

POD_NODE_COUNT=$(kubectl get pods -n "$NS" -l id=ds-important -o jsonpath='{.items[*].spec.nodeName}' 2>/dev/null | tr ' ' '\n' | sort -u | grep -c . || true)

[ "$POD_NODE_COUNT" = "$NODE_COUNT" ] || {
  echo "Pods are not running on every node"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
