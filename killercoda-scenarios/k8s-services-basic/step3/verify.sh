#!/bin/bash
set -e

FAIL=0

echo "Checking endpoints..."

EP=$(kubectl get endpoints web-clusterip -n services -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null || true)

if [ -z "$EP" ]; then
  echo "No endpoints found for service"
  FAIL=1
fi

echo "Checking number of endpoints..."

COUNT=$(echo "$EP" | wc -w)

if [ "$COUNT" -lt 2 ]; then
  echo "Expected at least 2 endpoints (matching pods)"
  FAIL=1
fi

echo "Checking pod IPs..."

POD_IPS=$(kubectl get pods -n services -o jsonpath='{.items[*].status.podIP}' 2>/dev/null || true)

MATCH=0

for ip in $EP; do
  echo "$POD_IPS" | grep -q "$ip" && MATCH=1
done

if [ "$MATCH" -ne 1 ]; then
  echo "Endpoints do not match pod IPs"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Step 3 Success"
  exit 0
else
  echo "❌ Step 3 Failed"
  exit 1
fi
