# Varnish Helm Chart

This chart installs a Varnish deamon which can be used as a proxy to cache static web resources 

## Prerequisites Details

* Kubernetes 1.8+

## Chart Details
This chart will do the following:

* Implemented a Kubernetes Deployment
* Create a ConfigMap with the requireced default.vcl for Varnish to be configured

## Installing the Chart

Add the Repo

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
```

To install the chart with a default backend (e.g. nginx), caching everything:

```bash
$ helm install --name my-release --set default.backend=nginx-svc.default.svc.cluster.local,default.port=80 incubator/varnish
```

To install the chart with your own varnish configuration (see varnish.vcl. as an example):

```bash
$ helm install --name my-release --set varnishConfigPath=/path/to/varnish.vcl incubator/varnish
```                

For Varnish to start correctly, the backend service you're pointing to must be existant.

After Varnish has started it will cache the configured requests.
You can now point your ingress controller to your varnish service, which will forward them to your configured backend service accordingly. 

## Deleting the Charts

Delete the Helm deployment as normal

```
$ helm delete my-release 
```

Deletion of the Deployment doesn't cascade to deleting associated ConfigMap. To delete them:

```
$ kubectl delete my-release --purge
```

## Configuration

Each requirement is configured with the options provided by that Chart.
Please consult the relevant charts for their configuration options.
