# Scenario Completed

Nice work.

You debugged a broken Helm deployment.

## What you used

- helm list
- helm get values
- helm get manifest
- kubectl describe

## Key insight

Helm may install successfully even if the workload is broken.

Always verify:
- pod status
- values
- rendered manifests
