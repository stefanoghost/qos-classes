# Question 10: Ingress Configuration with TLS

A Service named `api` needs to be exposed via Ingress.

## Requirements

Create an Ingress with:

- Name: `api-ingress`
- Namespace: `ingress-lab`
- Hostname: `api.example.com`
- TLS enabled with existing secret: `api-tls-cert`
- Path-based routing:
  - `/api/*` routes to Service `api` on port `80`
  - `/health` routes to Service `api` on port `80`

## Important note

TLS is configured at the Ingress level.

Both `/api/` and `/health` are routed by the same Ingress host.  
The backend Service receives normal HTTP traffic after TLS termination.

## Expected manifest

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: ingress-lab
spec:
  tls:
  - hosts:
    - api.example.com
    secretName: api-tls-cert
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /api/
        pathType: Prefix
        backend:
          service:
            name: api
            port:
              number: 80
      - path: /health
        pathType: Exact
        backend:
          service:
            name: api
            port:
              number: 80
Apply
kubectl apply -f ingress.yaml
Verify
kubectl get ingress -n ingress-lab
kubectl describe ingress api-ingress -n ingress-lab
