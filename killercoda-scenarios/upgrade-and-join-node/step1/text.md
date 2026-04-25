# Question: Upgrade Kubernetes Version and Join Cluster

A node called **node01** is not part of the cluster and is running an older Kubernetes version.

## Tasks

1. Upgrade the Kubernetes version on node01 to match the control-plane
2. Join node01 to the cluster using kubeadm

## Notes

- SSH into the worker node:
  ssh node01

- Ensure the node becomes Ready

- comandi utili
- 
- apt list --installed|grep -i kube
- 
- sudo apt-cache madison kubeadm
- 
- sudo apt-get update && sudo apt-get install -y kubeadm='1.35.1-1.1' kubectl='1
.35.1-1.1' kubelet='1.35.1-1.1' 
  
sudo apt-mark hold kubeadm

sudo kubeadm token create  --print-join-command  

sudo apt-get install -y kubeadm='1.35.1-1.1'  kubelet='1.35.1-1.1' --allow-change-held-packages 

kubeadm upgrade node

sul control plane
sudo kubeadm token create --print-join-command
sul nodo
kubeadm join 172.30.1.2:6443 --token lqmmkz.rlmo51wy5qqqypj7 --discovery-token-ca-cert-hash  sha256:7976ccc24f182dff3daa92b705003b8a135e97e20f03baf0a17757076f5b8389  

kubeadm upgrade node

  
kubeadm version
  
sudo apt-get update && sudo apt-get install -y kubeadm='1.35.4-1.1' 

sudo kubeadm upgrade plan
   kubeadm upgrade apply v1.35.4 
   kubectl version
   apt-get install -y --allow-change-held-packages kubectl=1.35.4-1.1

   sul nodo 01
   
   kubeadm join 172.30.1.2:6443 --token lqmmkz.rlmo51wy5qqqypj7 --discovery-token-ca-cert-hash sha256:7976ccc24f182dff3daa92b705003b8a135e97e20f03baf0a17757076f5b8389  

   da controlplane
   scp /etc/kubernetes/admin.conf root@node01:/root/.kube/config


   sudo apt-get install -y kubelet='1.35.4-1.1'  kubectl='1.35.4-1.1'   --allow-change-held-packages 
   
   sudo apt-get install -y kubeadm='1.35.4-1.1'   --allow-change-held-packages


   kubeadm upgrade apply <versione>

👉 Questo è il comando principale

🟢 Worker Node

Sul worker (o anche control plane DOPO apply):

kubeadm upgrade node

👉 Ma solo dopo aver aggiornato i pacchetti

🧠 Procedura corretta (importantissima per CKA)
1. Sul control plane
kubeadm upgrade plan
kubeadm upgrade apply v1.X.X

Poi:

apt-get install -y kubelet=VERSION kubectl=VERSION
systemctl restart kubelet
2. Su ogni nodo (worker o control plane secondari)
kubectl drain <node> --ignore-daemonsets

Poi sul nodo:

apt-get install -y kubelet=VERSION kubeadm=VERSION
kubeadm upgrade node
systemctl restart kubelet

Infine:

kubectl uncordon <node>
❗ Errore tipico

Molti pensano:

kubeadm upgrade node

👉 faccia tutto → ❌ NO

Se non aggiorni i pacchetti (kubelet, kubeadm)
→ rischi mismatch di versioni → cluster instabile

   

   

  
