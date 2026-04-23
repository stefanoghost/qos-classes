# Fix the staging overlay

## Introduction

You are working as a platform engineer.

An application called `api-gateway` 
must be deployed in multiple environments using **Kustomize overlays**.

The base manifests already exist, but the overlays are not fully working yet.

Your first task is to fix the **staging** environment.

---

## Background

Move to the working directory:

```bash
cd /opt/course/6/api-gateway
find --
ou should find:

.
├── base
│   ├── deployment.yaml
│   ├── kustomization.yaml
│   └── service.yaml
├── prod
│   └── kustomization.yaml
└── staging
    └── kustomization.yaml

The base folder contains reusable
manifests.

The staging overlay already includes
 some Kustomize configuration, but
deployment currently fails.

You should prefer Kustomize
transformers where possible.

Task

Fix the staging overlay so that:

the namespace api-gateway-staging
 exists
all resources are deployed into
that namespace
all staging resources include
the label env=staging
the application runs successfully
the Service still matches the Pods

Do not change the base unless absolutely
necessary.

Useful commands
kubectl kustomize staging
kubectl kustomize staging | kubectl apply -f -
kubectl get all -n api-gateway-staging
kubectl get pods -n api-gateway-staging --show-labels
kubectl get endpoints -n api-gateway-staging
