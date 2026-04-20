#!/bin/bash
set -e

# verifica HPA staging
kubectl -n api-gateway-staging get hpa api-gateway >/dev/null

# verifica HPA prod
kubectl -n api-gateway-prod get hpa api-gateway >/dev/null

# verifica maxReplicas staging = 4
STAGING_MAX=$(kubectl -n api-gateway-staging get hpa api-gateway -o jsonpath='{.spec.maxReplicas}')
[ "$STAGING_MAX" = "4" ]

# verifica maxReplicas prod = 6
PROD_MAX=$(kubectl -n api-gateway-prod get hpa api-gateway -o jsonpath='{.spec.maxReplicas}')
[ "$PROD_MAX" = "6" ]

echo "Verifica completata!"
