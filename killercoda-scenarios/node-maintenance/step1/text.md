# Question 3: Node Maintenance

Node **node01** needs maintenance and will be offline for 1 hour.

Currently:

- A **database pod** is running on this node (uses local storage)
- A **deployment with 3 replicas** is running

## Your tasks

1. Prepare the node for maintenance
2. Ensure workloads are safely handled
3. Do NOT lose critical pod data

## Requirements

- Prevent new pods from scheduling on the node
- Evict existing pods safely
- Handle DaemonSets correctly
- Handle pods with local storage

## Verify

- Node should be marked as **SchedulingDisabled**
- Pods should be safely rescheduled (except constrained ones)

## Useful commands

```bash
kubectl cordon node01

kubectl drain node01   --ignore-daemonsets   --pod-selector='app!=database'

kubectl drain node01 \
  --ignore-daemonsets \
  --delete-emptydir-data  #se lo lancu distrugge il pod database
Notes
cordon prevents scheduling
drain evicts pods
DaemonSets require --ignore-daemonsets
Local storage requires --delete-emptydir-data
