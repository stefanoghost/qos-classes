#!/bin/bash
set -e

FAIL=0

echo "Checking ServiceAccount..."
kubectl get serviceaccount dev-sa -n staging >/dev/null 2>&1 || {
  echo "ServiceAccount dev-sa not found in staging"
  FAIL=1
}

echo "Checking Role..."
kubectl get role list-resources-sa -n staging >/dev/null 2>&1 || {
  echo "Role list-resources-sa not found in staging"
  FAIL=1
}

ROLE_JSON=$(kubectl get role list-resources-sa -n staging -o json 2>/dev/null || true)

echo "$ROLE_JSON" | grep -q '"pods"' || {
  echo "Role does not include pods"
  FAIL=1
}

echo "$ROLE_JSON" | grep -q '"deployments"' || {
  echo "Role does not include deployments"
  FAIL=1
}

echo "$ROLE_JSON" | grep -q '"list"' || {
  echo "Role does not include list verb"
  FAIL=1
}

echo "Checking RoleBinding..."
kubectl get rolebinding dev-sa-binding -n staging >/dev/null 2>&1 || {
  echo "RoleBinding dev-sa-binding not found in staging"
  FAIL=1
}

RB_SUBJECT_NAME=$(kubectl get rolebinding dev-sa-binding -n staging -o jsonpath='{.subjects[0].name}' 2>/dev/null || true)
RB_SUBJECT_KIND=$(kubectl get rolebinding dev-sa-binding -n staging -o jsonpath='{.subjects[0].kind}' 2>/dev/null || true)
RB_SUBJECT_NS=$(kubectl get rolebinding dev-sa-binding -n staging -o jsonpath='{.subjects[0].namespace}' 2>/dev/null || true)
RB_ROLE_NAME=$(kubectl get rolebinding dev-sa-binding -n staging -o jsonpath='{.roleRef.name}' 2>/dev/null || true)
RB_ROLE_KIND=$(kubectl get rolebinding dev-sa-binding -n staging -o jsonpath='{.roleRef.kind}' 2>/dev/null || true)

[ "$RB_SUBJECT_NAME" = "dev-sa" ] || {
  echo "RoleBinding subject name is not dev-sa"
  FAIL=1
}

[ "$RB_SUBJECT_KIND" = "ServiceAccount" ] || {
  echo "RoleBinding subject kind is not ServiceAccount"
  FAIL=1
}

[ "$RB_SUBJECT_NS" = "staging" ] || {
  echo "RoleBinding subject namespace is not staging"
  FAIL=1
}

[ "$RB_ROLE_NAME" = "list-resources-sa" ] || {
  echo "RoleBinding does not point to list-resources-sa"
  FAIL=1
}

[ "$RB_ROLE_KIND" = "Role" ] || {
  echo "RoleBinding roleRef kind is not Role"
  FAIL=1
}

echo "Checking allowed permission: pods in staging..."
kubectl auth can-i list pods \
  --as=system:serviceaccount:staging:dev-sa \
  -n staging | grep -q "yes" || {
  echo "ServiceAccount dev-sa cannot list pods in staging"
  FAIL=1
}

echo "Checking allowed permission: deployments in staging..."
kubectl auth can-i list deployments \
  --as=system:serviceaccount:staging:dev-sa \
  -n staging | grep -q "yes" || {
  echo "ServiceAccount dev-sa cannot list deployments in staging"
  FAIL=1
}

echo "Checking denied permission: pods in production..."
kubectl auth can-i list pods \
  --as=system:serviceaccount:staging:dev-sa \
  -n production | grep -q "no" || {
  echo "ServiceAccount dev-sa should not list pods in production"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
