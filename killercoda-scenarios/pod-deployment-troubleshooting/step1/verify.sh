#!/bin/bash

set -e

FAIL=0

echo "Checking ConfigMap..."
kubectl get configmap app-config -n production >/dev/null 2>&1 || {
  echo "ConfigMap app-config not found"
  FAIL=1
}

CM_VALUE=$(kubectl get configmap app-config -n production -o jsonpath='{.data.config\.yaml}' 2>/dev/null || true)
EXPECTED='database_host: postgres.production.svc.cluster.local'

if [ "$CM_VALUE" != "$EXPECTED" ]; then
  echo "ConfigMap content is incorrect"
  echo "Expected: $EXPECTED"
  echo "Found: $CM_VALUE"
  FAIL=1
fi

echo "Checking pod volume..."
VOL_EXISTS=$(kubectl get pod app-frontend -n production -o jsonpath='{.spec.volumes[?(@.configMap.name=="app-config")].name}' 2>/dev/null || true)
if [ -z "$VOL_EXISTS" ]; then
  echo "Pod does not reference ConfigMap app-config in volumes"
  FAIL=1
fi

echo "Checking pod volume mount..."
MOUNT_OK=$(kubectl get pod app-frontend -n production -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/etc/app")].name}' 2>/dev/null || true)
if [ -z "$MOUNT_OK" ]; then
  echo "Pod does not mount /etc/app"
  FAIL=1
fi

echo "Checking pod phase..."
PHASE=$(kubectl get pod app-frontend -n production -o jsonpath='{.status.phase}' 2>/dev/null || true)
if [ "$PHASE" != "Running" ]; then
  echo "Pod is not Running. Current phase: $PHASE"
  FAIL=1
fi

echo "Checking mounted file..."
FILE_CONTENT=$(kubectl exec -n production app-frontend -- cat /etc/app/config.yaml 2>/dev/null || true)
if [ "$FILE_CONTENT" != "$EXPECTED" ]; then
  echo "Mounted file content is incorrect"
  echo "Expected: $EXPECTED"
  echo "Found: $FILE_CONTENT"
  FAIL=1
fi

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
