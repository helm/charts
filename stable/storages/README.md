# storages

This chart is used to apply pv and pvc. You can specify any number of pv and pvc. This chart can come in handy when a public chart does not offer additional pv and pvc. You have to use the following format to specify pv and pvc:

```yaml
Volumes:
- name: storage-volume
  annotations: {}
  labels:
    app: appname
  accessModes:
  - ReadWriteOnce
  storage: 10Gi
  nfs:
    server: fs-blabla.efs.eu-west-1.amazonaws.com
    path: /home/storage

Claims:
- name: storage-volume-claim
  annotations: {}
  storageClassName: efs
  storage: 10Gi
  volumeName: storage-volume
  labels:
    app: appname
  accessModes:
  - ReadWriteOnce
```

For installing the chart, run the following command:

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/storages -f values.yaml --namespace <namespace-name>
```

## Usage

The following quickstart let's you set up secret:

1. Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| Volumes.name          | name of the volume                                                      | `test`                        | `storage-volume`                        |
| Volumes.annotations          | annotations for volume                                                       | ``                        | `{}`                        |
| Volumes.accessModes          | accessModes of the volume                                                      | `ReadWriteOnce`                        | `ReadWriteOnce`                        |
| Volumes.labels          | label for volume                                                      | `app: app-name`                        | `app: app-name`                        |
| Volumes.storage          | storage size for volume                                                      | `8Gi`                        | `8Gi`                        |
| Volumes.claimRef.name          | Name of claim reference                                                      | `storage-data`                        | ``                        |
| Volumes.nfs.server          | server for volume                                                      | `fs-blabla.efs.eu-west-1.amazonaws.com`                        | `fs-blabla.efs.eu-west-1.amazonaws.com`                        |
| Volumes.nfs.path          | path for volume                                                      | `/home/storage`                        | `/home/storage`                        |
| Claims.name          | name of the claim                                                      | `storage-volume-claim`                        | `storage-volume-claim`                        |
| Claims.annotations          | annotations for claim                                                       | ``                        | `{}`                        |
| Claims.accessModes          | accessModes of the claim                                                      | `ReadWriteOnce`                        | `ReadWriteOnce`                        |
| Claims.labels          | label for claim                                                      | `app: app-name`                        | `app: app-name`                        |
| Claims.storage          | storage size for claim                                                      | `8Gi`                        | `8Gi`                        |
| Claims.storageClassName          | storageClass name for claim                                                      | `efs`                        | `efs`                        |
| Claims.volumeName          | volume name for claim                                                      | `storage-volume`                        | `storage-volume`                        |

## Example

Storages chart is used to create persistent volumes and persistent volume claims for other charts which does not support creation of additional volumes and claims.
For example, we need additional storage for [jenkins](https://github.com/helm/charts/tree/master/stable/jenkins) chart but there is no support for creation of additional PV and PVCs. Below are the steps, that explain how to achieve this using storages chart.

- Update the `values.yaml` file to create a persistent volume claim. 

```yaml
Claims:
- name: jenkins-mvn-local-repo
  annotations:
    volume.beta.kubernetes.io/storage-class: efs
    helm.sh/resource-policy: keep
  storage: 8Gi
  # if you speicify storageClassName then volumeName is ignored and claim is made with storageClass instead of volume
  storageClassName: "efs"
  # volumeName: storage-volume
  labels:
    app: jenkins
  accessModes:
  - ReadWriteOnce
```

- Deploy the storages chart. This will create a persistent volume claim with name `jenkins-mvn-local-repo` having 8Gi of storage.
- Now, to mount this PVC in jenkins, update the [values.yaml](https://github.com/helm/charts/blob/master/stable/jenkins/values.yaml) in jenkins chart. We need to update the [volumes](https://github.com/helm/charts/blob/master/stable/jenkins/values.yaml#L203) and [mounts](https://github.com/helm/charts/blob/master/stable/jenkins/values.yaml#L206) under [Persistence](https://github.com/helm/charts/blob/master/stable/jenkins/values.yaml#L184)

```yaml
  volumes:
  - name: jenkins-mvn-local-repo
    persistentVolumeClaim:
      claimName: jenkins-mvn-local-repo
  mounts:
  - mountPath: /mvn-data
    name: jenkins-mvn-local-repo
```

- Deploy the [jenkins](https://github.com/helm/charts/tree/master/stable/jenkins) chart and we can see the additional PVC `jenkins-mvn-local-repo` mounted on path `/mvn-data`.