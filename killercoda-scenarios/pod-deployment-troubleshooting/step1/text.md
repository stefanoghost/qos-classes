# Question 1: Pod Deployment Troubleshooting

A pod named **app-frontend** in namespace **production** is stuck in **CrashLoopBackOff**.

The pod's container is looking for a configuration file at:

`/etc/app/config.yaml`

but this file does not exist in the image.

## You need to

1. Create a ConfigMap named **app-config** with the file content:

```yaml
database_host: postgres.production.svc.cluster.local

Mount this ConfigMap as a file at:

/etc/app/config.yaml

Verify the pod starts successfully
Notes
The pod manifest already exists; you only need to update it
Work in namespace production
You may use imperative commands or edit YAML directly
Useful commands

Create the ConfigMap:

echo 'database_host: postgres.production.svc.cluster.local' > config.yaml
kubectl create configmap app-config --from-file=config.yaml -n production

Inspect the pod:

kubectl get pod app-frontend -n production
kubectl describe pod app-frontend -n production
kubectl logs app-frontend -n production

Edit the pod:

kubectl edit pod app-frontend -n production

Remember that the pod needs:

a volume using the ConfigMap
a volumeMount in the container

After the fix, verify the file exists:

kubectl exec -n production app-frontend -- cat /etc/app/config.yaml


