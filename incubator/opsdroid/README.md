# Opsdroid Helm Chart

Opsdroid is a ChatOps bot framework written in Python.

-  https://opsdroid.dev


## Chart Details

This chart will deploy the following:

-   1 x Opsdroid bot
-   1 x [Rasa NLU](https://rasa.com/docs/nlu/) instance (optional)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/opsdroid
```

## Configuration

The following tables list the configurable parameters of the Opsdroid chart and their default values.

### Opsdroid

| Parameter                       | Description                           | Default                                           |
| ------------------------------- | --------------------------------------| --------------------------------------------------|
| `opsdroid.configuration`        | The yaml configuration for opsdroid   | `nil` (opsdroid will generate default at runtime) |
| `opsdroid.environment`          | Environment variables for the bot     | []                                                |

#### Image

| Parameter                         | Description                  | Default               |
| --------------------------------- | -----------------------------| ----------------------|
| `opsdroid.image.repository`       | Container image name         | `opsdroid/opsdroid`   |
| `opsdroid.image.tag`              | Container tag name           | Latest stable tag     |
| `opsdroid.image.imagePullPolicy`  | Container image pull policy  | `IfNotPresent`        |

#### Service

| Parameter                         | Description                  | Default               |
| --------------------------------- | -----------------------------| ----------------------|
| `opsdroid.service.port`           | Port for service to use      | `8080`                |


#### Resources

| Parameter                            | Description                  | Default               |
| ------------------------------------ | -----------------------------| ----------------------|
| `opsdroid.resources.requests.cpu`    | Minimum CPU request          | `nil`                 |
| `opsdroid.resources.limits.cpu`      | Maximum CPU limit            | `nil`                 |
| `opsdroid.resources.requests.memory` | Minimum memory request       | `nil`                 |
| `opsdroid.resources.limits.memory`   | Maximum memory limit         | `nil`                 |


#### PVC

| Parameter                         | Description                                      | Default               |
| --------------------------------- | -------------------------------------------------| ----------------------|
| `opsdroid.pvc.enabled`            | Use a Persistent Volume to store opsdroid state  | `false`               |
| `opsdroid.pvc.annotations`        | Annotations for the Persistent Volume Claim      | `{}`                  |
| `opsdroid.pvc.selector`           | Selector for the Persistent Volume Claim         | `{}`                  |
| `opsdroid.pvc.accessModes`        | Persistent Volume Claim access mode              | `['ReadWriteOnce']`   |
| `opsdroid.pvc.storage`            | Persistent Volume Claim size                     | `5Gi`                 |
| `opsdroid.pvc.storageClassName`   | Persistent Volume Claim name                     | `nil`                 |


#### Ingress

| Parameter                         | Description                        | Default               |
| --------------------------------- | -----------------------------------| ----------------------|
| `opsdroid.ingress.enabled`        | Use an Ingress to access opsdroid  | `false`               |
| `opsdroid.ingress.annotations`    | Opsdroid Ingress annotations       | `{}`                  |
| `opsdroid.ingress.hosts`          | Opsdroid Ingress Hostnames         | `[]`                  |
| `opsdroid.ingress.tls`            | Opsdroid Ingress TLS configuration | `[]`                  |


### Rasa NLU

| Parameter                       | Description                           | Default                                          |
| ------------------------------- | --------------------------------------| -------------------------------------------------|
| `rasanlu.enabled`               | Use Rasa NLU                          | `false`                                          |
| `rasanlu.token`                 | API key for Rasa NLU to use           | `abc123`                                         |

#### Image

| Parameter                         | Description                  | Default               |
| --------------------------------- | -----------------------------| ----------------------|
| `rasanlu.image.repository`        | Container image name         | `rasa/rasa_nlu`       |
| `rasanlu.image.tag`               | Container tag name           | Latest stable tag     |
| `rasanlu.image.imagePullPolicy`   | Container image pull policy  | `IfNotPresent`        |

#### Service

| Parameter                         | Description                  | Default               |
| --------------------------------- | -----------------------------| ----------------------|
| `rasanlu.service.port`            | Port for service to use      | `5000`                |


#### Resources

| Parameter                            | Description                  | Default               |
| ------------------------------------ | -----------------------------| ----------------------|
| `rasanlu.resources.requests.cpu`     | Minimum CPU request          | `nil`                 |
| `rasanlu.resources.limits.cpu`       | Maximum CPU limit            | `nil`                 |
| `rasanlu.resources.requests.memory`  | Minimum memory request       | `nil`                 |
| `rasanlu.resources.limits.memory`    | Maximum memory limit         | `nil`                 |


#### PVC

| Parameter                         | Description                                      | Default               |
| --------------------------------- | -------------------------------------------------| ----------------------|
| `rasanlu.pvc.enabled`             | Use a Persistent Volume to store opsdroid state  | `false`               |
| `rasanlu.pvc.annotations`         | Annotations for the Persistent Volume Claim      | `{}`                  |
| `rasanlu.pvc.selector`            | Selector for the Persistent Volume Claim         | `{}`                  |
| `rasanlu.pvc.accessModes`         | Persistent Volume Claim access mode              | `['ReadWriteOnce']`   |
| `rasanlu.pvc.storage`             | Persistent Volume Claim size                     | `5Gi`                 |
| `rasanlu.pvc.storageClassName`    | Persistent Volume Claim name                     | `nil`                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/opsdroid
```

> **Tip**: You can use the default [values.yaml](values.yaml)
