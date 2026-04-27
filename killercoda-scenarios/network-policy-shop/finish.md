# Scenario Completed

Well done.

You implemented namespace-level network isolation using Kubernetes NetworkPolicies.

## What you practiced

- podSelector
- ingress rules
- source pod selectors
- port-based traffic restrictions

## Key concept

NetworkPolicies are applied to destination pods.

The `podSelector` selects the pods protected by the policy.

The `from` field selects who is allowed to connect.
