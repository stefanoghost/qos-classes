#!/bin/bash
set +x
until [ -f /root/.kube/multi-config ]; do
  sleep 1
done
cat <<'EOF'
Scenario pronto.
Usa:
  export KUBECONFIG=/root/.kube/multi-config
Poi controlla i context e completa il task dello step.
EOF
