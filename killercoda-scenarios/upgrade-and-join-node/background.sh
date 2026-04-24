#!/bin/bash
set -euxo pipefail

echo "Setting up scenario..."

until ssh -o StrictHostKeyChecking=no node01 "echo node01-ready"; do
  sleep 2
done

ssh node01 << 'EOF'
set -euxo pipefail

sudo apt-get update -y

apt-cache madison kubeadm
apt-cache madison kubelet
apt-cache madison kubectl

sudo kubeadm reset -f || true

sudo apt-get install -y \
  kubeadm=1.35.0-1.1 \
  kubelet=1.35.0-1.1 \
  kubectl=1.35.0-1.1 \
  --allow-downgrades

sudo apt-mark hold kubeadm kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet || true

kubeadm version
kubelet --version
kubectl version --client
EOF

echo "Scenario ready"
