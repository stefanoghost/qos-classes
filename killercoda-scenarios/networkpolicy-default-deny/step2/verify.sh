#!/bin/bash
set -e

FAIL=0

echo "Checking allowed traffic..."

kubectl exec -n netpol client -- nc -z -w 2 frontend 80 >/dev/null 2>&1 || {
  echo "Traffic should be allowed but it's blocked"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 2 Success"
  exit 0
else
  echo "❌ Step 2 Failed"
  exit 1
fi
