# Scenario Completed

Well done.

You configured namespace-scoped RBAC for a user by creating:

- a Role
- a RoleBinding

## What you practiced

- granting permissions only inside one namespace
- binding a Role to a specific user
- validating permissions with `kubectl auth can-i`

## Key concept

A `Role` is namespace-scoped.

A `RoleBinding` grants that Role only inside its namespace.

This is why `dev-user` can list resources in **staging**, but not in other namespaces.
