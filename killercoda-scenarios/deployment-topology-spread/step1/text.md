# Question 12: Deployment on all Nodes

Create a Deployment with strict scheduling requirements.

---

## Requirements

- Namespace: `project-tiger`
- Name: `deploy-important`
- Replicas: `3`

---

## Labels

Deployment and Pods must have:

```yaml
id: very-important
Containers
Container 1
name: container1
image: nginx:1-alpine
Container 2
name: container2
image: google/pause
Scheduling Constraint

👉 Only ONE pod per node

Use:

topologyKey: kubernetes.io/hostname
Expected Behavior
2 nodes available
3 replicas requested

👉 Result:

2 Running Pods
1 Pending Pod
Hint (choose one)
Option 1 (recommended)
topologySpreadConstraints
Option 2
podAntiAffinity
Verify
kubectl get pods -n project-tiger -o wide

👉 You should see:

pods on different nodes
one pod Pending
