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

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `replicas`                                | Number of nodes                               | `1`                                                     |
| `deploymentStrategy`                      | Deployment strategy                           | `{ "type": "RollingUpdate" }`                           |
| `livenessProbe`                           | Liveness Probe settings                       | `{ "httpGet": { "path": "/api/health", "port": 3000 } "initialDelaySeconds": 60, "timeoutSeconds": 30, "failureThreshold": 10 }` |
| `readinessProbe`                          | Rediness Probe settings                       | `{ "httpGet": { "path": "/api/health", "port": 3000 } }`|
| `securityContext`                         | Deployment securityContext                    | `{"runAsUser": 472, "fsGroup": 472}`                    |
| `priorityClassName`                       | Name of Priority Class to assign pods         | `nil`                                                   |
| `image.repository`                        | Image repository                              | `grafana/grafana`                                       |
| `image.tag`                               | Image tag. (`Must be >= 5.0.0`)               | `6.3.4`                                                 |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `image.pullSecrets`                       | Image pull secrets                            | `{}`                                                    |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                            | Kubernetes port where service is exposed      | `80`                                                    |
| `service.targetPort`                      | internal service is port                      | `3000`                                                  |
| `service.annotations`                     | Service annotations                           | `{}`                                                    |
| `service.labels`                          | Custom labels                                 | `{}`                                                    |
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
| `extraInitContainers`                     | Init containers to add to the grafana pod     | `{}` |
| `extraContainers`                         | Sidecar containers to add to the grafana pod  | `{}` |
| `schedulerName`                           | Name of the k8s scheduler (other than default) | `nil`                                                  |
| `persistence.enabled`                     | Use persistent volume to store data           | `false`                                                 |
| `persistence.size`                        | Size of persistent volume claim               | `10Gi`                                                  |
| `persistence.existingClaim`               | Use an existing PVC to persist data           | `nil`                                                   |
| `persistence.storageClassName`            | Type of persistent volume claim               | `nil`                                                   |
| `persistence.accessModes`                 | Persistence access modes                      | `[ReadWriteOnce]`                                       |
| `persistence.annotations`                 | PersistentVolumeClaim annotations             | `{}`                                                    |
| `persistence.finalizers`                  | PersistentVolumeClaim finalizers              | `[ "kubernetes.io/pvc-protection" ]`                    |
| `persistence.subPath`                     | Mount a sub dir of the persistent volume      | `nil`                                                   |
| `initChownData.enabled`                   | If false, don't reset data ownership at startup | true                                                  |
| `initChownData.image.repository`          | init-chown-data container image repository    | `busybox`                                               |
| `initChownData.image.tag`                 | init-chown-data container image tag           | `latest`                                                |
| `initChownData.image.pullPolicy`          | init-chown-data container image pull policy   | `IfNotPresent`                                          |
| `initChownData.resources`                 | init-chown-data pod resource requests & limits | `{}`                                                   |
| `schedulerName`                           | Alternate scheduler name                      | `nil`                                                   |
| `env`                                     | Extra environment variables passed to pods    | `{}`                                                    |
| `envFromSecret`                           | Name of a Kubenretes secret (must be manually created in the same namespace) containing values to be added to the environment | `""` |
| `extraSecretMounts`                       | Additional grafana server secret mounts       | `[]`                                                    |
| `extraVolumeMounts`                       | Additional grafana server volume mounts       | `[]`                                                    |
| `extraConfigmapMounts`                    | Additional grafana server configMap volume mounts  | `[]`                                               |
| `extraEmptyDirMounts`                     | Additional grafana server emptyDir volume mounts   | `[]`                                               |
| `plugins`                                 | Plugins to be loaded along with Grafana       | `[]`                                                    |
| `datasources`                             | Configure grafana datasources (passed through tpl) | `{}`                                                    |
| `notifiers`                               | Configure grafana notifiers | `{}`                                                                      |
| `dashboardProviders`                      | Configure grafana dashboard providers         | `{}`                                                    |
| `dashboards`                              | Dashboards to import                          | `{}`                                                    |
| `dashboardsConfigMaps`                    | ConfigMaps reference that contains dashboards | `{}`                                                    |
| `grafana.ini`                             | Grafana's primary configuration               | `{}`                                                    |
| `ldap.existingSecret`                     | The name of an existing secret containing the `ldap.toml` file, this must have the key `ldap-toml`. | `""` |
| `ldap.config  `                           | Grafana's LDAP configuration                  | `""`                                                    |
| `annotations`                             | Deployment annotations                        | `{}`                                                    |
| `podAnnotations`                          | Pod annotations                               | `{}`                                                    |
| `sidecar.image`                           | Sidecar image                                 | `kiwigrid/k8s-sidecar:0.1.20`                           |
| `sidecar.imagePullPolicy`                 | Sidecar image pull policy                     | `IfNotPresent`                                          |
| `sidecar.resources`                       | Sidecar resources                             | `{}`                                                    |
| `sidecar.dashboards.enabled`              | Enables the cluster wide search for dashboards and adds/updates/deletes them in grafana | `false`       |
| `sidecar.dashboards.provider.name`        | Unique name of the grafana provider           | `sidecarProvider`                                       |
| `sidecar.dashboards.provider.orgid`       | Id of the organisation, to which the dashboards should be added | `1`                                   |
| `sidecar.dashboards.provider.folder`      | Logical folder in which grafana groups dashboards | `""`                                                |
| `sidecar.dashboards.provider.disableDelete` | Activate to avoid the deletion of imported dashboards | `false`                                       |
| `sidecar.dashboards.provider.type`        | Provider type                                 | `file`                                                  |
| `sidecar.skipTlsVerify`                   | Set to true to skip tls verification for kube api calls | `nil`       |
| `sidecar.dashboards.label`                | Label that config maps with dashboards should have to be added | `grafana_dashboard`                                |
| `sidecar.dashboards.folder`                | Folder in the pod that should hold the collected dashboards (unless `sidecar.dashboards.defaultFolderName` is set). This path will be mounted. | `/tmp/dashboards`    |
| `sidecar.dashboards.defaultFolderName`                | The default folder name, it will create a subfolder under the `sidecar.dashboards.folder` and put dashboards in there instead | `nil`                                |
| `sidecar.dashboards.searchNamespace`      | If specified, the sidecar will search for dashboard config-maps inside this namespace. Otherwise the namespace in which the sidecar is running will be used. It's also possible to specify ALL to search in all namespaces | `nil`                                |
| `sidecar.datasources.enabled`             | Enables the cluster wide search for datasources and adds/updates/deletes them in grafana |`false`       |
| `sidecar.datasources.label`               | Label that config maps with datasources should have to be added | `grafana_datasource`                               |
| `sidecar.datasources.searchNamespace`     | If specified, the sidecar will search for datasources config-maps inside this namespace. Otherwise the namespace in which the sidecar is running will be used. It's also possible to specify ALL to search in all namespaces | `nil`                               |
| `smtp.existingSecret`                     | The name of an existing secret containing the SMTP credentials. | `""`                                  |
| `smtp.userKey`                            | The key in the existing SMTP secret containing the username. | `"user"`                                 |
| `smtp.passwordKey`                        | The key in the existing SMTP secret containing the password. | `"password"`                             |
| `admin.existingSecret`                    | The name of an existing secret containing the admin credentials. | `""`                                 |
| `admin.userKey`                           | The key in the existing admin secret containing the username. | `"admin-user"`                          |
| `admin.passwordKey`                       | The key in the existing admin secret containing the password. | `"admin-password"`                      |
| `serviceAccount.create`                   | Create service account | `true` |
| `serviceAccount.name`                     | Service account name to use, when empty will be set to created account if `serviceAccount.create` is set else to `default` | `` |
| `serviceAccount.nameTest`                 | Service account name to use for test, when empty will be set to created account if `serviceAccount.create` is set else to `default` | `` |
| `rbac.create`                             | Create and use RBAC resources | `true` |
| `rbac.namespaced`                         | Creates Role and Rolebinding instead of the default ClusterRole and ClusteRoleBindings for the grafana instance  | `false` |
| `rbac.pspEnabled`                         | Create PodSecurityPolicy (with `rbac.create`, grant roles permissions as well) | `true` |
| `rbac.pspUseAppArmor`                     | Enforce AppArmor in created PodSecurityPolicy (requires `rbac.pspEnabled`)  | `true` |
| `command`                     | Define command to be executed by grafana container at startup  | `nil` |
| `testFramework.image`                     | `test-framework` image repository.             | `dduportal/bats`                                       |
| `testFramework.tag`                       | `test-framework` image tag.                    | `0.4.0`                                                |
| `testFramework.securityContext`           | `test-framework` securityContext                | `{}`                                                   |
| `downloadDashboards.env`                  | Environment variables to be passed to the `download-dashboards` container | `{}`                                                   |


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
