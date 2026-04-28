#!/bin/bash
set -e

echo "Preparing Gateway API scenario..."

for i in {1..60}; do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl delete namespace project-r500 --ignore-not-found=true >/dev/null 2>&1 || true
kubectl create namespace project-r500

# deploy desktop
kubectl run web-desktop \
  -n project-r500 \
  --image=nginx \
  --restart=Never \
  --labels=app=desktop

# deploy mobile
kubectl run web-mobile \
  -n project-r500 \
  --image=nginx \
  --restart=Never \
  --labels=app=mobile

kubectl expose pod web-desktop --port=80 --name=web-desktop -n project-r500
kubectl expose pod web-mobile --port=80 --name=web-mobile -n project-r500

kubectl wait --for=condition=Ready pod -l app=desktop -n project-r500 --timeout=120s
kubectl wait --for=condition=Ready pod -l app=mobile -n project-r500 --timeout=120s

# fake ingress file (input)
mkdir -p /opt/course/13
cat <<EOF > /opt/course/13/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: traffic-director
spec:
  rules:
  - host: r500.gateway
    http:
      paths:
      - path: /desktop
        pathType: Prefix
        backend:
          service:
            name: web-desktop
            port:
              number: 80
      - path: /mobile
        pathType: Prefix
        backend:
          service:
            name: web-mobile
            port:
              number: 80
EOF

echo "Scenario ready"
