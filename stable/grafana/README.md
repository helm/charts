grafana
=======

Installs the web dashboarding system [Grafana](http://grafana.org/)

The leading tool for querying and visualizing time series and metrics.

Current chart version is `3.9.0`



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

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| "grafana.ini".analytics.check_for_updates | bool | `true` |  |
| "grafana.ini".grafana_net.url | string | `"https://grafana.net"` |  |
| "grafana.ini".log.mode | string | `"console"` |  |
| "grafana.ini".paths.data | string | `"/var/lib/grafana/data"` |  |
| "grafana.ini".paths.logs | string | `"/var/log/grafana"` |  |
| "grafana.ini".paths.plugins | string | `"/var/lib/grafana/plugins"` |  |
| "grafana.ini".paths.provisioning | string | `"/etc/grafana/provisioning"` |  |
| admin.existingSecret | string | `""` | The name of an existing secret containing the admin credentials. |
| admin.passwordKey | string | `"admin-password"` | The key in the existing admin secret containing the password. |
| admin.userKey | string | `"admin-user"` | The key in the existing admin secret containing the username. |
| adminUser | string | `"admin"` |  |
| affinity | object | `{}` | Affinity settings for pod assignment |
| annotations | object | `{}` | Deployment annotations |
| command | list | `[]` | Define command to be executed by grafana container at startup |
| dashboardProviders | object | `{}` | Configure grafana dashboard providers. `path` must be /var/lib/grafana/dashboards/<provider_name> |
| dashboards | object | `{}` | Dashboards per provider, use provider name as key |
| dashboardsConfigMaps | object | `{}` | Reference to external ConfigMap per provider. Use provider name as key and ConfiMap name as value |
| datasources | object | `{}` | Configure grafana datasources (passed through tpl) |
| deploymentStrategy | object | `{"type":"RollingUpdate"}` | Deployment strategy |
| downloadDashboards.env | object | `{}` | Environment variables to be passed to the `download-dashboards` container |
| downloadDashboardsImage.pullPolicy | string | `"IfNotPresent"` |  |
| downloadDashboardsImage.repository | string | `"appropriate/curl"` |  |
| downloadDashboardsImage.tag | string | `"latest"` |  |
| env | object | `{}` | Extra environment variables will be passed onto deployment pods |
| envFromSecret | string | `""` | Name of a Kubenretes secret (must be manually created in the same namespace) containing values to be added to the environment |
| extraConfigmapMounts | list | `[]` | Additional grafana server configMap volume mounts |
| extraContainers | string | `""` | Sidecar containers to add to the grafana pod. This is meant to allow adding an authentication proxy to a grafana pod |
| extraEmptyDirMounts | list | `[]` | Additional grafana server emptyDir volume mounts |
| extraInitContainers | list | `[]` | Init containers to add to the grafana pod |
| extraSecretMounts | list | `[]` | Additional grafana server secret mounts. Secrets must be manually created in the namespace. |
| extraVolumeMounts | list | `[]` | Additional grafana server volume mounts |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.pullSecrets | list | `[]` | Image pull secrets |
| image.repository | string | `"grafana/grafana"` | Image repository |
| image.tag | string | `"6.2.5"` | Image tag. (`Must be >= 5.0.0`) |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Enables Ingress |
| ingress.hosts | list | `["chart-example.local"]` | Ingress accepted hostnames |
| ingress.labels | object | `{}` | Custom labels |
| ingress.path | string | `"/"` | Ingress accepted path |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| initChownData.enabled | bool | `true` | If false, don't reset data ownership at startup |
| initChownData.image.pullPolicy | string | `"IfNotPresent"` | init-chown-data container image pull policy |
| initChownData.image.repository | string | `"busybox"` | init-chown-data container image repository |
| initChownData.image.tag | string | `"1.30"` | init-chown-data container image tag |
| initChownData.resources | object | `{}` | init-chown-data pod resource requests & limits |
| ldap.config | string | `""` |  |
| ldap.existingSecret | string | `""` | The name of an existing secret containing the `ldap.toml` file, this must have the key `ldap-toml`. |
| livenessProbe | object | `{"failureThreshold":10,"httpGet":{"path":"/api/health","port":3000},"initialDelaySeconds":60,"timeoutSeconds":30}` | Liveness Probe |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| notifiers | object | `{}` | Configure grafana notifiers |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Persistence access modes |
| persistence.annotations | object | `{}` | PersistentVolumeClaim annotations |
| persistence.enabled | bool | `false` | Use persistent volume to store data |
| persistence.existingClaim | string | `nil` | Use an existing PVC to persist data |
| persistence.finalizers | list | `["kubernetes.io/pvc-protection"]` | PersistentVolumeClaim finalizers |
| persistence.size | string | `"10Gi"` | Size of persistent volume claim |
| persistence.storageClassName | string | `nil` | Type of persistent volume claim |
| persistence.subPath | string | `""` | Mount a sub dir of the persistent volume |
| plugins | list | `[]` | Plugins to be loaded along with Grafana |
| podAnnotations | object | `{}` | Pod annotations |
| priorityClassName | string | `nil` | Name of Priority Class to assign pods |
| rbac.create | bool | `true` | Create and use RBAC resources |
| rbac.namespaced | bool | `false` | Creates Role and Rolebinding instead of the default ClusterRole and ClusteRoleBindings for the grafana instance |
| rbac.pspEnabled | bool | `true` | Create PodSecurityPolicy (with `rbac.create`, grant roles permissions as well) |
| rbac.pspUseAppArmor | bool | `true` | Enforce AppArmor in created PodSecurityPolicy (requires `rbac.pspEnabled`) |
| readinessProbe | object | `{"httpGet":{"path":"/api/health","port":3000}}` | Readiness Probe |
| replicas | int | `1` | Number of nodes |
| resources | object | `{}` | CPU/Memory resource requests/limits |
| schedulerName | string | `nil` | Name of the k8s scheduler (other than default) |
| securityContext.fsGroup | int | `472` |  |
| securityContext.runAsUser | int | `472` |  |
| service.annotations | object | `{}` | Service annotations |
| service.labels | object | `{}` | Custom labels |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.targetPort | int | `3000` | internal service is port (4181 To be used with a proxy extraContainer) |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.create | bool | `true` | Create service account |
| serviceAccount.name | string | `nil` | Service account name to use, when empty will be set to created account if `serviceAccount.create` is set else to `default` |
| serviceAccount.nameTest | string | `nil` | Service account name to use for test, when empty will be set to created account if `serviceAccount.create` is set else to `default` |
| sidecar.dashboards.defaultFolderName | string | `nil` | The default folder name, it will create a subfolder under the `sidecar.dashboards.folder` and put dashboards in there instead |
| sidecar.dashboards.enabled | bool | `false` | Enabled the cluster wide search for dashboards and adds/updates/deletes them in grafana |
| sidecar.dashboards.folder | string | `"/tmp/dashboards"` | Folder in the pod that should hold the collected dashboards (unless `sidecar.dashboards.defaultFolderName` is set). This path will be mounted. |
| sidecar.dashboards.label | string | `"grafana_dashboard"` | Label that config maps with dashboards should have to be added |
| sidecar.dashboards.provider.disableDelete | bool | `false` | Activate to avoid the deletion of imported dashboards |
| sidecar.dashboards.provider.folder | string | `""` | Logical folder in which grafana groups dashboards |
| sidecar.dashboards.provider.name | string | `"sidecarProvider"` |  |
| sidecar.dashboards.provider.orgid | int | `1` | Id of the organisation, to which the dashboards should be added |
| sidecar.dashboards.provider.type | string | `"file"` | Provider type |
| sidecar.dashboards.searchNamespace | string | `nil` | If specified, the sidecar will search for dashboard config-maps inside this namespace. Otherwise the namespace in which the sidecar is running will be used. It's also possible to specify ALL to search in all namespaces |
| sidecar.datasources.enabled | bool | `false` | Enabled the cluster wide search for datasources and adds/updates/deletes them in grafana |
| sidecar.datasources.label | string | `"grafana_datasource"` | Label that config maps with datasources should have to be added |
| sidecar.datasources.searchNamespace | string | `nil` | If specified, the sidecar will search for datasources config-maps inside this namespace. Otherwise the namespace in which the sidecar is running will be used. It's also possible to specify ALL to search in all namespaces |
| sidecar.image | string | `"kiwigrid/k8s-sidecar:0.0.18"` | Sidecar image |
| sidecar.imagePullPolicy | string | `"IfNotPresent"` | Sidecar image pull policy |
| sidecar.resources | object | `{}` | Sidecar resources |
| sidecar.skipTlsVerify | bool | `false` | Set to true to skip tls verification for kube api calls |
| smtp.existingSecret | string | `""` | The name of an existing secret containing the SMTP credentials. |
| smtp.passwordKey | string | `"password"` | The key in the existing SMTP secret containing the password. |
| smtp.userKey | string | `"user"` | The key in the existing SMTP secret containing the username. |
| testFramework.image | string | `"dduportal/bats"` | `test-framework` image repository. |
| testFramework.securityContext | object | `{}` |  |
| testFramework.tag | string | `"0.4.0"` | `test-framework` image tag. |
| tolerations | list | `[]` | Toleration labels for pod assignment |

### Example of extraVolumeMounts

```yaml
- extraVolumeMounts:
  - name: plugins
    mountPath: /var/lib/grafana/plugins
    subPath: configs/grafana/plugins
    existingClaim: existing-grafana-claim
    readOnly: false
```

## Import dashboards

There are a few methods to import dashboards to Grafana. Below are some examples and explanations as to how to use each method:

```yaml
dashboards:
  default:
    some-dashboard:
      json: |
        {
          "annotations":

          ...
          # Complete json file here
          ...

          "title": "Some Dashboard",
          "uid": "abcd1234",
          "version": 1
        }
    custom-dashboard:
      # This is a path to a file inside the dashboards directory inside the chart directory
      file: dashboards/custom-dashboard.json
    prometheus-stats:
      # Ref: https://grafana.com/dashboards/2
      gnetId: 2
      revision: 2
      datasource: Prometheus
    local-dashboard:
      url: https://raw.githubusercontent.com/user/repository/master/dashboards/dashboard.json
```

## BASE64 dashboards

Dashboards could be storaged in a server that does not return JSON directly and instead of it returns a Base64 encoded file (e.g. Gerrit)
A new parameter has been added to the url use case so if you specify a b64content value equals to true after the url entry a Base64 decoding is applied before save the file to disk.
If this entry is not set or is equals to false not decoding is applied to the file before saving it to disk.

### Gerrit use case:
Gerrit API for download files has the following schema: https://yourgerritserver/a/{project-name}/branches/{branch-id}/files/{file-id}/content where {project-name} and
{file-id} usualy has '/' in their values and so they MUST be replaced by %2F so if project-name is user/repo, branch-id is master and file-id is equals to dir1/dir2/dashboard
the url value is https://yourgerritserver/a/user%2Frepo/branches/master/files/dir1%2Fdir2%2Fdashboard/content

## Sidecar for dashboards

If the parameter `sidecar.dashboards.enabled` is set, a sidecar container is deployed in the grafana
pod. This container watches all configmaps (or secrets) in the cluster and filters out the ones with
a label as defined in `sidecar.dashboards.label`. The files defined in those configmaps are written
to a folder and accessed by grafana. Changes to the configmaps are monitored and the imported
dashboards are deleted/updated.

A recommendation is to use one configmap per dashboard, as a reduction of multiple dashboards inside
one configmap is currently not properly mirrored in grafana.

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

If the parameter `sidecar.datasources.enabled` is set, an init container is deployed in the grafana
pod. This container lists all secrets (or configmaps, though not recommended) in the cluster and
filters out the ones with a label as defined in `sidecar.datasources.label`. The files defined in
those secrets are written to a folder and accessed by grafana on startup. Using these yaml files,
the data sources in grafana can be imported. The secrets must be created before `helm install` so
that the datasources init container can list the secrets.

Secrets are recommended over configmaps for this usecase because datasources usually contain private
data like usernames and passwords. Secrets are the more appropriate cluster ressource to manage those.

Example datasource config adapted from [Grafana](http://docs.grafana.org/administration/provisioning/#example-datasource-config-file):
```
apiVersion: v1
kind: Secret
metadata:
  name: sample-grafana-datasource
  labels:
     grafana_datasource: 1
type: Opaque
stringData:
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
