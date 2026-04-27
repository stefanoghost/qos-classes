# Question 5: Network Policy Troubleshooting

Currently, all pods in namespace `shop` can communicate with each other.

You need to implement network isolation.

## Requirements

Create NetworkPolicies so that:

1. Frontend pods with label `tier=frontend` can receive traffic on port `80` only
2. Backend pods with label `tier=backend` can receive traffic from frontend pods on port `3000` only
3. Database pods with label `tier=database` can receive traffic from backend pods on port `5432` only

## Namespace

All resources are in namespace:

```bash
shop
Useful checks

Check pods:

kubectl get pods -n shop --show-labels

Check services:

kubectl get svc -n shop
network-policy name
frontend-policy
backend-policy
databases-policy

Test connectivity:

kubectl exec -n shop frontend -- nc -z -w 2 backend 3000
kubectl exec -n shop backend -- nc -z -w 2 database 5432
kubectl exec -n shop frontend -- nc -z -w 2 database 5432
Expected result

Allowed:

frontend -> backend:3000
backend  -> database:5432
test-client -> frontend:80

Denied:

frontend -> database:5432
test-client -> backend:3000
test-client -> database:5432
Example policy structure

Frontend:

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-policy
  namespace: shop
spec:
  podSelector:
    matchLabels:
      tier: frontend
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: TCP
      port: 80

Backend:

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: shop
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 3000

Database:

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: database-policy
  namespace: shop
spec:
  podSelector:
    matchLabels:
      tier: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: backend
    ports:
    - protocol: TCP
      port: 5432
