# Task

A Pod manifest has been created at:

```bash
/root/manual-pod.yaml

The Pod is named:

manual-nginx

The namespace is:

manual-scheduling

The target Node name is stored in:

/root/target-node.txt

Your task is to manually schedule the Pod onto the target Node.

Requirements:

1) Edit /root/manual-pod.yaml
2) Add the correct spec.nodeName
3) Create the Pod
4) Ensure the Pod is running on the target Node
5) Do not use a Deployment
6) Do not change the Pod name
7) Do not change the namespace
8) Do not change the image

You can check the target node with:

cat /root/target-node.txt

You can create the Pod with:

kubectl apply -f /root/manual-pod.yaml
