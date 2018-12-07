# storages

This chart is used to apply pv and pvc. You can specify any number of pv and pvc. This chart can come in handy when a public chart does not offer additional pv and pvc. You have to use the following format to specify pv and pvc:

```bash
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
| Volumes.storage          | storage size for volume                                                      | `10Gi`                        | `10Gi`                        |
| Volumes.nfs.server          | server for volume                                                      | `fs-blabla.efs.eu-west-1.amazonaws.com`                        | `fs-blabla.efs.eu-west-1.amazonaws.com`                        |
| Volumes.nfs.path          | path for volume                                                      | `/home/storage`                        | `/home/storage`                        |
| Claims.name          | name of the claim                                                      | `storage-volume-claim`                        | `storage-volume-claim`                        |
| Claims.annotations          | annotations for claim                                                       | ``                        | `{}`                        |
| Claims.accessModes          | accessModes of the claim                                                      | `ReadWriteOnce`                        | `ReadWriteOnce`                        |
| Claims.labels          | label for claim                                                      | `app: app-name`                        | `app: app-name`                        |
| Claims.storage          | storage size for claim                                                      | `10Gi`                        | `10Gi`                        |
| Claims.storageClassName          | storageClass name for claim                                                      | `efs`                        | `efs`                        |
| Claims.volumeName          | volume name for claim                                                      | `storage-volume`                        | `storage-volume`                        |