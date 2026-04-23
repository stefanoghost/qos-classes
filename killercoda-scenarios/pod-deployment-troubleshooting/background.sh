#!/bin/bash
set -e
echo "Preparing scenario..."
kubectl delete namespace production --ignore-not-found=true >/dev/null 2>&1 || true
kubectl create namespace production >/dev/null 2>&1

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: app-frontend
  namespace: production
  labels:
    app: app-frontend
spec:
  restartPolicy: Always
  containers:
  - name: app
    image: busybox:1.36
    command:
    - /bin/sh
    - -c
    - |
      if [ ! -f /etc/app/config.yaml ]; then
        echo "Missing /etc/app/config.yaml"
        exit 1
      fi
      echo "Config found:"
      cat /etc/app/config.yaml
      sleep 3600
EOF

echo "Scenario ready."
