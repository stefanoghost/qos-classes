
---

# 3) `finish.md`

```md
# Complimenti

Hai creato tre tipi di workload con diverse policy di risorse:

- **Guaranteed**
- **Burstable**
- **BestEffort**

## Concetti chiave

- Un Pod è **Guaranteed** quando tutti i container hanno CPU e memoria con `requests = limits`
- Un Pod è **Burstable** quando esiste almeno una request o un limit, ma non tutti sono uguali
- Un Pod è **BestEffort** quando non esistono request e limit per CPU e memoria

## Perché conta

Sotto pressione memoria/CPU sul nodo:

- i Pod `BestEffort` sono i più vulnerabili
- i Pod `Burstable` stanno nel mezzo
- i Pod `Guaranteed` sono i più protetti

## Verifica finale

```bash
kubectl get pods
kubectl describe pod <pod-name> | grep -i "QoS Class"
