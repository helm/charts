# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Riemann Helm Chart

Riemann is an event stream processor for monitoring distributed systems. The
heart of Riemann is in its clojure based stream configurations. Read more about Riemann at [http://riemann.io/](http://riemann.io/).

Riemann was created by [Kyle Kingsbury](https://github.com/aphyr) with help
from many others.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Install

    helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
    helm install incubator/riemann

## Configuration

The following configurations may be set. It is recommended to use values.yaml for overwriting the Riemann config.

Parameter | Description | Default
--------- | ----------- | -------
replicaCount | How many replicas to run. Riemann can really only work with one. | 1
image.repository | Name of the image to run, without the tag. | [raykrueger/riemann](https://github.com/raykrueger/riemann-docker)
image.tag | The image tag to use. | 0.2.14
image.pullPolicy | The kubernetes image pull policy. | IfNotPresent
service.type | The kubernetes service type to use. | ClusterIP
service.ports.udp | The udp port the service should listen on. | 5555
service.ports.tcp | The tcp port the service should listen on. | 5555
service.ports.websocket | The port the service should listen on for use with websockets. | 5556
resources | Any resource constraints to apply. | None
riemann.config | The actual configuration loaded into the Riemann application. | (See values.yaml)

For more information see http://riemann.io/howto.html#changing-the-config

## Logging

The riemann engine is configured, by default, to log to stdout. Also, all
events are logged to stdout as they are received. Users may want to tune this
down depending on their needs.
