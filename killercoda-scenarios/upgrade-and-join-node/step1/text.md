# Question: Upgrade Kubernetes Version and Join Cluster

A node called **node01** is not part of the cluster and is running an older Kubernetes version.

## Tasks

1. Upgrade the Kubernetes version on node01 to match the control-plane
2. Join node01 to the cluster using kubeadm

## Notes

- SSH into the worker node:
  ssh node01

- Ensure the node becomes Ready
