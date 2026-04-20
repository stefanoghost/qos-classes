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

kubectl --kubeconfig /root/.kube/multi-config config get-contexts
export KUBECONFIG=/root/.kube/multi-config
kubectl config get-contexts -o name > contextname.txt
kubectl --kubeconfig /opt/course/1/kubeconfig config view -o yaml
kubectl --kubeconfig /opt/course/1/kubeconfig config view -o jsonpath="{.contexts[*].name}"
kubectl config current-context
kubectl config view
kubectl config view --minify
kubectl --kubeconfig /root/.kube/multi-config config view -o yaml --raw
echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN2RE... | base64 -d > /opt/course/1/cert
kubectl --kubeconfig  /root/.kube/multi-config config view --raw -ojsonpath="{.users[0].user.client-certificate-data}" | base64 -d > 

