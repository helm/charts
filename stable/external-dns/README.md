# external-dns chart

## Chart Details

This chart will do the following:

* Create a deployment of [external-dns] within your Kubernetes Cluster.

Currently this uses the [Zalando] hosted container, if this is a concern follow the steps in the [external-dns] documentation to compile the binary and make a container. Where the chart pulls the image from is fully configurable.

## Notes

You probably want to make sure the nodes have IAM permissions to modify the R53 entries. More on this later.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/external-dns
```

## Configuration

The following tables lists the configurable parameters of the consul chart and their default values.


| Parameter              | Description                                                                                                   | Default                        |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `image.name`           | Container image name.                                                                                         | `teapot/external-dns`          |
| `image.pullPolicy`     | Container pull policy.                                                                                        | `IfNotPresent`                 |
| `image.repository`     | Repository to pull the container from.                                                                        | `registry.opensource.zalan.do` |
| `image.tag`            | Container image tag.                                                                                          | `v0.3.0`                       |
| `master`               | The Kubernetes API server to connect to.                                                                      | `auto-detect`                  |
| `source.fake`          | Boolean, should this resource be monitored.                                                                   | `false`                        |
| `source.ingress`       | Boolean, should this resource be monitored.                                                                   | `true`                         |
| `source.service`       | Boolean, should this resource be monitored.                                                                   | `true`                         |
| `namespace`            | Limit sources of endpoints to a specific namespace.                                                           | `all`                          |
| `fqdnTemplate`         | A templated string that's used to generate DNS names.                                                         | `""`                           |
| `compatibility`        | Process annotation semantics from legacy implementations (options: mate, molecule ).                          | `disabled`                     |
| `provider`             | The DNS provider where the DNS records will be created (options: aws, google, inmemory, azure ).              | `aws`                          |
| `googleProject`        | When using the Google provider, specify the Google project (required when --provider=google).                 | `disabled`                     |
| `domainFilter`         | Limit possible target zones by a domain suffix (optional).                                                    | `disabled`                     |
| `azureResourceGroup`   | When using the Azure provider, override the Azure resource group to use (optional).                           | `disabled`                     |
| `policy`               | Modify how DNS records are sychronized between sources and providers (options: sync, upsert-only ).           | `sync`                         |
| `registry`             | The registry implementation to use to keep track of DNS record ownership (default: txt, options: txt, noop ). | `txt`                          |
| `txtOwnerId`           | When using the TXT registry, a name that identifies this instance of ExternalDNS (default: default).          | The Helm release name          |
| `txtPrefix`            | When using the TXT registry, a custom string that's prefixed to each ownership DNS record (optional).         | `disabled`                     |
| `interval`             | The interval between two consecutive synchronizations in duration format.                                     | `disabled`                     |
| `dryRun`               | When enabled, prints DNS record changes rather than actually performing them.                                 | `false`                        |
| `logFormat`            | The format in which log messages are printed (options: text, json).                                           | `text`                         |
| `metricsAddress`       | Specify were to serve the metrics and health check endpoint.                                                  | `7979`                         |
| `debug`                | When enabled, increases the logging output for debugging purposes.                                            | `disabled`                     |
| `resources`            | CPU/Memory resource requests/limits.                                                                          | `None`                         |
| `podAnnotations`       | Additional annotations to apply to the pod.                                                                   | `None`                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/external-dns
```

> **Tip**: You can use the default [values.yaml](values.yaml)

[external-dns]: https://github.com/kubernetes-incubator/external-dns
[Zalando]: https://zalando.github.io/
[getting-started]: https://github.com/kubernetes-incubator/external-dns/blob/master/README.md#getting-started
