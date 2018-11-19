# Satisfy Helm Chart

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/satisfy
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
`image.pullPolicy`              | Image pull policy                      | `IfNotPresent`
`image.repository`              | Image repository                       | `docker.io/anapsix/satisfy`
`image.tag`                     | Image tag                              | `v3.0.4`
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
`resources`                     | Pod resource requests & limits         | `{"limits": {"cpu: "100m:, "memory": "64Mi"}, "requests": {"cpu": "100m", "memory": "64Mi"}}`
`tolerations`                   | List of node taints to tolerate        | `[]`
`persistence.enabled`           | Use a PVC to persist data              | `true`
`persistence.existingClaim`     | Use an existing PVC to persist data    | `nil`
`persistence.storageClass`      | Storage class of backing PVC           | `nil`
`persistence.accessMode`        | Use volume as ReadOnly or ReadWrite    | `ReadWriteOnce`
`persistence.size`              | Size of data volume                    | `8Gi`
`satisfy.repo_name`             | Satis repository name                  | `myrepo`
`satisfy.homepage`              | Satis repository URL                   | `http://chart-example.local`
`satisfy.ssh_private_key`       | SSH Private key used with GIT repos    | `nil`
