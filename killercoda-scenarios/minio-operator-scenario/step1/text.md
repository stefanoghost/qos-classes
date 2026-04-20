# Task

Completa le seguenti operazioni:

1. Crea il namespace `minio`
2. Installa Helm chart `minio/operator` nel namespace minio
   - nome release: `minio-operator`
3. Modifica il file:
   /opt/course/2/minio-tenant.yaml

   Aggiungi:

   enableSFTP: true

   sotto:

   spec.features

4. Applica il file YAML

## Comandi utili

```bash
helm search repo minio/operator
helm repo add minio-operator  http://localhost:6000
helm -n minio install minio-operator minio-operator/operator
helm -n minio ls
kubectl -n minio get pod
kubectl get crd
kubectl describe crd tenants.minio.min.io
vim /opt/course/2/minio-tenant.yaml

