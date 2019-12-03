# A Helm chart for three-nodes zookeeper cluster
This is a helm chart for three-node zookeeper cluster which uses localPv to store data. 
## Before you use this chart, please make sure 3 pv has been created.
Following is an example of creating locaPv：
#### Use the following yaml file to create storageClass
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage 
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```
### Label certain  nodes and create paths on these nodes for pv to use
```
kubectl  label node k8s-node01 volume=zk00
kubectl  label node k8s-node02 volume=zk01
kubectl  label node k8s-node03 volume=zk02
# On k8s-node01
mkdir -p /data/k8sLocalPv/zk00
# On k8s-node02
mkdir -p /data/k8sLocalPv/zk01
# On k8s-node03
mkdir -p /data/k8sLocalPv/zk02
```
###  Use the following yaml file to create 3 pv
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-zk00
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: local-storage
  local:
    path: /data/k8sLocalPv/zk00
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: volume 
          operator: In
          values:
          - zk00
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-zk01
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: local-storage
  local:
    path: /data/k8sLocalPv/zk01
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: volume 
          operator: In
          values:
          - zk01
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-zk02
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: local-storage
  local:
    path: /data/k8sLocalPv/zk02
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: volume 
          operator: In
          values:
          - zk02
```
## After creating the pv according to the above steps, you can install zookeeper using this chart.
