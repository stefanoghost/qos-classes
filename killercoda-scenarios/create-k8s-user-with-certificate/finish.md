# Scenario Completed

Great job.

You completed a full authentication and authorization workflow in Kubernetes.

## What you practiced

### Step 1
- generated a private key
- created a CSR
- signed a client certificate with the cluster CA
- configured kubeconfig credentials and context
- granted access through a ClusterRoleBinding

### Step 2
- replaced cluster-wide access with namespace-scoped permissions
- created a Role
- created a RoleBinding
- validated effective permissions with `kubectl auth can-i`

## Key concept

Authentication answers:

- Who is the user?

Authorization answers:

- What is the user allowed to do?

This scenario trained both.
