#!/bin/bash
set -e

FAIL=0

echo "Checking node cordon..."

SCHED=$(kubectl get node node01 -o jsonpath='{.spec.unschedulable}' 2>/dev/null || true)

if [ "$SCHED" != "true" ]; then
  echo "Node is not cordoned"
  FAIL=1
fi

echo "Checking pods on worker-2..."

PODS=$(kubectl get pods -n maintenance -o wide | grep node01 || true)

if [ -n "$PODS" ]; then
  echo "There are still pods running on node01"
  echo "$PODS"
  FAIL=1
fi

echo "Checking deployment rescheduled..."

READY=$(kubectl get deploy web-app -n maintenance -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)

if [ "$READY" != "3" ]; then
  echo "Deployment does not have 3 ready replicas"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
