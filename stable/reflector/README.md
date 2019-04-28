# Helm chart for [Reflector](https://github.com/EmberStack/ES.Kubernetes.Reflector)
Reflector is a Kubernetes addon designed monitor changes to resources (secrets and configmaps) and reflect changes to mirror resources in the same or other namespaces.

### Extensions
Reflector includes a `cert-manager` extension used to automatically annotate created secrets and allow reflection.

Please see a detailed usage guide on the [Reflector GitHub repository](https://github.com/EmberStack/ES.Kubernetes.Reflector).

## Installing the Chart

You can install the chart with the release name `reflector` as below:
```console
$ helm install --name reflector stable/reflector
```
> Note - If you do not specify a name, helm will select a name for you.

### Values
The configuration parameters in this section control the resources requested and utilized by the Reflector instance.

| Parameter                            | Description                                      | Default                                                 |
| ------------------------------------ | ------------------------------------------------ | ------------------------------------------------------- |
| `nameOverride`                       | Overrides release name                           | `""`                                                    |
| `fullnameOverride`                   | Overrides release fullname                       | `""`                                                    |
| `replicaCount`                       | Number of replica.                               | `1`                                                     |
| `image.repository`                   | Container image repository                       | `emberstack/es.kubernetes.reflector`                    |
| `image.tag`                          | Container image tag                              | `latest`                                                |
| `image.pullPolicy`                   | Container image pull policy                      | `Always` if `image.tag` is `latest`, else `IfNotPresent`|
| `extensions.certManager.enabled`     | `cert-manager` addon                             | `true`                                                  |
| `rbac.enabled`                       | Create and use RBAC resources                    | `true`                                                  |
| `serviceAccount.create`              | Create ServiceAccount                            | `true`                                                  |
| `serviceAccount.name`                | ServiceAccount name                              | _release name_                                          |
| `livenessProbe.initialDelaySeconds`  | `livenessProbe` initial delay                    | `5`                                                     |
| `livenessProbe.periodSeconds`        | `livenessProbe` period                           | `10`                                                    |
| `readinessProbe.initialDelaySeconds` | `readinessProbe` initial delay                   | `5`                                                     |
| `readinessProbe.periodSeconds`       | `readinessProbe` period                          | `10`                                                    |
| `resources`                          | Resource limits                                  | `{}`                                                    |
| `nodeSelector`                       | Node labels for pod assignment                   | `{}`                                                    |
| `tolerations`                        | Toleration labels for pod assignment             | `[]`                                                    |
| `affinity`                           | Node affinity for pod assignment                 | `{}`                                                    |

## Upgrading the Chart
You can upgrade using the following command:
```console
$ helm upgrade <HELM_RELEASE_NAME> stable/reflector
```

## Uninstalling the Chart
To uninstall/delete the `my-release` deployment:
```console
$ helm delete my-release
```