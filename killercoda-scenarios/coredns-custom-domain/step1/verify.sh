#!/bin/bash
set -e

FAIL=0

echo "Checking backup..."

[ -f /opt/course/16/coredns_backup.yaml ] || {
  echo "Backup file not found"
  FAIL=1
}

echo "Checking CoreDNS config..."

COREFILE=$(kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}')

echo "$COREFILE" | grep -q "custom-domain" || {
  echo "custom-domain not configured in CoreDNS"
  FAIL=1
}

echo "Checking CoreDNS pods..."

kubectl -n kube-system get pods -l k8s-app=kube-dns >/dev/null 2>&1 || {
  echo "CoreDNS pods not found"
  FAIL=1
}

echo "Testing DNS resolution..."

kubectl exec bb -- nslookup kubernetes.default.svc.cluster.local >/dev/null 2>&1 || {
  echo "cluster.local resolution failed"
  FAIL=1
}

kubectl exec bb -- nslookup kubernetes.default.svc.custom-domain >/dev/null 2>&1 || {
  echo "custom-domain resolution failed"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
