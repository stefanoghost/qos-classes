
## `foreground.sh`

Solo messaggi puliti. Killercoda documenta l’uso separato di `background` e `foreground`; il lavoro pesante conviene farlo nel background. :contentReference[oaicite:2]{index=2}

```bash
#!/bin/bash
while [ ! -f /root/.kube/multi-config ]; do
  sleep 1
done

echo "Scenario pronto."
echo "Usa: export KUBECONFIG=/root/.kube/multi-config"
echo "Poi controlla i context e completa il task dello step."
