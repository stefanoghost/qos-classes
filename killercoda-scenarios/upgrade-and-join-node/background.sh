#!/bin/bash

echo "Setting up scenario..."

ssh node01 << EOF
sudo apt-get update -y
sudo apt-get install -y kubelet=1.33.5-1.1 kubectl=1.33.5-1.1 || true
sudo systemctl daemon-reexec
sudo systemctl restart kubelet || true
EOF

ssh node01 << EOF
sudo kubeadm reset -f
EOF

echo "Scenario ready"
