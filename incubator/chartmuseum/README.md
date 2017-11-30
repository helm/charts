# ChartMuseum Helm Chart

Deploy your own private ChartMuseum.   

Please also see https://github.com/chartmuseum/chartmuseum   

## Prerequisites

* Kubernetes with extensions/v1beta1 available
* [If enabled] A persistent storage resource and RW access to it
* [If enabled] Kubernetes StorageClass for dynamic provisioning

## Configuration

By default this chart will not have persistent storage.   

For a more robust solution supply helm install with a custom values.yaml   
You are also required to create the StorageClass resource ahead of time:   
```
kubectl create -f /path/to/storage_class.yaml
```

TODO: Configuration table   

## Installation

```shell
helm install --name my-chartmuseum -f values.yaml incubator/chartmuseum
```

## Uninstall 

By default, a deliberate uninstall will result in the persistent volume 
claim being deleted.   

```shell
helm delete my-chartmuseum
```

## Example storage

Example storage-class.yaml provided here for use with a Ceph cluster.   

kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: storage-volume
provisioner: kubernetes.io/rbd
parameters:
  monitors: "10.11.12.13:4567,10.11.12.14:4567"
  adminId: admin
  adminSecretName: thesecret
  adminSecretNamespace: default
  pool: chartstore
  userId: user
  userSecretName: thesecret 

