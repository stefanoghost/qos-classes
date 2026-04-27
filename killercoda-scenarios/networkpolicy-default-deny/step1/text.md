# Step 1: Apply Default Deny

Currently, all pods can communicate freely.

## Task

Create a NetworkPolicy that:

- applies to ALL pods
- denies ALL incoming traffic

## Hint

Use:

```yaml
podSelector: {}
policyTypes:
- Ingress
Verify

After applying:

kubectl exec -n netpol client -- nc -z -w 2 frontend 80
