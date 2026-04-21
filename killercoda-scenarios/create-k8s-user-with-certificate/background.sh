#!/bin/bash

echo "Preparing scenario..."

kubectl config use-context kubernetes-admin@kubernetes >/dev/null 2>&1 || true

kubectl delete clusterrolebinding stefano-view --ignore-not-found >/dev/null 2>&1 || true
kubectl delete rolebinding stefano-dev-rb -n project-dev --ignore-not-found >/dev/null 2>&1 || true
kubectl delete role stefano-dev-reader -n project-dev --ignore-not-found >/dev/null 2>&1 || true
kubectl delete certificatesigningrequest stefano-certificate --ignore-not-found >/dev/null 2>&1 || true
kubectl delete namespace project-dev --ignore-not-found >/dev/null 2>&1 || true

kubectl create namespace project-dev >/dev/null 2>&1 || true

rm -f /root/stefano.key /root/stefano.csr /root/stefano.crt
rm -f /root/stefano.csr.base64
rm -f /root/.kube/config.backup

echo "Scenario ready."
