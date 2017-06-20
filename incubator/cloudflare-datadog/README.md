# Helm chart for Cloudlare to DataDog service

This Helm chart simplifies the deployment of [cloudflare-datadog](https://github.com/mozmar/cloudflare-datadog) on Kubernetes.

## Pre Requisites:

* Requires (and tested with) helm `v2.1.2` or above.

## Chart details

This chart will do the following:

* Create a Kubernetes Deployment for cloudflare-datadog

### Installing the chart

To install the chart with the release name `cfdd` in the default namespace:

```bash
helm install -n cfdd .
```

| Parameter                   | Description                        | Default                             |
| --------------------------- | ---------------------------------- | ----------------------------------- |
| `Name`                      | Name                               | `cfdd`                              |
| `replicaCount`              | Number of replicas                 | `1`                                 |
| `image.repository`          | Image and registry name            | `mozmea/cloudflare-datadog`|
| `image.tag`                 | Container image tag                | `latest`                            |
| `image.pullPolicy`          | Container image tag                | `Always`                            |
| `config.*`                  | Will be passed in as env vars      | `*`                                 |
| `secrets.*`                 | Will be stored in a k8s secret     | `*`                                 |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

```bash
helm install -n cfdd . \
  -f .secrets.yaml \
  --set nameOverride=cfdd
```

