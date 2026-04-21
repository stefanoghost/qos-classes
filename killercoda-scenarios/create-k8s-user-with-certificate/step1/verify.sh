#!/bin/bash
set -e
FAIL=0

echo "Checking generated files..."
for f in /root/stefano.key /root/stefano.csr /root/stefano.crt; do
  if [ ! -f "$f" ]; then
    echo "Missing file: $f"
    FAIL=1
  fi
done

echo "Checking certificate subject..."
SUBJECT=$(openssl x509 -in /root/stefano.crt -noout -subject 2>/dev/null || true)

echo "$SUBJECT" | grep -q "CN *= *stefano" || {
  echo "Certificate CN is not stefano"
  FAIL=1
}

echo "$SUBJECT" | grep -q "O *= *devs" || {
  echo "Certificate organization is not devs"
  FAIL=1
}

echo "Checking kubeconfig credentials..."
kubectl config get-users | grep -q "^stefano$" || {
  echo "User stefano not found in kubeconfig"
  FAIL=1
}

echo "Checking kubeconfig context..."
kubectl config get-contexts -o name | grep -q "^stefano-context$" || {
  echo "Context stefano-context not found"
  FAIL=1
}

CTX_CLUSTER=$(kubectl config view -o jsonpath='{.contexts[?(@.name=="stefano-context")].context.cluster}')
CTX_USER=$(kubectl config view -o jsonpath='{.contexts[?(@.name=="stefano-context")].context.user}')
CTX_NS=$(kubectl config view -o jsonpath='{.contexts[?(@.name=="stefano-context")].context.namespace}')

[ "$CTX_CLUSTER" = "kubernetes" ] || {
  echo "Context stefano-context cluster is not kubernetes"
  FAIL=1
}

[ "$CTX_USER" = "stefano" ] || {
  echo "Context stefano-context user is not stefano"
  FAIL=1
}

[ "$CTX_NS" = "default" ] || {
  echo "Context stefano-context namespace is not default"
  FAIL=1
}

echo "Checking RBAC..."
kubectl get clusterrolebinding stefano-view >/dev/null 2>&1 || {
  echo "ClusterRoleBinding stefano-view not found"
  FAIL=1
}

CRB_USER=$(kubectl get clusterrolebinding stefano-view -o jsonpath='{.subjects[0].name}' 2>/dev/null || true)
CRB_KIND=$(kubectl get clusterrolebinding stefano-view -o jsonpath='{.subjects[0].kind}' 2>/dev/null || true)
CRB_ROLE=$(kubectl get clusterrolebinding stefano-view -o jsonpath='{.roleRef.name}' 2>/dev/null || true)

[ "$CRB_USER" = "stefano" ] || {
  echo "ClusterRoleBinding subject is not stefano"
  FAIL=1
}

[ "$CRB_KIND" = "User" ] || {
  echo "ClusterRoleBinding subject kind is not User"
  FAIL=1
}

[ "$CRB_ROLE" = "view" ] || {
  echo "ClusterRoleBinding role is not view"
  FAIL=1
}

echo "Checking allowed permission..."
kubectl auth can-i get pods --as=stefano -n default | grep -q "yes" || {
  echo "User stefano cannot get pods"
  FAIL=1
}

echo "Checking denied permission..."
kubectl auth can-i create deployments --as=stefano -n default | grep -q "no" || {
  echo "User stefano should not be able to create deployments"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
