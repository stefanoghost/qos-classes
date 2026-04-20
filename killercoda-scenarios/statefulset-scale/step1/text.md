# Task

Nel namespace `project-h800` ci sono due Pod chiamati:
o3db-0
o3db-1
## Obiettivo

Riduci il numero di repliche a **1**

## Attenzione

- I Pod NON sono gestiti da un Deployment
- Devi identificare il tipo corretto di risorsa

## Comandi utili

```bash
kubectl get pod -n project-h800
kubectl get deploy,ds,sts -n project-h800
kubectl describe pod -n project-h800
