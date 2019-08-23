# Mail2Most

[Mail2Most](https://github.com/cseeger-epages/mail2most) is a small application parsing emails via the IMAP protocol and filters them to be send to [mattermost](https://mattermost.com/)

## Introduction

This charts creates a single mail2most Pod.

## Configure Mail2Most

Before installing the service edit [configmap.yaml](templates/configmap.yaml) and configure your mail2most.conf.

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name mail2most stable/mail2most
```

This deploys a singel instance of mail2most using the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete mail2most
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
All default values can be found in [values.yaml](values.yaml). To change them use the helm
specific feature on installing this chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name mail2most \
    --set resources.limits.cpu=200m \
    stable/mail2most
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name mail2most -f values.yaml stable/mail2most
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

Mail2Most stores mail ids to prevent double sending emails to mattermost.
These information are stored in `/data/data.json` by default and can be changed in the
`mail2most.conf` within the [configmap.yaml](templates/configmap.yaml).

If persistence is enabled information stored in `/data` are persisted.
