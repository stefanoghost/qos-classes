# 🎉 Scenario Completed

Well done!

You successfully:

- Identified a node not part of the cluster
- Upgraded Kubernetes components to match the control-plane
- Joined the node to the cluster using kubeadm
- Verified the node is in **Ready** state

## What you practiced

- kubeadm join workflow
- Version alignment (kubelet / kubectl)
- Node troubleshooting

## Tip for the CKA exam

If a node is **not yet part of the cluster**, do NOT use:

kubeadm upgrade node ❌

Instead:
- Upgrade packages
- Then run kubeadm join ✅

---

Keep practicing — this is a very common exam scenario 💥
