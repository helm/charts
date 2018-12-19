# Logrotate

The logrotate utility is designed to simplify the administration of log files on a system which generates a lot of log files. Logrotate allows for the automatic rotation compression, removal and mailing of log files. Logrotate can be set to handle a log file daily, weekly, monthly or when the log file gets to a certain size.

[![Get started with Stakater](https://stakater.github.io/README/stakater-github-banner.png)](https://stakater.com)

## TL;DR;

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
helm install stable/logrotate
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/logrotate
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the chart and its default values.

|              Parameter      |                    Description                     |                     Default                      |
| --------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `daemonset.annotations`                  | Annotations to apply on daemon set                      | {}                                      |
| `daemonset.labels`                       | Labels to apply on daemon set                           | {}
            |
| `image.name`                             | Container image name                                    | `stakater/logrotate`        
            |
| `image.tag`                              | Container image tag                                     | `3.13.0`       
            |
| `image.pullPolicy`                       | Container image pull policy                             | `IfNotPresent`       
            |
| `environment.cronSchedule`               | Environment variable for cron job schedule              | `0 */12 * * *`       
            |
| `config.annotations`                     | Annotations to apply on cofig map                       | {}       
            |
| `config.labels`                          | Labels to apply on cofig map                            | {}       
            |
| `config.k8sRotatorConf`                  | Complete config file for logrotate                      | ``     
            |
