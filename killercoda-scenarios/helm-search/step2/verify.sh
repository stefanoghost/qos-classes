#!/bin/bash
set -e

FAIL=0

echo "Checking Helm release..."

helm list -n helm-search | grep -q nginx-test || {
  echo "Release not found"
  FAIL=1
}

echo "Checking version..."

VERSION=$(helm list -n helm-search -o json | grep chart | grep nginx | sed 's/.*nginx-\([0-9.]*\).*/\1/')

if [ -z "$VERSION" ]; then
  echo "Version not detected"
  FAIL=1
fi

echo "Checking pods..."

kubectl get pods -n helm-search >/dev/null 2>&1 || {
  echo "Pods not found"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 2 Success"
  exit 0
else
  echo "❌ Step 2 Failed"
  exit 1
fi
