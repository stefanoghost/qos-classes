# Kubernetes User Certificate Scenario

In this scenario you will create a new Kubernetes user authenticated by a client certificate.

You are connected to the control-plane node and have access to the cluster CA files.

Your goal is to create a new user named **stefano**, configure kubectl credentials and context, and grant read-only access to cluster resources.

This exercise practices:

- private key generation
- CSR creation
- certificate signing
- kubeconfig user/context configuration
- RBAC authorization
