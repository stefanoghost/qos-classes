#!/bin/bash
set -e

FAIL=0
NS="project-tiger"

echo "Checking deployment..."

kubectl get deploy deploy-important -n $NS >/dev/null 2>&1 || {
  echo "Deployment not found"
  FAIL=1
}

echo "Checking replicas..."

REPLICAS=$(kubectl get deploy deploy-important -n $NS -o jsonpath='{.spec.replicas}')

[ "$REPLICAS" = "3" ] || {
  echo "Replicas not set to 3"
  FAIL=1
}

echo "Checking containers..."

CONTAINERS=$(kubectl get deploy deploy-important -n $NS -o jsonpath='{.spec.template.spec.containers[*].name}')

echo "$CONTAINERS" | grep -q "container1" || FAIL=1
echo "$CONTAINERS" | grep -q "container2" || FAIL=1

echo "Checking label..."

LABEL=$(kubectl get deploy deploy-important -n $NS -o jsonpath='{.spec.template.metadata.labels.id}')

[ "$LABEL" = "very-important" ] || {
  echo "Label missing"
  FAIL=1
}

echo "Checking pod distribution..."

RUNNING=$(kubectl get pods -n $NS --field-selector=status.phase=Running | wc -l)
PENDING=$(kubectl get pods -n $NS --field-selector=status.phase=Pending | wc -l)

if [ "$RUNNING" -lt 2 ]; then
  echo "Expected at least 2 running pods"
  FAIL=1
fi

if [ "$PENDING" -lt 1 ]; then
  echo "Expected 1 pending pod"
  FAIL=1
fi

echo "Checking nodes distribution..."

NODES=$(kubectl get pods -n $NS -o jsonpath='{.items[*].spec.nodeName}')

COUNT=$(echo "$NODES" | tr ' ' '\n' | sort | uniq | wc -l)

if [ "$COUNT" -lt 2 ]; then
  echo "Pods are not distributed across nodes"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
