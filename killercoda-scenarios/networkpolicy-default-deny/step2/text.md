# Step 2: Allow Traffic to Frontend

Now everything is blocked.

## Task

Allow traffic:

- to frontend pods
- on port 80
- from ANY source

## Hint

Use:

```yaml
podSelector:
  matchLabels:
    app: frontend

Verify
kubectl exec -n netpol client -- nc -z -w 2 frontend 80
