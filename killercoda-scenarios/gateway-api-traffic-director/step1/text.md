# Question 13: Gateway API Traffic Director

You need to migrate an existing Ingress to Gateway API.

The old Ingress is here:

```bash
/opt/course/13/ingress.yaml
Tasks
1. Create HTTPRoute
Name: traffic-director
Namespace: project-r500
Attach to Gateway: main
Hostname: r500.gateway

Replicate these paths:

/desktop → web-desktop
/mobile → web-mobile
2. Add advanced routing

Add new path:

/auto

Routing logic:

If User-Agent: mobile → web-mobile
Otherwise → web-desktop
Important Rules
AND condition
path + header → SAME match
OR condition
multiple matches → OR
Order matters

Mobile rule MUST come before desktop

Expected behavior
curl r500.gateway:30080/desktop
curl r500.gateway:30080/mobile
curl -H "User-Agent: mobile" r500.gateway:30080/auto
curl r500.gateway:30080/auto
Hint

You need:

kind: HTTPRoute

with:

parentRefs:
- name: main
