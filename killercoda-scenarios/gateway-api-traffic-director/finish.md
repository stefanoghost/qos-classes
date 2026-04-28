# Scenario Completed

Great job.

You successfully:

- migrated Ingress → HTTPRoute
- implemented path-based routing
- used header matching
- handled fallback logic

## Key concept

Gateway API rules are evaluated in order.

Header + path inside same match = AND  
Multiple matches = OR
