
#!/bin/bash
set -e
export KUBECONFIG=/root/.kube/multi-config

test -f /root/solution/developer.crt

grep -q "BEGIN CERTIFICATE" /root/solution/developer.crt
grep -q "DEV-USER-CERTIFICATE" /root/solution/developer.crt

CTX_COUNT=$(kubectl config get-contexts -o name | wc -l)
if [ "$CTX_COUNT" -lt 3 ]; then
  echo "Context non trovati correttamente"
  exit 1
fi

CURRENT=$(kubectl config current-context)
if [ "$CURRENT" != "dev-frontend" ]; then
  echo "Context corrente inatteso: $CURRENT"
  exit 1
fi

echo "Verifica completata con successo."
