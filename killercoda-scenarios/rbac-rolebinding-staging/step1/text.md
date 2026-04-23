# Question 2: RBAC and Service Account

A developer needs to be able to list **Deployments** and **Pods** in the `staging` namespace, but not in other namespaces.

Currently, they cannot perform these actions.

## Create

1. A `Role` named `list-resources` that allows listing:
   - Pods
   - Deployments

2. A `RoleBinding` named `dev-user-binding` that grants this Role to the user:
   - `dev-user`

## Verify

Use `kubectl auth can-i` to verify that:

- `dev-user` **can** list Pods in `staging`
- `dev-user` **can** list Deployments in `staging`
- `dev-user` **cannot** list Pods in `production`

## Notes

- Work only in the `staging` namespace
- Use `--as=dev-user` to test the permissions

## Useful commands

Create the Role:

```bash
kubectl create role list-resources \
  --verb=list \
  --resource=pods,deployments \
  -n staging

Create the RoleBinding:

kubectl create rolebinding dev-user-binding \
  --role=list-resources \
  --user=dev-user \
  -n staging

Verify permissions:

kubectl auth can-i list pods --as=dev-user -n staging
kubectl auth can-i list deployments --as=dev-user -n staging
kubectl auth can-i list pods --as=dev-user -n production
