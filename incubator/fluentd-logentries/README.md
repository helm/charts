# Helm Chart for Fluentd logshipping to LogEntries

This Helm chart simplifies the deployment of LogEntries fluentd agents on Kubernetes.

The Docker Image source is [le-k8s-ds](https://github.com/honestbee/le-k8s-ds).

## Pre Requisites:

* Requires (and tested with) helm `v2.1.2` or above.
* provide logentries tokens in `secrets/logentries-tokens.yaml` file

  ```bash
  cp secrets/logentries-tokens.sample secrets/logentries-tokens.yaml
  vim secrets/logentries-tokens.yaml
  ```

## Chart details

This chart will do the following:

* Create a Kubernetes DeamonSet for fluentd node shipping agents

### Installing the chart

To install the chart with the release name `le-agent` in the default namespace:

```bash
helm install -n le-agent .
```

| Parameter                   | Description                        | Default                             |
| --------------------------- | ---------------------------------- | ----------------------------------- |
| `nameOverride`              | Name                               | `fluentd`                           |
| `image.repository`          | Image and registry name            | `quay.io/honestbee/le-k8s-ds`       |
| `image.tag`                 | Container image tag                | `master`                            |
| `image.pullPolicy`          | Container image pullPolicy         | `Always`                            |
| `config.*`                  | Will be passed in as env vars      | `*`                                 |
| `secrets.*`                 | Will be stored in a k8s secret     | `*`                                 |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

```bash
helm install -n le-agent . \
  -f .secrets.yaml \
  --set nameOverride=fluentd
```
