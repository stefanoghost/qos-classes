```markdown
# Build the production overlay

## Introduction

The staging environment is now fixed.

Your next task is to prepare the **production** overlay.

This environment will run in the same cluster, so resource names must not collide with staging.

---

## Task

Update the 'prod' overlay so that:

1. all resources are deployed in the namespace 'api-gateway-prod'
2. all resource names use the prefix 'prod-'
3. all production resources include the label 'env=prod'
4. all production resources include the annotation 'owner=team-platform'
5. the container image is changed from 'nginx' to 'nginx:1.25'
6. the production overlay can be successfully applied
7. the Service has valid endpoints

Prefer **Kustomize transformers** over manual patches.

---

## Useful commands

```bash
kubectl kustomize prod
kubectl kustomize prod | kubectl apply -f -
kubectl get all -n api-gateway-prod
kubectl get deploy -n api-gateway-prod
kubectl get svc -n api-gateway-prod
kubectl get endpoints -n api-gateway-prod
kubectl get deploy prod-api-gateway -n api-gateway-prod -o yaml
kubectl get deploy prod-api-gateway -n api-gateway-prod -o jsonpath='{.spec.template.spec.containers[0].image}'; echo
kubectl get deploy prod-api-gateway -n api-gateway-prod -o jsonpath='{.metadata.annotations.owner}'; echo
kubectl get pods -n api-gateway-prod --show-labels
Hint

Kustomize has built-in transformers for:

namespace
labels
name prefix
annotations
image replacement



Be careful: labels can affect selectors, so make sure the Service still reaches the Pods.
