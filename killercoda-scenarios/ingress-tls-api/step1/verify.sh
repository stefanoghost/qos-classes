#!/bin/bash
set -e

FAIL=0
NS="ingress-lab"
ING="api-ingress"

echo "Checking Ingress exists..."
kubectl get ingress "$ING" -n "$NS" >/dev/null 2>&1 || {
  echo "Ingress api-ingress not found in namespace ingress-lab"
  FAIL=1
}

echo "Checking TLS configuration..."
TLS_HOST=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.tls[0].hosts[0]}' 2>/dev/null || true)
TLS_SECRET=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.tls[0].secretName}' 2>/dev/null || true)

[ "$TLS_HOST" = "api.example.com" ] || {
  echo "TLS host is not api.example.com"
  FAIL=1
}

[ "$TLS_SECRET" = "api-tls-cert" ] || {
  echo "TLS secret is not api-tls-cert"
  FAIL=1
}

echo "Checking host rule..."
RULE_HOST=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].host}' 2>/dev/null || true)

[ "$RULE_HOST" = "api.example.com" ] || {
  echo "Ingress rule host is not api.example.com"
  FAIL=1
}

echo "Checking /api/ path..."
API_PATH=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/api/")].path}' 2>/dev/null || true)
API_TYPE=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/api/")].pathType}' 2>/dev/null || true)
API_SVC=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/api/")].backend.service.name}' 2>/dev/null || true)
API_PORT=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/api/")].backend.service.port.number}' 2>/dev/null || true)

[ "$API_PATH" = "/api/" ] || {
  echo "/api/ path not found"
  FAIL=1
}

[ "$API_TYPE" = "Prefix" ] || {
  echo "/api/ pathType is not Prefix"
  FAIL=1
}

[ "$API_SVC" = "api" ] || {
  echo "/api/ backend service is not api"
  FAIL=1
}

[ "$API_PORT" = "80" ] || {
  echo "/api/ backend port is not 80"
  FAIL=1
}

echo "Checking /health path..."
HEALTH_PATH=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/health")].path}' 2>/dev/null || true)
HEALTH_TYPE=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/health")].pathType}' 2>/dev/null || true)
HEALTH_SVC=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/health")].backend.service.name}' 2>/dev/null || true)
HEALTH_PORT=$(kubectl get ingress "$ING" -n "$NS" -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/health")].backend.service.port.number}' 2>/dev/null || true)

[ "$HEALTH_PATH" = "/health" ] || {
  echo "/health path not found"
  FAIL=1
}

[ "$HEALTH_TYPE" = "Exact" ] || {
  echo "/health pathType is not Exact"
  FAIL=1
}

[ "$HEALTH_SVC" = "api" ] || {
  echo "/health backend service is not api"
  FAIL=1
}

[ "$HEALTH_PORT" = "80" ] || {
  echo "/health backend port is not 80"
  FAIL=1
}

echo "Checking TLS secret exists..."
kubectl get secret api-tls-cert -n "$NS" >/dev/null 2>&1 || {
  echo "TLS secret api-tls-cert not found"
  FAIL=1
}

if [ "$FAIL" -eq 0 ]; then
  echo "✅ Success"
  exit 0
else
  echo "❌ Verification failed"
  exit 1
fi
