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
$ helm install --name my-release stable/external-dns
```

## Configuration

The following tables lists the configurable parameters of the external-dns chart and their default values.


| Parameter              | Description                                                                                                   | Default                                                      |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `azureResourceGroup`   | When using the Azure provider, override the Azure resource group to use (optional).                           | `disabled`                                                   |
| `compatibility`        | Process annotation semantics from legacy implementations (options: mate, molecule ).                          | `disabled`                                                   |
| `debug`                | When enabled, increases the logging output for debugging purposes.                                            | `disabled`                                                   |
| `domainFilter`         | Limit possible target zones by a domain suffix (optional).                                                    | `disabled`                                                   |
| `dryRun`               | When enabled, prints DNS record changes rather than actually performing them.                                 | `false`                                                      |
| `fqdnTemplate`         | A templated string that's used to generate DNS names.                                                         | `""`                                                         |
| `googleProject`        | When using the Google provider, specify the Google project (required when --provider=google).                 | `disabled`                                                   |
| `image.name`           | Container image name (Including repository name if not `hub.docker.com`).                                     | `registry.opensource.zalan.do/teapot/external-dns`           |
| `image.pullPolicy`     | Container pull policy.                                                                                        | `IfNotPresent`                                               |
| `image.tag`            | Container image tag.                                                                                          | `v0.3.0`                                                     |
| `interval`             | The interval between two consecutive synchronizations in duration format.                                     | `disabled`                                                   |
| `logFormat`            | The format in which log messages are printed (options: text, json).                                           | `text`                                                       |
| `master`               | The Kubernetes API server to connect to.                                                                      | `auto-detect`                                                |
| `metricsAddress`       | Specify were to serve the metrics and health check endpoint.                                                  | `7979`                                                       |
| `namespace`            | Limit sources of endpoints to a specific namespace.                                                           | `all`                                                        |
| `podAnnotations`       | Additional annotations to apply to the pod.                                                                   | `None`                                                       |
| `policy`               | Modify how DNS records are sychronized between sources and providers (options: sync, upsert-only ).           | `upsert-only`                                                |
| `provider`             | The DNS provider where the DNS records will be created (options: aws, google, inmemory, azure ).              | `aws`                                                        |
| `registry`             | The registry implementation to use to keep track of DNS record ownership (default: txt, options: txt, noop ). | `txt`                                                        |
| `resources`            | CPU/Memory resource requests/limits.                                                                          | `None`                                                       |
| `saNameOverride`       | Override the default ServiceAccount name.                                                                     | `.Release.Name-external-dns-sa`                              |
| `serviceAccount`       | Should the chart create, and use a Service Account. (Boolean).                                                | `false`                                                      |
| `source`               | List of resources to monitor, possible values are fake, service or ingress.                                   | `service`, `ingress`                                         |
| `txtOwnerId`           | When using the TXT registry, a name that identifies this instance of ExternalDNS (default: default).          | The Helm release name                                        |
| `txtPrefix`            | When using the TXT registry, a custom string that's prefixed to each ownership DNS record (optional).         | `disabled`                                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/external-dns
```

> **Tip**: You can use the default [values.yaml](values.yaml)

[external-dns]: https://github.com/kubernetes-incubator/external-dns
[Zalando]: https://zalando.github.io/
[getting-started]: https://github.com/kubernetes-incubator/external-dns/blob/master/README.md#getting-started
