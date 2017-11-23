# Logspout Helm Chart

This is a helm templated deployment for logspout log router

## Chart details

This chart will do the following:

* The chart will deploy the log router [logspout](https://github.com/gliderlabs/logspout) as a deamonset to the current kubernetes cluster and forward logs from the docker deamon to the specificed log destination.


### Installing the chart.
To install the chart with the release name `my-logger` in the default namespace:
```bash
helm upgrade --install my-logger stable/logspout  -f stable/logspout/values.yaml
```

List the deployed charts
```bash
helm list
```
Deleting a deployed chart
```bash
helm delete my-logger
helm del --purge my-logger
```

| Parameter                        | Description                                        | Default                       |
| -------------------------------- | -------------------------------------------------- | ----------------------------- |
| `image.repository`               | Image file location                                | `gliderlabs/logspout`         |
| `image.tag`                      | Image tag                                          | `v3.2.2`                      |
| `log.level`                      | Specify wether logs will be sent securely.         | `syslog`                      |
| `log.destination`                | Log destination.                                   | ``                            |
| `log.port`                       | Log destination port                               | ``                            |
