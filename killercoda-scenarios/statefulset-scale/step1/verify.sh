#!/bin/bash
set -e

# verifica statefulset esiste
kubectl -n project-h800 get sts o3db >/dev/null

# verifica replica = 1
REPLICAS=$(kubectl -n project-h800 get sts o3db -o jsonpath='{.spec.replicas}')

if [ "$REPLICAS" != "1" ]; then
  echo "StatefulSet non scalato correttamente"
  exit 1
fi

# verifica che esista solo 1 pod
POD_COUNT=$(kubectl -n project-h800 get pod -l app=o3db --no-headers | wc -l)

if [ "$POD_COUNT" -ne 1 ]; then
  echo "Numero Pod errato"
  exit 1
fi

echo "Verifica completata con successo!"
