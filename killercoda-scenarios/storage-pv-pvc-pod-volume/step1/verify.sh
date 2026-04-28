#!/bin/bash
set -e

FAIL=0
NS="project-t230"

echo "Checking PersistentVolume..."

kubectl get pv safari-pv >/dev/null 2>&1 || {
  echo "PersistentVolume safari-pv not found"
  FAIL=1
}

PV_CAPACITY=$(kubectl get pv safari-pv -o jsonpath='{.spec.capacity.storage}' 2>/dev/null || true)
PV_ACCESS=$(kubectl get pv safari-pv -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null || true)
PV_PATH=$(kubectl get pv safari-pv -o jsonpath='{.spec.hostPath.path}' 2>/dev/null || true)
PV_STORAGE_CLASS=$(kubectl get pv safari-pv -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)

[ "$PV_CAPACITY" = "2Gi" ] || {
  echo "PV capacity is not 2Gi"
  FAIL=1
}

[ "$PV_ACCESS" = "ReadWriteOnce" ] || {
  echo "PV accessMode is not ReadWriteOnce"
  FAIL=1
}

[ "$PV_PATH" = "/Volumes/Data" ] || {
  echo "PV hostPath is not /Volumes/Data"
  FAIL=1
}

if [ -n "$PV_STORAGE_CLASS" ]; then
  echo "PV should not define storageClassName"
  FAIL=1
fi

echo "Checking PersistentVolumeClaim..."

kubectl get pvc safari-pvc -n "$NS" >/dev/null 2>&1 || {
  echo "PVC safari-pvc not found in project-t230"
  FAIL=1
}

PVC_STATUS=$(kubectl get pvc safari-pvc -n "$NS" -o jsonpath='{.status.phase}' 2>/dev/null || true)
PVC_VOLUME=$(kubectl get pvc safari-pvc -n "$NS" -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)
PVC_REQUEST=$(kubectl get pvc safari-pvc -n "$NS" -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null || true)
PVC_ACCESS=$(kubectl get pvc safari-pvc -n "$NS" -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null || true)
PVC_STORAGE_CLASS=$(kubectl get pvc safari-pvc -n "$NS" -o jsonpath='{.spec.storageClassName}' 2>/dev/null || true)

[ "$PVC_STATUS" = "Bound" ] || {
  echo "PVC is not Bound"
  FAIL=1
}

[ "$PVC_VOLUME" = "safari-pv" ] || {
  echo "PVC is not bound to safari-pv"
  FAIL=1
}

[ "$PVC_REQUEST" = "2Gi" ] || {
  echo "PVC request is not 2Gi"
  FAIL=1
}

[ "$PVC_ACCESS" = "ReadWriteOnce" ] || {
  echo "PVC accessMode is not ReadWriteOnce"
  FAIL=1
}

if [ -n "$PVC_STORAGE_CLASS" ]; then
  echo "PVC should not define storageClassName"
  FAIL=1
fi

echo "Checking Deployment..."

kubectl get deploy safari -n "$NS" >/dev/null 2>&1 || {
  echo "Deployment safari not found"
  FAIL=1
}

IMAGE=$(kubectl get deploy safari -n "$NS" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)
CLAIM=$(kubectl get deploy safari -n "$NS" -o jsonpath='{.spec.template.spec.volumes[?(@.persistentVolumeClaim.claimName=="safari-pvc")].persistentVolumeClaim.claimName}' 2>/dev/null || true)
VOL_NAME=$(kubectl get deploy safari -n "$NS" -o jsonpath='{.spec.template.spec.volumes[?(@.persistentVolumeClaim.claimName=="safari-pvc")].name}' 2>/dev/null || true)

[ "$IMAGE" = "httpd:2-alpine" ] || {
  echo "Deployment image is not httpd:2-alpine"
  FAIL=1
}

[ "$CLAIM" = "safari-pvc" ] || {
  echo "Deployment does not reference PVC safari-pvc"
  FAIL=1
}

echo "Checking volume mount..."

MOUNT_PATH=$(kubectl get deploy safari -n "$NS" -o jsonpath="{.spec.template.spec.containers[0].volumeMounts[?(@.name==\"$VOL_NAME\")].mountPath}" 2>/dev/null || true)

[ "$MOUNT_PATH" = "/tmp/safari-data" ] || {
  echo "PVC is not mounted at /tmp/safari-data"
  FAIL=1
}

echo "Checking Pod readiness..."

kubectl rollout status deploy/safari -n "$NS" --timeout=120s >/dev/null 2>&1 || {
  echo "Deployment safari did not become ready"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
