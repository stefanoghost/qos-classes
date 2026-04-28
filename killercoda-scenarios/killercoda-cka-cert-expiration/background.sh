#!/bin/bash
set -euo pipefail

# Prepare directory used by the task.
mkdir -p /opt/course/14
rm -f /opt/course/14/expiration /opt/course/14/kubeadm-renew-certs.sh

# Make sure Kubernetes static pod manifests and certificates exist.
# Killercoda kubeadm images usually have these ready, but wait defensively.
for i in {1..60}; do
  if [ -f /etc/kubernetes/pki/apiserver.crt ] && command -v kubeadm >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

if [ ! -f /etc/kubernetes/pki/apiserver.crt ]; then
  echo "ERROR: /etc/kubernetes/pki/apiserver.crt not found" >&2
  exit 1
fi

# Create a small marker file for visibility/debugging.
cat >/opt/course/14/README <<'README'
Task files to create:
- /opt/course/14/expiration
- /opt/course/14/kubeadm-renew-certs.sh
README

chmod 755 /opt/course/14
