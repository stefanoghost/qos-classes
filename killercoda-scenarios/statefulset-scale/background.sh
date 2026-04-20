#!/bin/bash
set -e

kubectl create namespace project-h800

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: o3db
  namespace: project-h800
spec:
  serviceName: "o3db"
  replicas: 2
  selector:
    matchLabels:
      app: o3db
  template:
    metadata:
      labels:
        app: o3db
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 80
EOF

# service necessario per StatefulSet
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: o3db
  namespace: project-h800
spec:
  clusterIP: None
  selector:
    app: o3db
  ports:
  - port: 80
EOF
