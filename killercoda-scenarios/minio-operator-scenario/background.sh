#!/bin/bash
set -e

helm repo add minio-upstream https://operator.min.io/
helm repo update

mkdir -p /opt/helm-repo
cd /opt/helm-repo

helm pull minio-upstream/operator --version 6.0.4
helm repo index .

nohup python3 -m http.server 6000 --directory /opt/helm-repo >/tmp/helm-repo.log 2>&1 &
sleep 2

mkdir -p /opt/course/2
cat > /opt/course/2/minio-tenant.yaml <<'EOF'
apiVersion: minio.min.io/v2
kind: Tenant
metadata:
  name: tenant
  namespace: minio
spec:
  features:
    bucketDNS: false
  image: quay.io/minio/minio:latest
  pools:
    - servers: 1
      name: pool-0
      volumesPerServer: 0
      volumeClaimTemplate:
        apiVersion: v1
        kind: persistentvolumeclaims
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 10Mi
          storageClassName: standard
EOF
