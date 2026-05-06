# CKA Practice - Manual Scheduling

In this scenario you will practice **manual scheduling**.

Normally, the Kubernetes scheduler assigns Pods to Nodes automatically.

However, for the CKA exam, you may be asked to manually assign a Pod to a specific Node by setting:

```yaml
spec:
  nodeName: <node-name>
