# Hue

[Hue](http://gethue.com/) is a collaborative SQL editor for Datawarehouses and Databases.

This helm chart installs a Hue service and its required components (by default an NGINX balancer and
a Postgres database) into a running kubernetes cluster.

The chart installs the Hue docker image from: https://hub.docker.com/u/gethue.

Feel free to ask questions on https://github.com/cloudera/hue.

## Install

To install the Hue Chart into your Kubernetes cluster :

```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install incubator/hue --namespace hue --name hue
```
Then follow-up the instructions printed on the screen for getting the URL to connect to Hue.

For example:

```bash
kubectl port-forward svc/hue 8888:8888 --address 0.0.0.0
```

Then opening-up http://localhost:8888.


If you want to delete your install:

```bash
helm delete hue --purge
```

## Configuration

[values.yaml](values.yaml) contains the most important parameters in the `hue` section with for example which database to use. The `ini`
section let you add any extra [regular parameter](https://docs.gethue.com/latest/administrator/configuration/server/).

The following table lists the main parameters.

| Parameter                                | Description                                             | Default                   |
|------------------------------------------|---------------------------------------------------------|---------------------------|
| `registry`                               | Container image name                                    | `gethue/hue`              |
| `tag`                                    | Container image tag                                     | `latest`                  |
| `pullPolicy`                             | Container pull policy                                   | `IfNotPresent`            |
| `hue.database.*`                         | Configure or point to an existing database              | ``                        |
| `hue.interpreters.*`                     | List of data connectors to activate                     | ``                        |
| `hue.ini.*`                              | hue.ini configuration file                              | ``                        |
| `hue.balancer.create`                    | If creating a load balancer service                     | `true`                    |
