#!/bin/bash
set -e

FAIL=0

echo "Checking repo..."

helm repo list | grep -q bitnami || {
  echo "Bitnami repo not found"
  FAIL=1
}

echo "Checking search..."

helm search repo bitnami/nginx >/dev/null 2>&1 || {
  echo "Search failed"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 1 Success"
  exit 0
else
  echo "❌ Step 1 Failed"
  exit 1
fi
