# RBAC and RoleBinding

In this scenario you need to configure Kubernetes RBAC for a developer.

A developer named **dev-user** must be able to list:

- Pods
- Deployments

but only in the **staging** namespace.

They must **not** have the same permissions in other namespaces.

Your task is to create the correct Role and RoleBinding, then verify access using `kubectl auth can-i`.
