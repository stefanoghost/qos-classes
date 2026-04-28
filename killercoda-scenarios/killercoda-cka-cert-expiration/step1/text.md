# Task

Perform the following tasks on the Kubernetes control-plane node.

## Requirements

1. Check how long the `kube-apiserver` server certificate is valid using `openssl` or `cfssl`.

   Write only the certificate expiration date into:

   ```bash
   /opt/course/14/expiration
   ```

   The expected format is the OpenSSL `notAfter` date format, for example:

   ```text
   Oct 29 14:19:27 2025 GMT
   ```

2. Use `kubeadm` to list certificate expiration dates and confirm that the `kube-apiserver` expiration shown by `kubeadm` matches the date found with `openssl` or `cfssl`.

3. Write the `kubeadm` command that would renew the `kube-apiserver` certificate into:

   ```bash
   /opt/course/14/kubeadm-renew-certs.sh
   ```

## Notes

- Do not actually renew the certificate.
- The renewal file should contain the command only.
- You may need root privileges to read files under `/etc/kubernetes/pki`.
