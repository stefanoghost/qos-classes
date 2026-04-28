# Question 11: DaemonSet on all Nodes

Use namespace:

```text
project-tiger
Task

Create a DaemonSet named:

ds-important
Requirements

The DaemonSet must use:

image: httpd:2-alpine
label: id=ds-important
label: uuid=18426a0b-5f59-4e10-923f-c0e078e82462

The Pods created by the DaemonSet must request:

CPU: 10m
memory: 10Mi

The Pods must run on:

all worker nodes
control-plane nodes as well
Important hint

Control-plane nodes usually have this taint:

node-role.kubernetes.io/control-plane:NoSchedule

Your DaemonSet Pod template needs a toleration for it.

Example toleration
tolerations:
- key: node-role.kubernetes.io/control-plane
  effect: NoSchedule
Verify
kubectl get ds -n project-tiger
kubectl get pods -n project-tiger -l id=ds-important -o wide
kubectl describe ds ds-important -n project-tiger
