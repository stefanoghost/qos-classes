# Task

Configura l'applicazione api-gateway usando Kustomize.

Directory:

/opt/course/5/api-gateway


## Devi fare:

1. Rimuovere completamente il ConfigMap `horizontal-scaling-config`
2. Aggiungere un HPA:
   - nome: api-gateway
   - target: Deployment api-gateway
   - minReplicas: 2
   - maxReplicas: 4
   - CPU: 50%
3. In prod:
   - maxReplicas: 6
4. Applicare le modifiche:

kubectl kustomize staging | kubectl apply -f -
kubectl kustomize prod | kubectl apply -f -


## Hint importanti

- modifica la base
- usa patch per prod
- controlla output con:


kubectl kustomize staging
kubectl kustomize prod

## ricordati di creare i namespace nei vari overlays

cat staging/kustomization.yaml 
resources:
- ../base
- namespace.yaml
patches:
- path: patch.yaml
namespace: api-gateway-staging

cat staging/namespace.yaml 
apiVersion: v1
kind: Namespace
metadata:
  name: api-gateway-staging
