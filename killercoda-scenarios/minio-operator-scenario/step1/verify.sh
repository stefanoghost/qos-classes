#!/bin/bash
set -e
# Namespace
kubectl get ns minio >/dev/null 2>&1
# Helm release
helm -n minio ls | grep minio-operator >/dev/null
# CRD presente
kubectl get crd tenants.minio.min.io >/dev/null
# Tenant creato
kubectl -n minio get tenant tenant >/dev/null
# Verifica enableSFTP
kubectl -n minio get tenant tenant -o yaml | grep enableSFTP | grep true >/dev/null
echo "Tutto corretto!"
