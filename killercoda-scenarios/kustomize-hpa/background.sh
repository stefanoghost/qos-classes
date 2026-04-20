#!/bin/bash
set -e

mkdir -p /opt/course/5/api-gateway/{base,staging,prod}

# BASE
cat > /opt/course/5/api-gateway/base/api-gateway.yaml <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: horizontal-scaling-config
data:
  horizontal-scaling: "70"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      id: api-gateway
  template:
    metadata:
      labels:
        id: api-gateway
    spec:
      containers:
      - name: httpd
        image: httpd:2-alpine
EOF

cat > /opt/course/5/api-gateway/base/kustomization.yaml <<'EOF'
resources:
- api-gateway.yaml
EOF

# STAGING
cat > /opt/course/5/api-gateway/staging/kustomization.yaml <<'EOF'
resources:
- ../base

patches:
- path: patch.yaml

namespace: api-gateway-staging
EOF

cat > /opt/course/5/api-gateway/staging/patch.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
spec:
  template:
    metadata:
      labels:
        env: staging
EOF

# PROD
cat > /opt/course/5/api-gateway/prod/kustomization.yaml <<'EOF'
resources:
- ../base

patches:
- path: patch.yaml

namespace: api-gateway-prod
EOF

cat > /opt/course/5/api-gateway/prod/patch.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
spec:
  template:
    metadata:
      labels:
        env: prod
EOF
