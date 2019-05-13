# VMWare_exporter Helm Chart

* Installs the VMWare_exporter for Prometheus [pryorda/vmware_exporter](https://github.com/pryorda/vmware_exporter)

## TL;DR;

```console
$ helm install stable/vmware-exporter
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/vmware-exporter
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `replicas`                                | Number of nodes                               | `1`                                                     |
| `livenessProbe`                           | Liveness Probe settings                       | `{ "httpGet": { "path": "/metrics", "port": 9272 } "initialDelaySeconds": 60, "timeoutSeconds": 30, "failureThreshold": 10 , "periodSeconds": 60}` |
| `readinessProbe`                          | Rediness Probe settings                       | `{ "httpGet": { "path": "/metrics", "port": 9272 } "initialDelaySeconds": 60, "timeoutSeconds": 30, "failureThreshold": 10 , "periodSeconds": 60}` |
| `image.repository`                        | Image repository                              | `pryorda/vmware_exporter`                               |
| `image.tag`                               | Image tag. (`Must be >= 0.7.4`)               | `v0.7.4`                                                |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                            | Kubernetes port where service is exposed      | `80`                                                    |
| `service.targetPort`                      | internal service is port                      | `9272`                                                  |
| `service.annotations`                     | Service annotations                           | `{}`                                                    |
| `service.labels`                          | Custom labels                                 | `{}`                                                    |
| `podAnnotations`                          | podAnnotations i.e. for prometheus scraping   | `{prometheus.io/scrape: "true", prometheus.io/port: "9272", prometheus.io/path: "/metrics"}` |
| `ingress.enabled`                         | Enables Ingress                               | `false`                                                 |
| `ingress.annotations`                     | Ingress annotations                           | `{}`                                                    |
| `ingress.labels`                          | Custom labels                                 | `{}`                                                    |
| `ingress.path`                            | Ingress accepted path                         | `/`                                                     |
| `ingress.hosts`                           | Ingress accepted hostnames                    | `[]`                                                    |
| `ingress.tls`                             | Ingress TLS configuration                     | `[]`                                                    |
| `resources`                               | CPU/Memory resource requests/limits           | `{}`                                                    |
| `nodeSelector`                            | Node labels for pod assignment                | `{}`                                                    |
| `tolerations`                             | Toleration labels for pod assignment          | `[]`                                                    |
| `affinity`                                | Affinity settings for pod assignment          | `{}`                                                    |
| `vsphere.user`                            | User for vcenter login                        | `user`                                                  |
| `vsphere.password`                        | Password for vcenter login                    | `na`                                                    |
| `vsphere.host`                            | Hostname or IP for vcenter login              | `vcenter`                                               |
| `vsphere.ignoressl`                       | User for vcenter                              | `user`                                                  |
| `vsphere.collectors.hosts`                | Collect host metrics                          | `true`                                                  |
| `vsphere.collectors.datastores`           | Collect datastore metrics                     | `true`                                                  |
| `vsphere.collectors.vms`                  | Collect vm metrics                            | `true`                                                  |




### Example of vcenter configuration

```yaml
vsphere:
  user: user
  password: somepassword
  host: vcenter.someCompany.com
  ignoressl: false
  collectors:
    hosts: true
    datastores: true
    vms: true
```

