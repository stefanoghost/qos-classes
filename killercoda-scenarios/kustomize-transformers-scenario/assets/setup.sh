#!/bin/bash
set -e

mkdir -p /opt/course/6/api-gateway/base
mkdir -p /opt/course/6/api-gateway/staging
mkdir -p /opt/course/6/api-gateway/prod

cat > /opt/course/6/api-gateway/base/kustomization.yaml <<'EOF'
resources:
- deployment.yaml
- service.yaml
EOF

cat > /opt/course/6/api-gateway/base/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-gateway
  template:
    metadata:
      labels:
        app: api-gateway
    spec:
      containers:
      - name: app
        image: nginx
EOF

cat > /opt/course/6/api-gateway/base/service.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: api-gateway
spec:
  selector:
    app: api-gateway
  ports:
  - port: 80
    targetPort: 80
EOF

cat > /opt/course/6/api-gateway/staging/kustomization.yaml <<'EOF'
resources:
- ../base

namespace: api-gateway-staging

commonLabels:
  env: staging
EOF

cat > /opt/course/6/api-gateway/prod/kustomization.yaml <<'EOF'
resources:
- ../base
EOF

chmod -R 755 /opt/course/6/api-gateway

echo "Scenario files created under /opt/course/6/api-gateway"
