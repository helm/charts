# socat-tunneller

A `port-forward` proxy. Allows an onward connection from the cluster
to some other host in your cluster's network, eg your hosted
database/cache/other service.

In practice, this means that a hosted service can be made available
only to the cluster, then cluster users can be granted access by
giving them permission to run `port-forward` on the tunneller.

## Basic usage

```
helm install stable/socat-tunneller --name db-tunneller --set tunnel.host=mydbhost.cloud --set tunnel.port=3306 --set nameOverride=db-tunneller
```
then
```
kubectl port-forward svc/db-tunneller 13306:3306
```
then, for eg
```
mysql -u myuser -h 127.0.0.1 --port 13306 -p
```

## Configuration values

### Important configuration

| Parameter     | Description                                              | Default    |
| ---------     | -----------                                              | -------    |
| `tunnel.host` | The host to target, this should be resolvable by the pod | (required) |
| `tunnel.port` | The port to target on the host                           | (required) |

### Other configuration

| Parameter          | Description                    | Default        |
| ---------          | -----------                    | -------        |
| `replicaCount`     | Deployment replicas            | 1              |
| `image.repository` | Image repository               | `alpine/socat` |
| `image.tag`        | Image tag                      | `1.0.3`        |
| `image.pullPolicy` | Image pull policy              | `IfNotPresent` |
| `resources`        | Container resources            | `{}`           |
| `nodeSelector`     | Pod node selector              | `{}`           |
| `tolerations`      | Pod tolerations                | `[]`           |
| `affinity`         | Pod affinity                   | `{}`           |
| `podAnnotations`   | Pod annotations                | `{}`           |
