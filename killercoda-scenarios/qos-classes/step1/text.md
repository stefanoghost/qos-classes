# Task

1. Applica i manifest presenti in `/root/scenario/manifests`
2. Verifica che i Pod abbiano le corrette QoS classes:
   - `guaranteed-deploy` → `Guaranteed`
   - `burstable-deploy` → `Burstable`
   - `besteffort-deploy` → `BestEffort`

## Comandi utili

```bash
kubectl apply -f /root/scenario/manifests/
kubectl get pods
kubectl get pod -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass
