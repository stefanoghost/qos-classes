#!/bin/bash
set -e

FAIL=0

echo "Checking default deny..."

if kubectl exec -n netpol client -- nc -z -w 2 frontend 80 >/dev/null 2>&1; then
  echo "Traffic should be blocked but it's allowed"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 1 Success"
  exit 0
else
  echo "❌ Step 1 Failed"
  exit 1
fi
