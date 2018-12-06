# configmaps

This chart is used to apply configmaps. You can specify any number of configmaps. This chart can come in handy when a public chart does not offer additional configmaps. You have to use the following format to specify a configmap:

```bash
- name: configmap-name
  labels:
    app: app-name
  annotations: {}
  data:
```

## Installing

For installing the chart, run the following commands:

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm repo update

helm install stable/configmaps -f values.yaml --namespace <namespace-name>
```

## Usage

The following quickstart let's you set up configmaps chart:

1. Update the `values.yaml` and set the following properties

| Key           | Description                                                               | Example                            | Default Value                      |
|---------------|---------------------------------------------------------------------------|------------------------------------|------------------------------------|
| name          | name of the configmap                                                     | `configmapname`                                             | `configmapname`                    |
| data          | data contains the configmap data                                          | `clientid: testid`                                          | ``                                 |
| annotations   | annotations for configmap                                                 | `configmap.reloader.stakater.com/reload: "foo-configmap"`                | `{}`                        |
| labels        | label for configmap                                                         | `app: app-name`                         | `app: app-name`                                        |
