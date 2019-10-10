<img src="https://github.com/pusher/wave/blob/master/wave-logo.svg" width=150 height=150 alt="Wave Logo"/>

# Wave
This charts deploys [Wave](https://github.com/pusher/wave/)

Wave watches Deployments/Statefulset/Daemonsets within a Kubernetes cluster and
ensures that their Pods always have up to date configuration.

By monitoring ConfigMaps and Secrets mounted, Wave can trigger a Rolling Update
of the Deployment when the mounted configuration is changed.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm dependency update
$ helm install --name my-release incubator/wave
```

## Configuration

The following table lists the configurable parameters of the wave chart and their default values.

|       Parameter                   |           Description                       |                         Default                     |
|-----------------------------------|---------------------------------------------|-----------------------------------------------------|
| `global.imagePullSecrets`         | Defines image pulling secrets               | `[]`                                                |
| `global.rbac.create`              | Create required role and rolebindings       | `true`                                              |
| `annotations`                     | Defines pod annotations                     | ``                                                  |
| `image.name`                      | The image to pull                           | `quay.io/pusher/wave`                               |
| `image.tag`                       | The version of the image to pull            | `v0.4.0`                                            |
| `image.pullPolicy`                | The pull policy                             | `IfNotPresent`                                      |
| `nameOverride`                    | Override the name of the chart              | ``                                                  |
| `nodeSelector`                    | Node label to use for scheduling            | `{}`                                                |
| `replicas`                        | Amount of pods to spawn                     | `1`                                                 |
| `securityContext`                 | Security context template                   | `{runAsNonRoot: true, runAsUser: 1000}`             |
| `serviceAccount.create`           | If true, create a new service account	      | `true`                                              |
| `serviceAccount.name`             | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | `` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/wave
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Cleanup

To remove the spawned pods you can run a simple `helm delete <release-name>`.
