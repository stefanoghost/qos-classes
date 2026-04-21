# Task

Create a Kubernetes user named **stefano** authenticated with a client certificate.

## Requirements

1. Generate a private key named `stefano.key`
2. Create a CSR named `stefano.csr`
3. The certificate subject must include:
   - `CN=stefano`
   - `O=devs`
4. Sign the CSR with the cluster CA:
   - CA certificate: `/etc/kubernetes/pki/ca.crt`
   - CA key: `/etc/kubernetes/pki/ca.key`
5. Create a signed certificate named `stefano.crt`
6. Add kubeconfig credentials for user `stefano`
7. Create a context named `stefano-context` using:
   - cluster: `kubernetes`
   - user: `stefano`
   - namespace: `default`
8. Grant user `stefano` the `view` ClusterRole
9. Ensure the user can list pods in the `default` namespace
10. Ensure the user cannot create deployments in the `default` namespace

## Important note

In a more Kubernetes-native workflow, client certificates are commonly handled through a Kubernetes **CertificateSigningRequest** object and approved through the API.

For this lab, however, use **OpenSSL** to generate and sign the certificate **for didactic purposes**, so that you fully understand the certificate creation flow from scratch.

## Suggested OpenSSL workflow

```bash
openssl genrsa -out stefano.key 2048

openssl req -new -key stefano.key \
  -out stefano.csr \
  -subj "/CN=stefano/O=devs"

openssl x509 -req \
  -in stefano.csr \
  -CA /etc/kubernetes/pki/ca.crt \
  -CAkey /etc/kubernetes/pki/ca.key \
  -CAcreateserial \
  -out stefano.crt \
  -days 365

Configure kubeconfig
kubectl config set-credentials stefano \
  --client-certificate=stefano.crt \
  --client-key=stefano.key

kubectl config set-context stefano-context \
  --cluster=kubernetes \
  --user=stefano \
  --namespace=default


Grant access
kubectl create clusterrolebinding stefano-view \
  --clusterrole=view \
  --user=stefano

Validate permissions
kubectl auth can-i get pods --as=stefano -n default
kubectl auth can-i create deployments --as=stefano -n default

Kubernetes CSR reference

The following is a Kubernetes-native reference flow for CSR handling.
You do not need to use this path to complete the lab, but you should be familiar with it.

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: stefano-certificate
spec:
  request: $(cat stefano.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF
kubectl describe csr stefano-certificate
kubectl certificate approve stefano-certificate
Notes
Work on the control-plane node
You may use kubectl and openssl
You do not need to switch permanently away from the admin context to complete the task


