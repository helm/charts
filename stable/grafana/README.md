# Grafana Helm Chart

* Installs the web dashboarding system [Grafana](http://grafana.org/)

## TL;DR;

```console
$ helm install stable/grafana
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/grafana
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

| Parameter                                 | Description                         | Default                                           |
|-------------------------------------------|-------------------------------------|---------------------------------------------------|
| `server.image`                            | Container image to run              | grafana/grafana:latest                            |
| `server.adminUser`                        | Admin user username                 | admin                                             |
| `server.adminPassword`                    | Admin user password                 | Randomly generated                                |
| `server.persistentVolume.enabled`         | Create a volume to store data       | true                                              |
| `server.persistentVolume.size`            | Size of persistent volume claim     | 1Gi RW                                            |
| `server.persistentVolume.storageClass`    | Type of persistent volume claim     | `nil` (uses alpha storage class annotation)       |
| `server.persistentVolume.accessMode`      | ReadWriteOnce or ReadOnly           | [ReadWriteOnce]                                   |
| `server.persistentVolume.existingClaim`   | Existing persistent volume claim    | null                                              |
| `server.persistentVolume.subPath`         | Subdirectory of pvc to mount        | null                                              |
| `server.resources`                        | Server resource requests and limits | requests: {cpu: 100m, memory: 100Mi}              |
| `server.tolerations`                      | node taints to tolerate (requires Kubernetes >=1.6) | null |
| `server.service.annotations`              | Service annotations                 | null                                              |
| `server.service.httpPort`                 | Service port                        | 80                                                |
| `server.service.loadBalancerIP`           | IP to assign to load balancer       | null                                              |
| `server.service.loadBalancerSourceRanges` | List of IP CIDRs allowed access     | null                                              |
| `server.service.nodePort`                 | For service type "NodePort"         | null                                              |
| `server.service.externalIPs`              | External IP addresses               | null                                              |
| `server.service.type`                     | ClusterIP, NodePort, or LoadBalancer| ClusterIP                                         |
| `server.setDatasource.enabled`            | Creates grafana datasource with job | false                                             |
