# Obiettivo

In questo scenario vedrai come Kubernetes assegna una **QoS class** ai Pod in base a `requests` e `limits`.

Creerai 3 deployment:

- **Guaranteed** → requests = limits
- **Burstable** → requests e limits diversi
- **BestEffort** → nessuna request e nessun limit

## Cosa imparerai

- come definire `resources.requests` e `resources.limits`
- come verificare la QoS class di un Pod
- perché i Pod `BestEffort` sono più vulnerabili sotto pressione risorse

## Nota importante

In caso di pressione sul nodo, Kubernetes non usa **solo** la QoS class per decidere le eviction: considera anche il consumo rispetto alle `requests` e la `Priority`.  
Tuttavia, come comportamento atteso:

- `BestEffort` tende a essere colpito per primo
- `Burstable` dopo
- `Guaranteed` per ultimo

## Task

1. Controlla i manifest nella directory `manifests/`
2. Applica i 3 deployment
3. Verifica la QoS class dei Pod
4. Esegui lo script di verifica finale

## Comandi utili

```bash
kubectl get deploy
kubectl get pods -o wide
kubectl describe pod <nome-pod> | grep -i "QoS Class"
