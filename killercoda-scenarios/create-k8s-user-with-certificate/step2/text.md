# Task

The user **stefano** has already been created.

Now you must restrict access using a namespace-scoped RBAC configuration.

## Requirements

1. Create a namespace named `project-dev` if it does not already exist
2. Create a `Role` named `stefano-dev-reader` in namespace `project-dev`
3. The role must allow `stefano` to:
   - get pods
   - list pods
   - watch pods
4. Create a `RoleBinding` named `stefano-dev-rb` in namespace `project-dev`
5. Bind the role to user `stefano`
6. Remove the previous cluster-wide access granted through `ClusterRoleBinding` named `stefano-view`
7. Ensure:
   - `stefano` **can** list pods in namespace `project-dev`
   - `stefano` **cannot** list pods in namespace `default`
   - `stefano` **cannot** create pods in namespace `project-dev`

## Suggested workflow

### Create the Role

```bash
kubectl create role stefano-dev-reader \
  --verb=get,list,watch \
  --resource=pods \
  -n project-dev


Create the RoleBinding
kubectl create rolebinding stefano-dev-rb \
  --role=stefano-dev-reader \
  --user=stefano \
  -n project-dev
Remove previous cluster-wide access
kubectl delete clusterrolebinding stefano-view
Validate permissions
kubectl auth can-i list pods --as=stefano -n project-dev
kubectl auth can-i list pods --as=stefano -n default
kubectl auth can-i create pods --as=stefano -n project-dev
Notes
Work on the control-plane node
The goal of this step is to replace cluster-wide read access with namespace-scoped access


