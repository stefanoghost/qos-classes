# Killercoda Scenario: Fix the Broken Kustomize Overlays

This scenario teaches Kustomize transformers through a realistic multi-environment deployment.

Concepts covered:

- namespace
- commonLabels
- namePrefix
- commonAnnotations
- images

The learner must fix:

- a broken staging deployment
- an incomplete production overlay

The production step also requires adding:

- `commonLabels: env=prod`

and verifying that the Service still has valid endpoints.
