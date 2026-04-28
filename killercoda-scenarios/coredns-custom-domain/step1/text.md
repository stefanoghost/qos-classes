# Question 16: Update CoreDNS Configuration

The CoreDNS configuration needs to be updated.

## Tasks

### 1. Backup

Backup the CoreDNS ConfigMap to:

```bash
/opt/course/16/coredns_backup.yaml
2. Update CoreDNS

Modify the CoreDNS configuration so that:

SERVICE.NAMESPACE.custom-domain

works like:

SERVICE.NAMESPACE.cluster.local
Hint

Edit the CoreDNS ConfigMap:

kubectl -n kube-system edit configmap coredns

Find this line:

kubernetes cluster.local in-addr.arpa ip6.arpa

Change it to:

kubernetes custom-domain cluster.local in-addr.arpa ip6.arpa
3. Restart CoreDNS
kubectl -n kube-system rollout restart deployment coredns
4. Test
kubectl exec -it bb -- nslookup kubernetes.default.svc.cluster.local
kubectl exec -it bb -- nslookup kubernetes.default.svc.custom-domain

Both should return an IP.
