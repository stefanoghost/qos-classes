# Task

Create and use Kubernetes namespaces.

Perform the following actions:

1. Create three namespaces:

   - `dev`
   - `test`
   - `production`

2. In namespace `dev`, create a Pod named:

   - `web-dev`

   using image:

   - `nginx:1.25`

3. The Pod `web-dev` must have the label:

   - `app=web`

4. In namespace `production`, create a Pod named:

   - `web-prod`

   using image:

   - `nginx:1.25`

5. The Pod `web-prod` must have the label:

   - `app=web`

6. In namespace `production`, create a Service named:

   - `web-prod-svc`

   The Service must expose the Pod `web-prod` on port `80`.

7. Do not create any Pod named `web-dev` or `web-prod` in the `default` namespace.

You may use imperative commands or YAML manifests.
