# Step 2: RBAC and ServiceAccount

A workload running in Kubernetes needs read-only access inside the `staging` namespace.

Create:

1. A `ServiceAccount` named `dev-sa` in namespace `staging`
2. A `Role` named `list-resources-sa` in namespace `staging` that allows:
   - `list` on `pods`
   - `list` on `deployments`
3. A `RoleBinding` named `dev-sa-binding` in namespace `staging`
4. Bind the Role to the ServiceAccount `dev-sa`

## Verify

Make sure that:

- `dev-sa` can list Pods in `staging`
- `dev-sa` can list Deployments in `staging`
- `dev-sa` cannot list Pods in `production`

## Useful commands

Create the ServiceAccount:

```bash
kubectl create serviceaccount dev-sa -n staging

Create the Role:

kubectl create role list-resources-sa \
  --verb=list \
  --resource=pods,deployments \
  -n staging

Create the RoleBinding:

kubectl create rolebinding dev-sa-binding \
  --role=list-resources-sa \
  --serviceaccount=staging:dev-sa \
  -n staging

Verify permissions:

kubectl auth can-i list pods \
  --as=system:serviceaccount:staging:dev-sa \
  -n staging

kubectl auth can-i list deployments \
  --as=system:serviceaccount:staging:dev-sa \
  -n staging

kubectl auth can-i list pods \
  --as=system:serviceaccount:staging:dev-sa \
  -n production
