# WebPageTest Server

[WebPageTest](https://webpagetest.org/) is a website testing tool

## TL;DR;

```console
$ helm install incubator/webpagetest-server
```

## Introduction

This chart bootstraps a private [WebPageTest Server](https://github.com/WPO-Foundation/webpagetest-docs/blob/master/user/Private%20Instances/README.md) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Depending on your configuration you can then use Official WPT agent instances to test your websites

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/webpagetest-server
```

The command deploys WebPageTest on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
Please note the default install probably won't do much without some configuration of the values.yaml file


> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the WebPageTest chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| -------------------------------      | -------------------------------            | ---------------------------------------------------------- |
| `image.repository`                              | WebPageTest server image                   | `timothyclarke/wptserver`                              |
| `image.tag`                              | WebPageTest server tag                   | `2018-03-08`                              |
| `image.pullPolicy`                    | Image pull policy                          | `IfNotPresent`                                             |
| `ec2Locations.enabled`               | Enables use of EC2 AMI's                   | `false`                                                     |
| `ec2Locations.customUserDataSecret`  | Controls if this chart should use an externally created secret | `false` |
| `ec2Locations.userData`              | Data Structure which is used to generate settings | sample data only                                    |
| `ec2Locations.userData.ec2_key`      | EC2 API key with create permissions        | `nil`                                                      |
| `ec2Locations.userData.ec2_secret`   | Secret portion of the above key            | `nil`                                                      |
| `ec2Locations.userData.headless`     | API Only Flag, 0=has user UI               | `0`                                                        |
| `ec2Locations.userData.'EC2.default'`| default testing location when using AMI's  | `eu-west-1`                                                |
| `serviceType`                        | Kubernetes Service type                    | `LoadBalancer`                                             |
| `healthcheckHttps`                   | Use https for liveliness and readiness     | `false`                                                    |
| `ingress.enabled`                    | Enable ingress controller resource         | `false`                                                    |
| `ingress.hosts.[0]`                  | host header for access                     | `web-page-test.local`                                      |
| `ingress.hosts.annotations`          | Annotations for the host's ingress records | `[]`                                                       |
| `ingress.tls`                        | Utilize TLS backend in ingress             | `false`                                                    |
| `ingress.tls.[0].secretName`         | TLS Secret (certificates) name             | `web-page-test.local-tls`                                  |
| `ingress.tls.[0].hosts`              | host headers to get ssl certs for          | `[web-page-test.local]`                                    |
| `agentIngress.*`                     | As ingress above, but used for WPT agents  | `false`                                                    |
| `nodeSelector`                       | Node labels for pod assignment             | `{}`                                                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set ingress.enabled=true,ingress.hosts.[0]=web-page-test.local \
    incubator/webpagetest-server
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/webpagetest-server
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Ingress(es)

This chart provides support for ingress resources. If you have an
ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress)
or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize
the ingress controller to service your WebPageTest application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts
Most likely you will only want to have one hostname that maps to this
WebPageTest installation for scripts or end users to interact, then a
separate instance for the AMI's to operate on (see AgentIngress below).
It is however possible to have more than one host.
To facilitate this, the `ingress.hosts` object is an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any
`annotations` that you may want the ingress controller to know about.

Indicating TLS will cause WebPageTest generate HTTPS urls, and
WebPageTest will be connected to at port 443.  The actual secret that
`tlsSecret` references does not have to be generated by this chart.
However, please note that if TLS is enabled, the ingress record will not
work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md).
Not all annotations are supported by all ingress controllers, but this
document does a good job of indicating which annotation is supported by
many popular ingress controllers.


### TLS Secrets
This chart will facilitate the creation of TLS secrets for use with the
ingress controller, however this is not required.  There are three
common use cases:

* helm generates / manages certificate secrets
* user generates / manages certificates separately
* an additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego))
manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would
expect them to look like this:

* certificate files should look like (and there can be more than one
certificate if there is a certificate chain)

```
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```
* keys should look like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
````

If you are going to use helm to manage the certificates, please copy
these values into the `certificate` and `key` values for a given
`ingress.secrets` entry.

If you are going to manage TLS secrets outside of helm, please
know that you can create a TLS secret by doing the following:

```
kubectl create secret tls web-page-test.local-tls --key /path/to/key.key --cert /path/to/cert.crt
```

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls)
for more information.

## AgentIngress
Generally speaking WebPageTest is difficult to secure / restrict access. In creating this chart the design is that
a user would use the ingress listed above. The ingress above would have appropriate access restrictions using either
whitelisted IP's, http basic auth or both.
This however would block access to the agents without significant additional config. Agents in a remote region would
probably need a region to region VPN to get access. Rather than doing that we create a second host header and restrict
the url path to /work, /cron and /jpeginfo. The agents use /work and the server connects to itself on /cron and
/jpeginfo. This way 3rd parties do not have access to create tests, but any host (with the correct keys) can get work
units and post results.

## ec2Locations.userData
All of the content within here is provided to the init scripting used to provision the server. It is used by the same
processing which configures AMI's. Generally it's parsed to create key value pairs for settings.ini.
Please any key which contains a dot should be quoted so it is not interpreted by k8s which uses '.' for its data structure
eg EC2.default should be
```
ec2Locations:
  userData:
    'EC2.default':  'eu-west-1'
```
which is ```ec2Locations.userData.'EC2.default':'eu-west-1'```

rather than
```
ec2Locations:
  userData:
    EC2.default:  'eu-west-1'
```
which is ```ec2Locations.userData.EC2.default:'eu-west-1'```
or the same as
```
ec2Locations:
  userData:
    EC2:
      default:  'eu-west-1'
```
For a complete list of these you will need to look at the WebPageTest Docs.
Ones to note are
```
; archiving to s3 (using the s3 protocol, not necessarily just s3)
;archive_s3_server=s3.amazonaws.com
;archive_s3_key=<access key>
;archive_s3_secret=<secret>
;archive_s3_bucket=<bucket>
;archive_s3_url=http://s3.amazonaws.com/
```

## ec2Locations.customUserDataSecret
If you would like to use ec2 AMI's but would prefer to create the secret outside of the chart then supply the name of the secret here

## Future
* Add options for 'locations.ini' from configmap so you can use other agents
