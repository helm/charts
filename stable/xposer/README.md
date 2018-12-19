# Xposer

## Problem
We would like to watch for services running in our cluster; and create Ingresses and generate TLS certificates automatically

## Solution
Xposer can watch for all the services running in our cluster; Creates, Updates, Deletes Ingresses and uses certmanager to generate TLS certificates automatically based on some annotations.

## How to use Xposer

### Config
The default config of Xposer is located at /configs/config.yaml

```
domain: stakater.com
ingressURLTemplate: "{{.Service}}.{{.Namespace}}.{{.Domain}}"
ingressURLPath: /
ingressNameTemplate: "{{.Service}}"
tls: false
```

Each property is explained below in details

For Xposer to  work on your service, it must have a label "expose = true"

```bash
kind: Service
apiVersion: v1
metadata:
  labels:
    expose: 'true'
```

### Kubernetes

#### Ingresses

Xposer reads the following annotations from a service
```bash
kind: Service
apiVersion: v1
metadata:
  labels:
    expose: 'true'
  annotations:
    xposer.stakater.com/annotations: |-
       firstAnnotation : abc
       secondAnnotation: abc
       thirdAnnotation: abc
```
xposer.stakater.com/annotations accepts annotations in new line. All the annotations provided here will be forwarded to Ingress as it is.

```bash
kind: Service
apiVersion: v1
metadata:
  labels:
    expose: 'true'
  annotations:
    config.xposer.stakater.com/IngressNameTemplate: "{{.Service}}-{{.Namespace}}"
    config.xposer.stakater.com/IngressURLTemplate: "{{.Service}}.{{.Domain}}"
    config.xposer.stakater.com/IngressURLPath: "/"
    config.xposer.stakater.com/Domain: domain.com
    config.xposer.stakater.com/TLS: "true"
```
The above 5 annotations are used to generate Ingress, if not provided default annotations from /configs/config.yaml will be used. 3 variables used are:
1. {{.Service}} = Name of the service which is created/updated
2. {{.Namespace}} = Namespace in which Xposer is running
3. {{.Domain}} = Default domain from /configs/config.yaml file. Can be changed there.

The above 5 annotations are for the following purpose:

1. config.xposer.stakater.com/IngressNameTemplate: With this annotation we can templatize generated Ingress Name. We can use the following template variables as well {{.Service}}, {{.Namespace}}. Can not include domain in Ingress name.

2. config.xposer.stakater.com/IngressURLTemplate: With this annotation we can templatize generated Ingress URL/Hostname. We can use all 3 variables to templatize it

3. config.xposer.stakater.com/IngressURLPath: With this annotation we can specify Ingress Path

4. config.xposer.stakater.com/Domain: With this annotation we can specify domain

5. config.xposer.stakater.com/TLS: With this annotation we can specify wether to use certmanager and generate a TLS certificate or not

#### Certmanager

First of all you need to install certmanager, and a Issuer/ClusterIssuer in your cluster. Xposer only needs 2 annotations to generate TLS certificates

```bash
kind: Service
apiVersion: v1
metadata:
  labels:
    expose: 'true'
  annotations:
    xposer.stakater.com/annotations: |-
       certmanager.k8s.io/cluster-issuer: your-cluster-issuer-name
    config.xposer.stakater.com/TLS: "true"
```
The above example use cluster issuer "certmanager.k8s.io/cluster-issuer:" annotation which will be forwaded to the ingress as it is with the installed issuer/cluster issuer name. 

The second annotation "config.xposer.stakater.com/TLS:" tells Xposer to add TLS information to the Ingress so it can communicate with the certmanager to generate certificates

### Openshift

Support for openshift routes will be added soon

## TL;DR;

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
helm install stable/xposer
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/xposer
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Usage

The following table lists the configurable parameters of the chart and its default values.

|              Parameter      |                    Description                     |                     Default                      |
| --------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `xposer.labels`                  | Labels to be used in `_helpers.tpl` class to create other labels                      | {}                                      |
| `xposer.image`                       | Container image name                            | `stakater/xposer`
            |
| `xposer.tag`                              | Container image tag                                     | `0.0.3`       
            |
| `xposer.pullPolicy`                       | Container image pull policy                             | `IfNotPresent`       
            |
| `xposer.configFilePath`               | Path to mount the config file of xposer              | `/configs/config.yaml`       
            |
| `xposer.deployment.annotations`                     | Annotations to apply on deployment                       | {}       
            |
| `xposer.config.domain`                          | domain name which will be used in the created ingress by xposer                            | 'mydomain.com'       
            |
| `xposer.config.ingressURLTemplate`                  | template to follow while creating url in the created ingress by xposer                     | `{{.Service}}.{{.Namespace}}.{{.Domain}}`     
            |
| `xposer.config.ingressURLPath`                  | template to follow while creating url path in the created ingress by xposer                     | `/`     
            |
| `xposer.config.ingressNameTemplate`                  | template to follow while creating ingress name                     | `{{.Service}}`     
            |
| `xposer.config.tls`                  | boolean check to generate a CA certficate using cert-manager                    | `false` 
            |


## Help

**Got a question?**
File a GitHub [issue](https://github.com/stakater/Xposer/issues), or send us an [email](mailto:stakater@gmail.com).

### Talk to us on Slack
Join and talk to us on the #tools-imc channel for discussing Xposer

[![Join Slack](https://stakater.github.io/README/stakater-join-slack-btn.png)](https://stakater-slack.herokuapp.com/)
[![Chat](https://stakater.github.io/README/stakater-chat-btn.png)](https://stakater.slack.com/messages/CAN960CTG/)

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/Xposer/issues) to report any bugs or file feature requests.

### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Changelog

View our closed [Pull Requests](https://github.com/stakater/Xposer/pulls?q=is%3Apr+is%3Aclosed).

## License

Apache2 © [Stakater](http://stakater.com)

## About

`Xposer` is maintained by [Stakater][website]. Like it? Please let us know at <hello@stakater.com>

See [our other projects][community]
or contact us in case of professional services and queries on <hello@stakater.com>

  [website]: http://stakater.com/
  [community]: https://github.com/stakater/