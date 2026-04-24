# Step 3: Understand Endpoints

In this step you will explore how a Service connects to Pods.

## Task

Inspect the relationship between the Service and the Pods.

## Requirements

1. Check the Endpoints of the Service `web-clusterip`
2. Verify that the Endpoints match the Pods IPs
3. Identify how the Service selects the Pods

## Useful commands

```bash
kubectl get endpoints -n services
kubectl get endpoints web-clusterip -n services -o wide

Check Pod IPs:

kubectl get pods -n services -o wide
Questions to answer
Which Pods are behind the Service?
How does Kubernetes know which Pods to use?
What label is used?
Hint

Look at:

kubectl get svc web-clusterip -n services -o yaml
