#!/bin/bash
set -e

echo "Preparing broken Helm scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

mkdir -p /root/helm-charts/monitoring/templates

cat <<EOF > /root/helm-charts/monitoring/Chart.yaml
apiVersion: v2
name: monitoring
version: 0.1.0
EOF

cat <<EOF > /root/helm-charts/monitoring/values.yaml
replica_count: 0
EOF

cat <<EOF > /root/helm-charts/monitoring/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: monitoring-app
spec:
  replicas: {{ .Values.replica_count }}
  selector:
    matchLabels:
      app: monitoring
  template:
    metadata:
      labels:
        app: monitoring
    spec:
      containers:
      - name: nginx
        image: nginx:stable
EOF

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm install monitoring-stack /root/helm-charts/monitoring -n monitoring

echo "Broken deployment ready"
kubectl get deploy -n monitoring
