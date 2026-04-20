#!/bin/bash
set -e

kubectl rollout status deployment/guaranteed-deploy --timeout=120s >/dev/null
kubectl rollout status deployment/burstable-deploy --timeout=120s >/dev/null
kubectl rollout status deployment/besteffort-deploy --timeout=120s >/dev/null

G_POD=$(kubectl get pods -l app=guaranteed-app -o jsonpath='{.items[0].metadata.name}')
B_POD=$(kubectl get pods -l app=burstable-app -o jsonpath='{.items[0].metadata.name}')
BE_POD=$(kubectl get pods -l app=besteffort-app -o jsonpath='{.items[0].metadata.name}')

G_QOS=$(kubectl get pod "$G_POD" -o jsonpath='{.status.qosClass}')
B_QOS=$(kubectl get pod "$B_POD" -o jsonpath='{.status.qosClass}')
BE_QOS=$(kubectl get pod "$BE_POD" -o jsonpath='{.status.qosClass}')

if [ "$G_QOS" = "Guaranteed" ] && [ "$B_QOS" = "Burstable" ] && [ "$BE_QOS" = "BestEffort" ]; then
  echo "Verifica completata con successo."
  exit 0
fi

echo "Verifica fallita."
exit 1
