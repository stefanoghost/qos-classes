#!/bin/bash
set -e

FAIL=0

echo "Checking Role..."
kubectl get role list-resources -n staging >/dev/null 2>&1 || {
  echo "Role list-resources not found in staging"
  FAIL=1
}

ROLE_JSON=$(kubectl get role list-resources -n staging -o json 2>/dev/null || true)

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
kubectl get rolebinding dev-user-binding -n staging >/dev/null 2>&1 || {
  echo "RoleBinding dev-user-binding not found in staging"
  FAIL=1
}

RB_USER=$(kubectl get rolebinding dev-user-binding -n staging -o jsonpath='{.subjects[0].name}' 2>/dev/null || true)
RB_KIND=$(kubectl get rolebinding dev-user-binding -n staging -o jsonpath='{.subjects[0].kind}' 2>/dev/null || true)
RB_ROLE=$(kubectl get rolebinding dev-user-binding -n staging -o jsonpath='{.roleRef.name}' 2>/dev/null || true)
RB_ROLE_KIND=$(kubectl get rolebinding dev-user-binding -n staging -o jsonpath='{.roleRef.kind}' 2>/dev/null || true)

[ "$RB_USER" = "dev-user" ] || {
  echo "RoleBinding subject is not dev-user"
  FAIL=1
}

[ "$RB_KIND" = "User" ] || {
  echo "RoleBinding subject kind is not User"
  FAIL=1
}

[ "$RB_ROLE" = "list-resources" ] || {
  echo "RoleBinding does not point to list-resources"
  FAIL=1
}

[ "$RB_ROLE_KIND" = "Role" ] || {
  echo "RoleBinding roleRef kind is not Role"
  FAIL=1
}

echo "Checking allowed permission: pods in staging..."
kubectl auth can-i list pods --as=dev-user -n staging | grep -q "yes" || {
  echo "dev-user cannot list pods in staging"
  FAIL=1
}

echo "Checking allowed permission: deployments in staging..."
kubectl auth can-i list deployments --as=dev-user -n staging | grep -q "yes" || {
  echo "dev-user cannot list deployments in staging"
  FAIL=1
}

echo "Checking denied permission: pods in production..."
kubectl auth can-i list pods --as=dev-user -n production | grep -q "no" || {
  echo "dev-user should not list pods in production"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
