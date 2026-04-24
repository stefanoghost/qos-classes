# Question: Upgrade Kubernetes Version and Join Cluster

A node called **node01** is not part of the cluster and is running an older Kubernetes version.

## Tasks

1. Upgrade the Kubernetes version on node01 to match the control-plane
2. Join node01 to the cluster using kubeadm

## Notes

- SSH into the worker node:
  ssh node01

- Ensure the node becomes Ready

- comandi utili
- apt list --installed|grep -i kube
- sudo apt-cache madison kubeadm
- sudo apt-get update && sudo apt-get install -y kubeadm='1.35.1-1.1' kubectl='1
.35.1-1.1' kubelet='1.35.1-1.1'
sudo apt-mark hold kubeadm

sudo kubeadm token create  --print-join-command  

sudo apt-get install -y kubeadm='1.35.1-1.1'  kubelet='1.35.1-1.1' --allow-change-held-packages 
  
  kubeadm version
  sudo kubeadm upgrade plan

  
