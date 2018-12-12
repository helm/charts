# configmaps

This chart is used to apply configmaps. You can specify any number of configmaps. This chart can come in handy when a public chart does not offer additional configmaps. You have to use the following format to specify a configmap:

```yaml
- name: configmap-name
  labels:
    app: app-name
  annotations: {}
  data:
```

## Installing

For installing the chart, run the following commands:

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/configmaps -f values.yaml --namespace <namespace-name>
```

## Usage

The following quickstart let's you set up configmaps chart:

1. Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| name          | name of the configmap                                                     | `configmapname`                                             | `configmapname`                    |
| data          | data contains the configmap data                                          | `clientid: testid`                                          | ``                                 |
| annotations   | annotations for configmap                                                 | `configmap.reloader.stakater.com/reload: "foo-configmap"`                | `{}`                        |
| labels        | label for configmap                                                         | `app: app-name`                         | `app: app-name`                                        |

## Example

Configmaps chart is used to create configmaps for other charts which does not support creation of additional configmaps.
For example, we need additional configmap for [keycloak](https://github.com/helm/charts/tree/master/stable/keycloak) chart which would contain our realm configurations but there is no support for creation of additional configmap. Below are the steps, that explains how to achieve this using configmaps chart.

- Update the `values.yaml` file to create a configmap. 

```yaml
ConfigMaps:
- name: keycloak-configmap
  labels:
    app: "keycloak"
  annotations: {}
  data:
    realm.json: |-
      { your realm data }
```

- Deploy the configmaps chart. This will create a configmap with name `keycloak-configmap` containing our keycloak realm configurations.
- Now, to mount this configmap in keycloak, update the [values.yaml](https://github.com/helm/charts/blob/master/stable/keycloak/values.yaml) of keycloak and update `extraVolumes` and `extraVolumeMounts`

```yaml
extraVolumes: |
  - name: keycloak-config
    configMap:
      name: keycloak-configmap
```

```yaml
extraVolumeMounts: |
  - name: keycloak-config
    mountPath: /opt/jboss/keycloak/standalone/configuration/import/realm.json
    subPath: realm.json
```

- Deploy the [keycloak](https://github.com/helm/charts/tree/master/stable/keycloak) chart and we can see the additional configmap `keycloak-configmap` mounted on path `/opt/jboss/keycloak/standalone/configuration/import/realm.json`