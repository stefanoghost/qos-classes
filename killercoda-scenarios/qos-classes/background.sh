#!/bin/bash
set -e

mkdir -p /root/scenario/manifests
cd /root/scenario

cat > manifests/guaranteed-deploy.yaml <<'EOM'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: guaranteed-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: guaranteed-app
  template:
    metadata:
      labels:
        app: guaranteed-app
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        resources:
          requests:
            cpu: "200m"
            memory: "128Mi"
          limits:
            cpu: "200m"
            memory: "128Mi"
EOM

cat > manifests/burstable-deploy.yaml <<'EOM'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: burstable-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: burstable-app
  template:
    metadata:
      labels:
        app: burstable-app
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        resources:
          requests:
            cpu: "100m"
            memory: "64Mi"
          limits:
            cpu: "500m"
            memory: "256Mi"
EOM

cat > manifests/besteffort-deploy.yaml <<'EOM'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: besteffort-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: besteffort-app
  template:
    metadata:
      labels:
        app: besteffort-app
    spec:
      containers:
      - name: nginx
        image: nginx:stable
EOM

cat > verify.sh <<'EOM'
#!/bin/bash
set -e

echo "Controllo dei deployment..."
kubectl get deploy guaranteed-deploy >/dev/null 2>&1
kubectl get deploy burstable-deploy >/dev/null 2>&1
kubectl get deploy besteffort-deploy >/dev/null 2>&1

echo "Attendo che i pod siano Ready..."
kubectl rollout status deployment/guaranteed-deploy --timeout=120s >/dev/null
kubectl rollout status deployment/burstable-deploy --timeout=120s >/dev/null
kubectl rollout status deployment/besteffort-deploy --timeout=120s >/dev/null

G_POD=$(kubectl get pods -l app=guaranteed-app -o jsonpath='{.items[0].metadata.name}')
B_POD=$(kubectl get pods -l app=burstable-app -o jsonpath='{.items[0].metadata.name}')
BE_POD=$(kubectl get pods -l app=besteffort-app -o jsonpath='{.items[0].metadata.name}')

G_QOS=$(kubectl get pod "$G_POD" -o jsonpath='{.status.qosClass}')
B_QOS=$(kubectl get pod "$B_POD" -o jsonpath='{.status.qosClass}')
BE_QOS=$(kubectl get pod "$BE_POD" -o jsonpath='{.status.qosClass}')

echo "Guaranteed Pod QoS: $G_QOS"
echo "Burstable Pod QoS: $B_QOS"
echo "BestEffort Pod QoS: $BE_QOS"

if [[ "$G_QOS" == "Guaranteed" && "$B_QOS" == "Burstable" && "$BE_QOS" == "BestEffort" ]]; then
  echo ""
  echo "Verifica completata con successo."
  exit 0
else
  echo ""
  echo "Verifica fallita."
  exit 1
fi
EOM

chmod +x /root/scenario/verify.sh
#!/bin/bash
while [ ! -f /root/scenario/verify.sh ]; do
  sleep 1
done
