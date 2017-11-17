# Keel - automated Kubernetes deployments for the rest of us

* Website [https://keel.sh](https://keel.sh)
* User Guide [https://keel.sh/user-guide/](https://keel.sh/user-guide/)

Keel is a tool for automating [Kubernetes](https://kubernetes.io/) deployment updates. Keel is stateless, robust and lightweight.

Keel provides several key features:

* __[Kubernetes](https://kubernetes.io/) and [Helm](https://helm.sh) providers__ - Keel has direct integrations with Kubernetes and Helm.

* __No CLI/API__ - tired of `***ctl` for everything? Keel doesn't have one. Gets job done through labels, annotations, charts.

* __Semver policies__ - specify update policy for each deployment/Helm release individually.

* __Automatic [Google Container Registry](https://cloud.google.com/container-registry/) configuration__ - Keel automatically sets up topic and subscriptions for your deployment images by periodically scanning your environment.

* __[Native, DockerHub and Quay webhooks](https://keel.sh/user-guide/triggers/#webhooks) support__ -  once webhook is received impacted deployments will be identified and updated.

*  __[Polling](https://keel.sh/user-guide/#polling-deployment-example)__ - when webhooks and pubsub aren't available - Keel can still be useful by checking Docker Registry for new tags (if current tag is semver) or same tag SHA digest change (ie: `latest`).

* __Notifications__ - out of the box Keel has Slack and standard webhook notifications, more info [here](https://keel.sh/user-guide/#notifications)


**Note**: For now Keel gets installed into `kube-system` _namespace_ by default as where Helm's `Tiller` is installed.

## Installing the Chart with Kubernetes provider support

Docker image _polling_ and _Kubernetes_ provider are set by default, then Kubernetes _deployments_ can be upgraded when new Docker image is available:

```console
helm upgrade --install keel stable/keel"
```

## Installing the Chart with Helm provider support

Docker image _polling_ is set by default, but we need to enable _Helm provider_ support, then Helm _releases_ can be upgraded when new Docker image is available:

```console
helm upgrade --install keel stable/keel --set helmProvider.enabled="true"
```

### Setting up Helm release to be automatically updated by Keel

Add the following to your app's `values.yaml` file and do `helm upgrade ...`:

```
keel:
  # keel policy (all/major/minor/patch/force)
  policy: all
  # trigger type, defaults to events such as pubsub, webhooks
  trigger: poll
  # polling schedule
  pollSchedule: "@every 3m"
  # images to track and update
  images:
    - repository: image.repository # it must be the same names as your app's values
      tag: image.tag # it must be the same names as your app's values
```

The same can be applied with `--set` flag without using `values.yaml` file:

```
helm upgrade --install whd webhookdemo --reuse-values \
  --set keel.policy="all",keel.trigger="poll",keel.pollSchedule="@every 3m" \
  --set keel.images[0].repository="image.repository" \
  --set keel.images[0].tag="image.tag"
```

You can read in more details about supported policies, triggers and etc in the [User Guide](https://keel.sh/user-guide/).

Also you should check the [Webhooh demo app](https://github.com/webhookrelay/webhook-demo) and it's chart to have more clear
idea how to set automatic updates.


## Uninstalling the Chart

To uninstall/delete the `keel` deployment:

```console
$ helm delete keel
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists has the main configurable parameters (polling, triggers, notifications, service) of the _Keel_ chart and they apply to both Kubernetes and Helm providers:

| Parameter                         | Description                            | Default                                                   |
| --------------------------------- | -------------------------------------- | --------------------------------------------------------- |
| `polling.enabled`                 | Docker registries polling              | `true`                                                    |
| `helmProvider.enabled`            | Enable/disable Helm provider           | `false`                                                   |
| `gcr.enabled`                     | Enable/disable GCR Registry            | `false`                                                   |
| `gcr.projectID`                   | GCP Project ID GCR belongs to          |                                                           |
| `gcr.pubsub.enabled`              | Enable/disable GCP Pub/Sub trigger     | `false`                                                   |
| `webhook.enabled`                 | Enable/disable Webhook Notification    | `false`                                                   |
| `webhook.endpoint`                | Remote webhook endpoint                |                                                           |
| `slack.enabled`                   | Enable/disable Slack Notification      | `false`                                                   |
| `slack.token`                     | Slack token                            |                                                           |
| `slack.channel`                   | Slack channel                          |                                                           |
| `service.enable`                  | Enable/disable Keel service            | `false`                                                   |
| `service.type`                    | Keel service type                      | `LoadBalancer`                                            |
| `service.externalPort`            | Keel service port                      | `9300`                                                    |
| `webhookRelay.enabled`            | Enable/disable WebhookRelay integration| `false`                                                   |
| `webhookRelay.key`                | WebhookRelay key                       |                                                           |
| `webhookRelay.secret`             | WebhookRelay secret                    |                                                           |
| `webhookRelay.bucket`             | WebhookRelay bucket                    |                                                           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name keel -f values.yaml stable/keel
```
> **Tip**: You can use the default [values.yaml](values.yaml)
