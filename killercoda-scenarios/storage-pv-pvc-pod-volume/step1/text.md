# Question 6: Storage, PV, PVC, Pod Volume

Create static storage and mount it into a Deployment.

## Tasks

### 1. Create PersistentVolume

Create a PersistentVolume named:

```text
safari-pv

Requirements:

capacity: 2Gi
access mode: ReadWriteOnce
hostPath: /Volumes/Data
do not define storageClassName
2. Create PersistentVolumeClaim

Create a PersistentVolumeClaim in namespace:

project-t230

PVC name:

safari-pvc

Requirements:

request: 2Gi
access mode: ReadWriteOnce
do not define storageClassName
it should bind to safari-pv
3. Create Deployment

Create a Deployment in namespace:

project-t230

Deployment name:

safari

Requirements:

image: httpd:2-alpine
mount the PVC at:
/tmp/safari-data
Example PV
apiVersion: v1
kind: PersistentVolume
metadata:
  name: safari-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /Volumes/Data
Example PVC
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: safari-pvc
  namespace: project-t230
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
Deployment mount hint
volumes:
- name: data
  persistentVolumeClaim:
    claimName: safari-pvc
volumeMounts:
- name: data
  mountPath: /tmp/safari-data
Verify
kubectl get pv
kubectl get pvc -n project-t230
kubectl get deploy,pod -n project-t230
kubectl describe pod -n project-t230 -l app=safari




Nota importante: se nel cluster c’è una default StorageClass, il PVC potrebbe ricevere automaticamente storageClassName. In questo scenario il verify richiede che non sia definita; se il cluster la imposta comunque, usa esplicitamente:


storageClassName: ""
sia nel PV che nel PVC.
