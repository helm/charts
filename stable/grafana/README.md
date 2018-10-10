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

| Parameter                       | Description                                   | Default                                                 |
|---------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `replicas`                      | Number of nodes                               | `1`                                                     |
| `deploymentStrategy`            | Deployment strategy                           | `RollingUpdate`                                         |
| `livenessProbe`            | Liveness Probe settings                           | `{ "httpGet": { "path": "/api/health", "port": 3000 } }`                                         |
| `readinessProbe`            | Rediness Probe settings                           | `{ "httpGet": { "path": "/api/health", "port": 3000 } "initialDelaySeconds": 60, "timeoutSeconds": 30, "failureThreshold": 10, "periodSeconds": 10 }`                                         |
| `securityContext`               | Deployment securityContext                    | `{"runAsUser": 472, "fsGroup": 472}`                    |
| `image.repository`              | Image repository                              | `grafana/grafana`                                       |
| `image.tag`                     | Image tag. (`Must be >= 5.0.0`)               | `5.3.0`                                                 |
| `image.pullPolicy`              | Image pull policy                             | `IfNotPresent`                                          |
| `service.type`                  | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                  | Kubernetes port where service is exposed      | `80`                                                  |
| `service.annotations`           | Service annotations                           | `{}`                                                    |
| `service.labels`                | Custom labels                                 | `{}`                                                    |
| `ingress.enabled`               | Enables Ingress                               | `false`                                                 |
| `ingress.annotations`           | Ingress annotations                           | `{}`                                                    |
| `ingress.labels`                | Custom labels                                 | `{}`                                                    |
| `ingress.hosts`                 | Ingress accepted hostnames                    | `[]`                                                    |
| `ingress.tls`                   | Ingress TLS configuration                     | `[]`                                                    |
| `resources`                     | CPU/Memory resource requests/limits           | `{}`                                                    |
| `nodeSelector`                  | Node labels for pod assignment                | `{}`                                                    |
| `tolerations`                   | Toleration labels for pod assignment          | `[]`                                                    |
| `affinity`                      | Affinity settings for pod assignment          | `{}`                                                    |
| `persistence.enabled`           | Use persistent volume to store data           | `false`                                                 |
| `persistence.size`              | Size of persistent volume claim               | `10Gi`                                                  |
| `persistence.existingClaim`     | Use an existing PVC to persist data           | `nil`                                                   |
| `persistence.storageClassName`  | Type of persistent volume claim               | `nil`                                                   |
| `persistence.accessModes`       | Persistence access modes                      | `[]`                                                    |
| `persistence.subPath`           | Mount a sub dir of the persistent volume      | `""`                                                    |
| `schedulerName`                 | Alternate scheduler name                      | `nil`                                                   |
| `env`                           | Extra environment variables passed to pods    | `{}`                                                    |
| `envFromSecret`                 | Name of a Kubenretes secret (must be manually created in the same namespace) containing values to be added to the environment | `""` |
| `extraSecretMounts`             | Additional grafana server secret mounts       | `[]`                                                    |
| `plugins`                       | Plugins to be loaded along with Grafana       | `[]`                                                    |
| `datasources`                   | Configure grafana datasources                 | `{}`                                                    |
| `dashboardProviders`            | Configure grafana dashboard providers         | `{}`                                                    |
| `dashboards`                    | Dashboards to import                          | `{}`                                                    |
| `dashboardsConfigMaps`          | ConfigMaps reference that contains dashboards | `{}`                                                    |
| `grafana.ini`                   | Grafana's primary configuration               | `{}`                                                    |
| `ldap.existingSecret`           | The name of an existing secret containing the `ldap.toml` file, this must have the key `ldap-toml`. | `""` |
| `ldap.config  `                 | Grafana's LDAP configuration                  | `""`                                                    |
| `annotations`                   | Deployment annotations                        | `{}`                                                    |
| `podAnnotations`                | Pod annotations                               | `{}`                                                    |
| `sidecar.dashboards.enabled`    | Enabled the cluster wide search for dashboards and adds/updates/deletes them in grafana | `false`       |
| `sidecar.dashboards.label`      | Label that config maps with dashboards should have to be added | `false`                                |
| `sidecar.datasources.enabled`   | Enabled the cluster wide search for datasources and adds/updates/deletes them in grafana |`false`       |
| `sidecar.datasources.label`     | Label that config maps with datasources should have to be added | `false`                               |
| `smtp.existingSecret`           | The name of an existing secret containing the SMTP credentials, this must have the keys `user` and `password`. | `""` |

## Sidecar for dashboards

If the parameter `sidecar.dashboards.enabled` is set, a sidecar container is deployed in the grafana pod. This container watches all config maps in the cluster and filters out the ones with a label as defined in `sidecar.dashboards.label`. The files defined in those configmaps are written to a folder and accessed by grafana. Changes to the configmaps are monitored and the imported dashboards are deleted/updated. A recommendation is to use one configmap per dashboard, as an reduction of multiple dashboards inside one configmap is currently not properly mirrored in grafana.
Example dashboard config:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: sample-grafana-dashboard
  labels:
     grafana_dashboard: 1
data:
  k8s-dashboard.json: |-
  [...]
```

## Sidecar for datasources

If the parameter `sidecar.datasource.enabled` is set, a sidecar container is deployed in the grafana pod. This container watches all config maps in the cluster and filters out the ones with a label as defined in `sidecar.datasources.label`. The files defined in those configmaps are written to a folder and accessed by grafana on startup. Using these yaml files, the data sources in grafana can be modified.

Example datasource config adapted from [Grafana](http://docs.grafana.org/administration/provisioning/#example-datasource-config-file):
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: sample-grafana-datasource
  labels:
     grafana_datasource: 1
data:
	datasource.yaml: |-
		# config file version
		apiVersion: 1

		# list of datasources that should be deleted from the database
		deleteDatasources:
		  - name: Graphite
		    orgId: 1

		# list of datasources to insert/update depending
		# whats available in the database
		datasources:
		  # <string, required> name of the datasource. Required
		- name: Graphite
		  # <string, required> datasource type. Required
		  type: graphite
		  # <string, required> access mode. proxy or direct (Server or Browser in the UI). Required
		  access: proxy
		  # <int> org id. will default to orgId 1 if not specified
		  orgId: 1
		  # <string> url
		  url: http://localhost:8080
		  # <string> database password, if used
		  password:
		  # <string> database user, if used
		  user:
		  # <string> database name, if used
		  database:
		  # <bool> enable/disable basic auth
		  basicAuth:
		  # <string> basic auth username
		  basicAuthUser:
		  # <string> basic auth password
		  basicAuthPassword:
		  # <bool> enable/disable with credentials headers
		  withCredentials:
		  # <bool> mark as default datasource. Max one per org
		  isDefault:
		  # <map> fields that will be converted to json and stored in json_data
		  jsonData:
		     graphiteVersion: "1.1"
		     tlsAuth: true
		     tlsAuthWithCACert: true
		  # <string> json object of data that will be encrypted.
		  secureJsonData:
		    tlsCACert: "..."
		    tlsClientCert: "..."
		    tlsClientKey: "..."
		  version: 1
		  # <bool> allow users to edit datasources from the UI.
		  editable: false

```
