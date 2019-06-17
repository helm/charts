# local-volume-provisioner

`local-volume-provisioner` is a program that manages the PersistentVolume lifecycle for 
pre-allocated disks by detecting and creating PVs for each local disk on the 
host, and cleaning up the disks when released. See
[sig-storage-local-static-provisioner](https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner) project for more information.

## Configurations

The following table lists the configurable parameters of the local volume
provisioner chart and their default values.

| Parameter                                    | Description                                                                                           | Type     | Default                                                    |
| ---                                          | ---                                                                                                   | ---      | ---                                                        |
| common.rbac                                  | Generating RBAC (Role Based Access Control) objects.                                                  | bool     | `true`                                                     |
| common.namespace                             | Namespace where provisioner runs.                                                                     | str      | `default`                                                  |
| common.createNamespace                       | Whether to create namespace for provisioner.                                                          | bool     | `false`                                                    |
| common.useAlphaAPI                           | If running against pre-1.10 k8s version, the `useAlphaAPI` flag must be enabled.                      | bool     | `false`                                                    |
| common.useJobForCleaning                     | If set to true, provisioner will use jobs-based block cleaning.                                       | bool     | `false`                                                    |
| common.useNodeNameOnly                       | If set to true, provisioner name will only use Node.Name and not Node.UID.                            | bool     | `false`                                                    |
| common.minResyncPeriod                       | Resync period in reflectors will be random between `minResyncPeriod` and `2*minResyncPeriod`.         | str      | `5m0s`                                                     |
| common.configMapName                         | Provisioner ConfigMap name.                                                                           | str      | `local-provisioner-config`                                 |
| common.podSecurityPolicy                     | Whether to create pod security policy or not.                                                         | bool     | `false`                                                    |
| classes.[n].name                             | StorageClass name.                                                                                    | str      | `-`                                                        |
| classes.[n].hostDir                          | Path on the host where local volumes of this storage class are mounted under.                         | str      | `-`                                                        |
| classes.[n].mountDir                         | Optionally specify mount path of local volumes. By default, we use same path as hostDir in container. | str      | `-`                                                        |
| classes.[n].blockCleanerCommand              | List of command and arguments of block cleaner command.                                               | list     | `-`                                                        |
| classes.[n].volumeMode                       | Optionally specify volume mode of created PersistentVolume object. By default, we use Filesystem.     | str      | `-`                                                        |
| classes.[n].fsType                           | Filesystem type to mount. Only applies when source is block while volume mode is Filesystem.          | str      | `-`                                                        |
| classes.[n].storageClass                     | Create storage class for this class and configure it optionally.                                      | bool/map | `false`                                                    |
| classes.[n].storageClass.reclaimPolicy       | Specify reclaimPolicy of storage class, available: Delete/Retain.                                     | str      | `Delete`                                                   |
| daemonset.name                               | Provisioner DaemonSet name.                                                                           | str      | `local-volume-provisioner`                                 |
| daemonset.image                              | Provisioner image.                                                                                    | str      | `quay.io/external_storage/local-volume-provisioner:v2.1.0` |
| daemonset.imagePullPolicy                    | Provisioner DaemonSet image pull policy.                                                              | str      | `-`                                                        |
| daemonset.serviceAccount                     | Provisioner DaemonSet service account.                                                                | str      | `local-storage-admin`                                      |
| daemonset.priorityClassName                  | Provisioner DaemonSet Pod Priority Class name.                                                        | str      | ``                                                         |
| daemonset.kubeConfigEnv                      | Specify the location of kubernetes config file.                                                       | str      | `-`                                                        |
| daemonset.nodeLabels                         | List of node labels to be copied to the PVs created by the provisioner.                               | list     | `-`                                                        |
| daemonset.nodeSelector                       | NodeSelector constraint on nodes eligible to run the provisioner.                                     | map      | `-`                                                        |
| daemonset.tolerations                        | List of tolerations to be applied to the Provisioner DaemonSet.                                       | list     | `-`                                                        |
| daemonset.resources                          | Map of resource request and limits to be applied to the Provisioner Daemonset.                        | map      | `-`                                                        |
| prometheus.operator.enabled                  | If set to true, will configure Prometheus monitoring                                                  | bool     | `false`                                                    |
| prometheus.operator.serviceMonitor.interval  | Interval at which Prometheus scrapes the provisioner                                                  | str      | `10s`                                                      |
| prometheus.operator.serviceMonitor.namespace | The namespace Prometheus is installed in                                                              | str      | `monitoring`                                               |
| prometheus.operator.serviceMonitor.selector  | The Prometheus selector label                                                                         | map      | `prometheus: kube-prometheus`                              |

Note: `classes` is a list of objects, you can specify one or more classes.
