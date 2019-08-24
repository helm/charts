# Aerospike Helm Chart

This is an implementation of Aerospike StatefulSet found here:

* <https://github.com/aerospike/aerospike-kubernetes>

## Pre Requisites

* Kubernetes 1.7+ with beta APIs enabled and support for statefulsets

* PV support on underlying infrastructure (only if you are provisioning persistent volume).

* Requires at least `v2.5.0` version of helm to support

## StatefulSet Details

* <https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/>

## StatefulSet Caveats

* <https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations>

## Chart Details

This chart will do the following:

* Implement a dynamically scalable Aerospike cluster using Kubernetes StatefulSets

### Installing the Chart

To install the chart with the release name `my-aerospike` using a dedicated namespace(recommended):

```sh
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install --name my-aerospike --namespace aerospike stable/aerospike
```

The chart can be customized using the following configurable parameters:

| Parameter                       | Description                                                     | Default                      |
| ------------------------------- | ----------------------------------------------------------------| -----------------------------|
| `image.repository`              | Aerospike Container image name                                  | `aerospike/aerospike-server` |
| `image.tag`                     | Aerospike Container image tag                                   | `4.5.0.5`                    |
| `image.pullPolicy`              | Aerospike Container pull policy                                 | `Always`                     |
| `replicaCount`                  | Aerospike Brokers                                               | `1`                          |
| `command`                       | Custom command (Docker Entrypoint)                              | `[]`                         |
| `args`                          | Custom args (Docker Cmd)                                        | `[]`                         |
| `tolerations`                   | List of node taints to tolerate                                 | `[]`                         |
| `persistentVolume`              | Config of persistent volumes for storage-engine                 | `{}`                         |
| `confFile`                      | Config filename. This file should be included in the chart path | `aerospike.conf`             |
| `resources`                     | Resource requests and limits                                    | `{}`                         |
| `nodeSelector`                  | Labels for pod assignment                                       | `{}`                         |
| `terminationGracePeriodSeconds` | Wait time before forcefully terminating container               | `30`                         |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```sh
helm install --name my-aerospike -f values.yaml stable/aerospike
```

### Conf files for Aerospike

There is one conf file added to each Aerospike release. This conf file can be replaced with a custom file and updating the `confFile` value.

If you modify the `aerospike.conf` (and you use more than 1 replica), you want to add the `#REPLACE_THIS_LINE_WITH_MESH_CONFIG` comment to the config file (see the default conf file). This will update your mesh to connect each replica.

## Known Limitations

* Persistent volume claims tested only on GCP
* Aerospike cluster is not accessible via an external endpoint
