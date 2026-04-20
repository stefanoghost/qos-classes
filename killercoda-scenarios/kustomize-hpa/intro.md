# Kustomize + HPA (Scenario CKA)

In questo scenario lavorerai con **Kustomize**, uno strumento integrato in `kubectl` per gestire configurazioni Kubernetes.

## Contesto

L'applicazione `api-gateway` è deployata in due ambienti:

- staging → `api-gateway-staging`
- prod → `api-gateway-prod`

La configurazione si trova in:
/opt/course/5/api-gateway


Struttura:


base/ → configurazione comune
staging/ → overlay staging
prod/ → overlay produzione


---

## Situazione attuale

- Esiste un ConfigMap chiamato:

horizontal-scaling-config

- Questo rappresenta un vecchio autoscaler (da rimuovere)

---

## Obiettivo

Devi:

1. Eliminare completamente il ConfigMap
2. Aggiungere un **HorizontalPodAutoscaler (HPA)**
3. Gestire differenze tra staging e prod

---

## Comandi utili

Costruire YAML:


kubectl kustomize staging
kubectl kustomize prod


Applicare:


kubectl kustomize staging | kubectl apply -f -
kubectl kustomize prod | kubectl apply -f -


---

## ⚠️ Consiglio da esame

NON applicare subito.

Prima guarda sempre:


kubectl kustomize staging


Capisci cosa succede, poi modifica.

---

Buon lavoro 💪
