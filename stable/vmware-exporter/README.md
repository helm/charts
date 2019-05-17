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
| `livenessProbe`                           | Liveness Probe settings                       | `{ "httpGet": { "path": "/healthz", "port": 9272 } "initialDelaySeconds": 30, "failureThreshold": 10}` |
| `readinessProbe`                          | Rediness Probe settings                       | `{ "httpGet": { "path": "/healthz", "port": 9272 }` |
| `image.repository`                        | Image repository                              | `pryorda/vmware_exporter`                               |
| `image.tag`                               | Image tag. (`Must be >= 0.7.4`)               | `v0.7.4`                                                |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `service.enabled`                         | Enable a service for vmware_exporter          | `false`                                                 |
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

## Sharding the exporter for different vcenter instances

If different tenants are configured that have restricted visibility to specific folders, metrics can be sharded.
This will allow a setup like:

Prometheus customer(A) => VMWare exporter customer(A) => VCenter restricted access for customer(A)
Prometheus customer(B) => VMWare exporter customer(B) => VCenter restricted access for customer(B)

Some Grafana dashboard, connected to a datasource with mixed content will allow access to the whole underlying datasource with VIEWER privileges.

- [Grafana datasource permissions security notes](https://grafana.com/docs/permissions/overview/#datasource-permissions)
- [Prometheus reference about datasource security](https://prometheus.io/docs/operating/security/#authentication-authorization-and-encryption)

To enable seperation in the K8S autodiscovery to the following:

    podAnnotations:
      yourcustomannotation/scrape: "true"
      yourcustomannotation/port: "9272"
      prometheus.io/scrape: null
      prometheus.io/port: null
      prometheus.io/path: null

The scraping of Prometheus can be configured, adding additionalScrapeConfig parts or replacing prometheus.yml (most common for sharded data):

Parametrize the stable/prometheus chart like in the following example, take care for **yourcustomannotation**:

    serverFiles:
      prometheus.yml:
        rule_files:
        - /etc/config/rules
        - /etc/config/alerts
        scrape_configs:
        - job_name: prometheus
          static_configs:
          - targets:
            - localhost:9090
        - job_name: 'k8s-yourcustomannotation'
          kubernetes_sd_configs:
          - role: pod
          relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_yourcustomannotation_scrape]
            separator: ;
            regex: "true"
            replacement: $1
            action: keep
          - source_labels: [__meta_kubernetes_pod_annotation_yourcustomannotation _path]
            separator: ;
            regex: (.+)
            target_label: __metrics_path__
            replacement: $1
            action: replace
          - source_labels: [__address__, __meta_kubernetes_pod_annotation_yourcustomannotation _port]
            separator: ;
            regex: ([^:]+)(?::\d+)?;(\d+)
            target_label: __address__
            replacement: $1:$2
            action: replace
    kubeStateMetrics:
      enabled: false
    nodeExporter:
      enabled: false
    pushgateway:
      enabled: false
    alertmanager:
      enabled: false
    alertmanagerFiles:
      alertmanager.yml: ""


