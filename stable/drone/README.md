# Drone.io

> This chart is deprecated in favor of the [official Drone chart](https://github.com/drone/charts).

[Drone](http://readme.drone.io/) v1 is a Continuous Integration platform built on container technology with native Kubernetes support.

> It is not recommended to upgrade from earlier (0.8.x) versions of Drone due to the large amount of breaking changes both in the product and in the helm charts.

## TL;DR;

```console
helm install stable/drone
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release stable/drone
```

> note: The chart will not install the drone server until you have configured a source control option. If this is the case it will print out notes on how to configure it in place using `helm upgrade`.

An example (secrets redacted) working install of the chart using github as the source control provider:

```console
helm install --name drone --namespace drone stable/drone

kubectl create secret generic drone-server-secrets \
      --namespace=cicd-drone \
      --from-literal=clientSecret="XXXXXXXXXXXXXXXXXXXXXXXX"

helm upgrade drone \
  --reuse-values --set 'service.type=LoadBalancer' \
  --set 'service.loadBalancerIP=2.1.60.3' --set 'sourceControl.provider=github' \
  --set 'sourceControl.github.clientID=XXXXXXXX' \
  --set 'sourceControl.secret=drone-server-secrets' --set 'server.host=drone.example.com' \
  stable/drone
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the drone charts and their default values.

| Parameter                                         | Description                                                                                                                                         | Default                       |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `images.server.repository`                        | Drone **server** image                                                                                                                              | `docker.io/drone/drone`       |
| `images.server.tag`                               | Drone **server** image tag                                                                                                                          | `1.6.1`                       |
| `images.server.pullSecret`                        | Drone **server** image pull secret                                                                                                                  | ``                            |
| `images.server.pullPolicy`                        | Drone **server** image pull policy                                                                                                                  | `IfNotPresent`                |
| `images.agent.repository`                         | Drone **agent** image                                                                                                                               | `docker.io/drone/agent`       |
| `images.agent.tag`                                | Drone **agent** image tag                                                                                                                           | `1.6.1`                       |
| `images.agent.pullPolicy`                         | Drone **agent** image pull policy                                                                                                                   | `IfNotPresent`                |
| `images.dind.repository`                          | Docker **dind** image                                                                                                                               | `docker.io/library/docker`    |
| `images.dind.tag`                                 | Docker **dind** image tag                                                                                                                           | `18.06.1-ce-dind`             |
| `images.dind.pullPolicy`                          | Docker **dind** image pull policy                                                                                                                   | `IfNotPresent`                |
| `images.runner.repository`                        | Docker **runner** image                                                                                                                             | `docker.io/drone/drone-runner-kube` |
| `images.runner.tag`                               | Docker **runner** image tag                                                                                                                         | `1.0.0-beta.2`                |
| `images.runner.pullPolicy`                        | Docker **runner** image pull policy                                                                                                                 | `IfNotPresent`                |
| `images.secrets.repository`                       | Docker **secrets plugin** image                                                                                                                     | `robotinfra/drone-kubernetes-secrets` |
| `images.secrets.tag`                              | Docker **secrets plugin** image tag                                                                                                                 | `0c5746b`                     |
| `images.secrets.pullPolicy`                       | Docker **secrets plugin** image pull policy                                                                                                         | `IfNotPresent`                |
| `service.annotations`                             | Service annotations                                                                                                                                 | `{}`                          |
| `service.httpPort`                                | Drone's Web GUI HTTP port                                                                                                                           | `80`                          |
| `service.nodePort`                                | If `service.type` is `NodePort` and this is non-empty, sets the http node port of the service                                                       | `32015`                       |
| `service.type`                                    | Service type (ClusterIP, NodePort or LoadBalancer)                                                                                                  | `ClusterIP`                   |
| `ingress.enabled`                                 | Enables Ingress for Drone                                                                                                                           | `false`                       |
| `ingress.annotations`                             | Ingress annotations                                                                                                                                 | `{}`                          |
| `ingress.hosts`                                   | Ingress accepted hostnames                                                                                                                          | `nil`                         |
| `ingress.tls`                                     | Ingress TLS configuration                                                                                                                           | `[]`                          |
| `ingress.path`                                    | Ingress path mapping                                                                                                                                | ``                            |
| `licenseKey`                                      | Enterprise License Key                                                                                                                              | ``                            |
| `licenseKeySecret`                                | Enterprise License Key Secret Name                                                                                                                  | ``                            |
| `sourceControl.provider`                          | name of source control provider [github,gitlab,gitea,gogs,bitbucketCloud,bitbucketServer]                                                           | ``                            |
| `sourceControl.secret`                            | name of secret containing source control keys and passwords                                                                                         | ``                            |
| `sourceControl.github`                            | values to configure github                                                                                                                          | see values.yaml               |
| `sourceControl.gitlab`                            | values to configure gitlab                                                                                                                          | see values.yaml               |
| `sourceControl.gitea`                             | values to configure gitea                                                                                                                           | see values.yaml               |
| `sourceControl.gogs`                              | values to configure gogs                                                                                                                            | see values.yaml               |
| `sourceControl.bitbucketCloud`                    | values to configure bitbucket cloud                                                                                                                 | see values.yaml               |
| `sourceControl.bitbucketServer`                   | values to configure bitbucket server (stash)                                                                                                        | see values.yaml               |
| `server.host`                                     | Drone **server** hostname (should match callback url in oauth config)                                                                               | `(internal hostname)`         |
| `server.protocol`                                 | Drone **server** scheme/protocol [http,https]                                                                                                       | `http`                        |
| `server.httpPort`                                 | Drone **server** http port                                                                                                                          | `80`                          |
| `server.env`                                      | Drone **server** environment variables                                                                                                              | `(default values)`            |
| `server.database.driver`                          | Drone **server** database driver, options are (`mysql`, `postgres`, `sqlite3`)                                                                      | `sqlite3`                     |
| `server.database.dataSource`                      | Drone **server** database DataSource                                                                                                                | `/var/lib/drone/drone.sqlite` |
| `server.logs.debug`                               | Drone **server** enables debug mode                                                                                                                 | `false`                       |
| `server.logs.trace`                               | Drone **server** enables trace mode                                                                                                                 | `false`                       |
| `server.logs.color`                               | Drone **server** enables colored logs                                                                                                               | `false`                       |
| `server.logs.pretty`                              | Drone **server** enables pretty logs                                                                                                                | `false`                       |
| `server.logs.text`                                | Drone **server** enables text logs rather than `json` logs                                                                                          | `true`                        |
| `server.envSecrets`                               | Drone **server** secret environment variables                                                                                                       | `(default values)`            |
| `server.adminUser`                                | Initial user to create and set as admin                                                                                                             | ``                            |
| `server.alwaysAuth`                               | whether to authenticate when cloning public repositories                                                                                            | `false`                       |
| `server.kubernetes.enabled`                       | whether to use kubernetes to run pipelines (if `false` will run agents instead)                                                                     | `true`                        |
| `server.kubernetes.namespace`                     | namespace in which to run pipelines, defaults to release namespace.                                                                                 | ``                            |
| `server.kubernetes.pipelineServiceAccount`        | if rbac is enabled, what should name of pipeline service account be?                                                                                | ``                            |
| `server.annotations`                              | Drone **server** annotations                                                                                                                        | `{}`                          |
| `server.resources`                                | Drone **server** pod resource requests & limits                                                                                                     | `{}`                          |
| `server.schedulerName`                            | Drone **server** alternate scheduler name                                                                                                           | `nil`                         |
| `server.affinity`                                 | Drone **server** scheduling preferences                                                                                                             | `{}`                          |
| `server.nodeSelector`                             | Drone **server** node labels for pod assignment                                                                                                     | `{}`                          |
| `server.tolerations`                              | Drone **server** node taints to tolerate                                                                                                            | `[]`                          |
| `server.securityContext`                          | Drone **server** securityContext                                                                                                                    | `{}`                          |
| `server.extraContainers`                          | Additional sidecar containers                                                                                                                       | `""`                          |
| `server.extraVolumes`                             | Additional volumes for use in extraContainers                                                                                                       | `""`                          |
| `agent.env`                                       | Drone **agent** environment variables                                                                                                               | `(default values)`            |
| `agent.replicas`                                  | Drone **agent** replicas                                                                                                                            | `1`                           |
| `agent.annotations`                               | Drone **agent** annotations                                                                                                                         | `{}`                          |
| `agent.resources`                                 | Drone **agent** pod resource requests & limits                                                                                                      | `{}`                          |
| `agent.schedulerName`                             | Drone **agent** alternate scheduler name                                                                                                            | `nil`                         |
| `agent.affinity`                                  | Drone **agent** scheduling preferences                                                                                                              | `{}`                          |
| `agent.nodeSelector`                              | Drone **agent** node labels for pod assignment                                                                                                      | `{}`                          |
| `agent.tolerations`                               | Drone **agent** node taints to tolerate                                                                                                             | `[]`                          |
| `agent.livenessProbe`                             | Not currently used.                                                                                                                                 | `{}`                          |
| `agent.readinessProbe`                            | Not currently used                                                                                                                                  | `{}`                          |
| `agent.volumes`                                   | Additional volumes to make available to agent (shared by dind if used)                                                                              | `nil`                         |
| `agent.volumeMounts`                              | Mount points for volumes                                                                                                                            | `nil`                         |
| `agent.rpcServerOverride`                         | Override rpc server url                                                                                                                             | `nil`                         |
| `dind.enabled`                                    | Enable or disable **DinD**                                                                                                                          | `true`                        |
| `dind.driver`                                     | **DinD** storage driver                                                                                                                             | `overlay2`                    |
| `dind.volumeMounts`                               | Mount points for volumes (defined in agent.volumes)                                                                                                 | `nil`                         |
| `dind.resources`                                  | **DinD** pod resource requests & limits                                                                                                             | `{}`                          |
| `dind.env`                                        | **DinD** environment variables                                                                                                                      | `nil`                         |
| `dind.command`                                    | **DinD** custom command instead of default entry point                                                                                              | `nil`                         |
| `dind.args`                                       | **DinD** arguments for custom command or entry point                                                                                                | `nil`                         |
| `runner.enabled`                                  | Enable or disable Drone Kubernetes **runner** enable                                                                                                | `false`                       |
| `runner.replicas`                                 | Drone **runner** replicas                                                                                                                           | `1`                           |
| `runner.env`                                      | Drone **runner** environment variables                                                                                                              | `(default values)`            |
| `runner.logs.debug`                               | Drone **runner** enables debug mode                                                                                                                 | `false`                       |
| `runner.logs.trace`                               | Drone **runner** enables trace mode                                                                                                                 | `false`                       |
| `runner.annotations`                              | Drone **runner** annotations                                                                                                                        | `{}`                          |
| `runner.resources`                                | Drone **runner** pod resource requests & limits                                                                                                     | `{}`                          |
| `runner.schedulerName`                            | Drone **runner** alternate scheduler name                                                                                                           | `nil`                         |
| `runner.affinity`                                 | Drone **runner** scheduling preferences                                                                                                             | `{}`                          |
| `runner.nodeSelector`                             | Drone **runner** node labels for pod assignment                                                                                                     | `{}`                          |
| `runner.tolerations`                              | Drone **runner** node taints to tolerate                                                                                                            | `[]`                          |
| `runner.securityContext`                          | Drone **runner** securityContext                                                                                                                    | `{}`                          |
| `secrets.enabled`                                 | Enable or disable Drone **secrets plugin**, only used if `server.kubernetes.enabled` is `false` and `runner.enabled` is `true`                      | `false`                       |
| `secrets.replicas`                                | Drone **secrets plugin** replicas                                                                                                                   | `1`                           |
| `secrets.service.httpPort`                        | Drone **secrets plugin** service HTTP port                                                                                                          | `80`                          |
| `secrets.httpPort`                                | Drone **secrets plugin** HTTP port port                                                                                                             | `3000`                        |
| `secrets.logs.debug`                              | Drone **secrets plugin** enables debug mode                                                                                                         | `false`                       |
| `secrets.annotations`                             | Drone **secrets plugin** annotations                                                                                                                | `{}`                          |
| `secrets.resources`                               | Drone **secrets plugin** pod resource requests & limits                                                                                             | `{}`                          |
| `secrets.schedulerName`                           | Drone **secrets plugin** alternate scheduler name                                                                                                   | `nil`                         |
| `secrets.affinity`                                | Drone **secrets plugin** scheduling preferences                                                                                                     | `{}`                          |
| `secrets.nodeSelector`                            | Drone **secrets plugin** node labels for pod assignment                                                                                             | `{}`                          |
| `secrets.tolerations`                             | Drone **secrets plugin** node taints to tolerate                                                                                                    | `[]`                          |
| `secrets.securityContext`                         | Drone **secrets plugin** securityContext                                                                                                            | `{}`                          |
| `metrics.prometheus.enabled`                      | Enable Prometheus metrics endpoint                                                                                                                  | `false`                       |
| `persistence.enabled`                             | Use a PVC to persist data                                                                                                                           | `true`                        |
| `persistence.existingClaim`                       | Use an existing PVC to persist data                                                                                                                 | `nil`                         |
| `persistence.storageClass`                        | Storage class of backing PVC                                                                                                                        | `nil`                         |
| `persistence.accessMode`                          | Use volume as ReadOnly or ReadWrite                                                                                                                 | `ReadWriteOnce`               |
| `persistence.size`                                | Size of data volume                                                                                                                                 | `1Gi`                         |
| `sharedSecret`                                    | Drone server and agent shared secret (Note: The Default random value changes on every `helm upgrade` causing a rolling update of server and agents) | `(random value)`              |
| `rbac.create`                                     | Specifies whether RBAC resources should be created.                                                                                                 | `true`                        |
| `rbac.apiVersion`                                 | RBAC API version                                                                                                                                    | `v1`                          |
| `serviceAccount.create`                           | Specifies whether a ServiceAccount should be created.                                                                                               | `true`                        |
| `serviceAccount.name`                             | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template.                              | `(fullname template)`         |
