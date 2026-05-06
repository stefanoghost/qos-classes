# Task

A worker node has been tainted with:

```bash
dedicated=database:NoSchedule

The tainted node name is available in:

/root/tainted-node.txt

A Pod manifest already exists at:

/root/db-pod.yaml

The Pod is named:

database-pod

The Pod currently cannot run successfully because the target node is tainted.

Your task is to:

1) Edit the Pod manifest
2) Add the required toleration
3) Create the Pod
4) Ensure the Pod reaches Running state on the tainted node

Requirements:

Do not remove the taint from the node
Do not modify the Pod name
Do not modify the namespace
Do not modify the image
Do not create additional Pods

Useful commands:

kubectl describe node <node-name>
kubectl describe pod database-pod -n taint-lab
kubectl get pod -n taint-lab -o wide
