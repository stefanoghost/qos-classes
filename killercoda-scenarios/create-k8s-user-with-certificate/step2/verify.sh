#!/bin/bash
set -e
FAIL=0

echo "Checking namespace..."
kubectl get namespace project-dev >/dev/null 2>&1 || {
  echo "Namespace project-dev not found"
  FAIL=1
}

echo "Checking old cluster-wide access removal..."
if kubectl get clusterrolebinding stefano-view >/dev/null 2>&1; then
  echo "ClusterRoleBinding stefano-view still exists"
  FAIL=1
fi

echo "Checking Role..."
kubectl get role stefano-dev-reader -n project-dev >/dev/null 2>&1 || {
  echo "Role stefano-dev-reader not found in project-dev"
  FAIL=1
}

ROLE_RULES=$(kubectl get role stefano-dev-reader -n project-dev -o json)
echo "$ROLE_RULES" | grep -q '"pods"' || {
  echo "Role does not target pods"
  FAIL=1
}
echo "$ROLE_RULES" | grep -q '"get"' || {
  echo "Role missing get verb"
  FAIL=1
}
echo "$ROLE_RULES" | grep -q '"list"' || {
  echo "Role missing list verb"
  FAIL=1
}
echo "$ROLE_RULES" | grep -q '"watch"' || {
  echo "Role missing watch verb"
  FAIL=1
}

echo "Checking RoleBinding..."
kubectl get rolebinding stefano-dev-rb -n project-dev >/dev/null 2>&1 || {
  echo "RoleBinding stefano-dev-rb not found in project-dev"
  FAIL=1
}

RB_USER=$(kubectl get rolebinding stefano-dev-rb -n project-dev -o jsonpath='{.subjects[0].name}' 2>/dev/null || true)
RB_KIND=$(kubectl get rolebinding stefano-dev-rb -n project-dev -o jsonpath='{.subjects[0].kind}' 2>/dev/null || true)
RB_ROLE=$(kubectl get rolebinding stefano-dev-rb -n project-dev -o jsonpath='{.roleRef.name}' 2>/dev/null || true)
RB_ROLE_KIND=$(kubectl get rolebinding stefano-dev-rb -n project-dev -o jsonpath='{.roleRef.kind}' 2>/dev/null || true)

[ "$RB_USER" = "stefano" ] || {
  echo "RoleBinding subject is not stefano"
  FAIL=1
}

[ "$RB_KIND" = "User" ] || {
  echo "RoleBinding subject kind is not User"
  FAIL=1
}

[ "$RB_ROLE" = "stefano-dev-reader" ] || {
  echo "RoleBinding does not reference stefano-dev-reader"
  FAIL=1
}

[ "$RB_ROLE_KIND" = "Role" ] || {
  echo "RoleBinding roleRef kind is not Role"
  FAIL=1
}

echo "Checking allowed permission in project-dev..."
kubectl auth can-i list pods --as=stefano -n project-dev | grep -q "yes" || {
  echo "User stefano cannot list pods in project-dev"
  FAIL=1
}

echo "Checking denied permission in default..."
kubectl auth can-i list pods --as=stefano -n default | grep -q "no" || {
  echo "User stefano should not list pods in default"
  FAIL=1
}

echo "Checking denied create in project-dev..."
kubectl auth can-i create pods --as=stefano -n project-dev | grep -q "no" || {
  echo "User stefano should not create pods in project-dev"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
