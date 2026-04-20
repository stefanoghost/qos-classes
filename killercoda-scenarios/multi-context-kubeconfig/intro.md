# Obiettivo

In questo scenario lavorerai con un file kubeconfig contenente più context.

Imparerai a:

- elencare i context con `kubectl config get-contexts`
- identificare il context corrente
- leggere i dettagli del kubeconfig
- estrarre il certificato client di un utente dal kubeconfig
- decodificarlo e salvarlo in un file PEM

## Ambiente

Il kubeconfig da usare è:

```bash
export KUBECONFIG=/root/.kube/multi-config
