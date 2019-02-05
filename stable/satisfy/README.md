# Satisfy Helm Chart

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/satisfy
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

 Parameter                      | Description                            | Default
------------------------------- | -------------------------------------- | ---------
`image.pullPolicy`              | Image pull policy                      | `Always`
`image.repository`              | Image repository                       | `docker.io/anapsix/satisfy`
`image.tag`                     | Image tag                              | `v3.0.4`
`image.digest`                  | Image digest                           | `sha256:16a818ab03b6a6bd2625dc9b4760f079fbbddfdd1473994593dfae958c6e7e29`
`image.pullSecrets`             | Specify image pull secrets             | `[]`
`service.type`                  | Type of service                        | `ClusterIP`
`service.port`                  | Service port                           | `80`
`ingress.enabled`               | Enables Ingress                        | `false`
`ingress.annotations`           | Ingress annotations                    | `{}`
`ingress.labels`                | Ingress labels                         | `[]`
`ingress.hosts`                 | Ingress accepted hostnames             | `[]`
`ingress.tls`                   | Ingress TLS configuration              | `[]`
`terminationGracePeriodSeconds` | Termination grace period (in seconds)  | `15`
`livenessProbe.enabled`         | Enables LivenessProbe                  | `true`
`readinessProbe.enabled`        | Enables readinessProbe                 | `true`
`affinity`                      | Node/pod affinities                    | `{}`
`nodeSelector`                  | Node labels for pod assignment         | `{}`
`resources`                     | Pod resource requests & limits         | `{}`
`tolerations`                   | List of node taints to tolerate        | `[]`
`persistence.enabled`           | Use a PVC to persist data              | `true`
`persistence.existingClaim`     | Use an existing PVC to persist data    | `nil`
`persistence.storageClass`      | Storage class of backing PVC           | `nil`
`persistence.accessMode`        | Use volume as ReadOnly or ReadWrite    | `ReadWriteOnce`
`persistence.size`              | Size of data volume                    | `8Gi`
`satisfy.repoName`              | Satis repository name                  | `myrepo`
`satisfy.homepage`              | Satis repository URL                   | `http://chart-example.local`
`satisfy.sshPrivateKey`         | SSH Private key used with GIT repos    | `nil`

> When both `image.tag` and `image.digest` are present, `image.digest` will be used. See [Docker docs][1] for more details about using image digest.

[## Link Reference ##]::
[1]: https://docs.docker.com/engine/reference/commandline/pull/#pull-an-image-by-digest-immutable-identifier
