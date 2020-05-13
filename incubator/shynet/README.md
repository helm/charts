# Shynet Helm Chart

Shynet is modern, privacy-friendly, and detailed web analytics that works
without cookies or JS.

## Installing the Chart

Please note that you require an existing PostgreSQL database to run Shynet. To
install the chart, use the following:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/shynet
```

## Configuration

Configurable values are documented in the `values.yaml`. You should at the
minimum configure an ingress for Shynet and set your database settings with
the `env` value.

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
