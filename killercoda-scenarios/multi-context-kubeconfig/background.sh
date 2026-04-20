#!/bin/bash
set -e

mkdir -p /root/.kube

DEV_CERT=$(printf '%s' '-----BEGIN CERTIFICATE-----
DEV-USER-CERTIFICATE
-----END CERTIFICATE-----
' | base64 -w0)

OPS_CERT=$(printf '%s' '-----BEGIN CERTIFICATE-----
OPS-USER-CERTIFICATE
-----END CERTIFICATE-----
' | base64 -w0)

DEV_KEY=$(printf '%s' '-----BEGIN PRIVATE KEY-----
DEV-USER-PRIVATE-KEY
-----END PRIVATE KEY-----
' | base64 -w0)

OPS_KEY=$(printf '%s' '-----BEGIN PRIVATE KEY-----
OPS-USER-PRIVATE-KEY
-----END PRIVATE KEY-----
' | base64 -w0)

CA_DATA=$(printf '%s' '-----BEGIN CERTIFICATE-----
DEMO-CA
-----END CERTIFICATE-----
' | base64 -w0)

cat > /root/.kube/multi-config <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CA_DATA}
    server: https://controlplane:6443
  name: training-cluster
- cluster:
    certificate-authority-data: ${CA_DATA}
    server: https://controlplane:6443
  name: admin-cluster
users:
- name: developer
  user:
    client-certificate-data: ${DEV_CERT}
    client-key-data: ${DEV_KEY}
- name: operations
  user:
    client-certificate-data: ${OPS_CERT}
    client-key-data: ${OPS_KEY}
contexts:
- context:
    cluster: training-cluster
    user: developer
    namespace: dev
  name: dev-frontend
- context:
    cluster: training-cluster
    user: developer
    namespace: qa
  name: dev-qa
- context:
    cluster: admin-cluster
    user: operations
    namespace: kube-system
  name: ops-admin
current-context: dev-frontend
EOF

mkdir -p /root/solution
