# Pod Deployment Troubleshooting

In this scenario you need to troubleshoot a crashing pod in Kubernetes.

A pod named **app-frontend** in namespace **production** is stuck in **CrashLoopBackOff**.

The application expects a configuration file at:

`/etc/app/config.yaml`

That file is missing from the container image.

Your task is to fix the pod by providing the missing file through a ConfigMap and mounting it correctly.
