## Kong for Kubernetes

[Kong for Kubernetes](https://github.com/Kong/kubernetes-ingress-controller)
is an open-source Ingress Controller for Kubernetes that offers
API management capabilities with a plugin architecture.

This chart bootstraps all the components needed to run Kong on a
[Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## TL;DR;

```bash
$ helm repo update
$ helm install stable/kong
```

## Table of content

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Uninstall](#uninstall)
- [Kong Enterprise](#kong-enterprise)
- [FAQs](#faqs)
- [Deployment Options](#deployment-options)
  - [Database](#database)
  - [Runtime package](#runtime-package)
  - [Configuration method](#configuration-method)
- [Configuration](#configuration)
  - [Kong Parameters](#kong-parameters)
  - [Ingress Controller Parameters](#ingress-controller-parameters)
  - [General Parameters](#general-parameters)
  - [The `env` section](#the-env-section)
- [Kong Enterprise Parameters](#kong-enterprise-parameters)
  - [Prerequisites](#prerequisites-1)
    - [Kong Enterprise License](#kong-enterprise-license)
    - [Kong Enterprise Docker registry access](#kong-enterprise-docker-registry-access)
  - [Service location hints](#service-location-hints)
  - [RBAC](#rbac)
  - [Sessions](#sessions)
  - [Email/SMTP](#emailsmtp)
- [Changelog](#changelog)
- [Seeking help](#seeking-help)

## Prerequisites

- Kubernetes 1.12+
- PV provisioner support in the underlying infrastructure if persistence
  is needed for Kong datastore.

## Install

To install the chart with the release name `my-release`:

```bash
$ helm repo update
$ helm install --name my-release stable/kong
```

## Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the
chart and deletes the release.

> **Tip**: List all releases using `helm list`

## FAQs

Please read the
[FAQs](https://github.com/helm/charts/blob/master/stable/kong/FAQs.md)
document.

## Kong Enterprise

If using Kong Enterprise, several additional steps are necessary before
installing the chart:

- set `enterprise.enabled` to `true` in `values.yaml` file
- Update values.yaml to use a Kong Enterprise image
- Satisfy the two  prerequsisites below for
  [Enterprise License](#kong-enterprise-license) and
  [Enterprise Docker Registry](#kong-enterprise-docker-registry-access)

Once you have these set, it is possible to install Kong Enterprise

Please read through
[Kong Enterprise considerations](#kong-enterprise-parameters)
to understand all settings that are enterprise specific.

## Deployment Options

Kong is a highly configurable piece of software that can be deployed
in a number of different ways, depending on your use-case.

All combinations of various runtimes, databases and configuration methods are
supported by this Helm chart.
The recommended approach is to use the Ingress Controller based configuration
along-with DB-less mode.

Following sections detail on various high-level architecture options available:

### Database

Kong can run with or without a database (DB-less).
By default, this chart installs Kong without a database.

Although Kong can run with Postgres and Cassandra, the recommended database,
if you would like to use one, is Postgres for Kubernetes installations.
If your use-case warrants Cassandra, you should run the Cassandra cluster
outside of Kubernetes.

The database to use for Kong can be controlled via the `env.database` parameter.
For more details, please read the [env](#the-env-section) section.

Furthermore, this chart allows you to bring your own database that you manage
or spin up a new Postgres instance using the `postgres.enabled` parameter.

> Cassandra deployment via a sub-chart was previously supported but
the support has now been dropped due to stability issues.
You can still deploy Cassandra on your own and configure Kong to use
that via the `env.database` parameter.

#### DB-less  deployment

When deploying Kong in DB-less mode(`env.database: "off"`)
and without the Ingress Controller(`ingressController.enabled: false`),
you have to provide a declarative configuration for Kong to run.
The configuration can be provided using an existing ConfigMap
(`dblessConfig.configMap`) or or the whole configuration can be put into the
`values.yaml` file for deployment itself, under the `dblessConfig.config`
parameter. See the example configuration in the default values.yaml
for more details.

### Runtime package

There are three different packages of Kong that are available:

- **Kong Gateway**  
  This is the [Open-Source](https://github.com/kong/kong) offering. It is a
  full-blown API Gateway and Ingress solution with a wide-array of functionality.
  When Kong Gateway is combined with the Ingress based configuration method,
  you get Kong for Kubernetes. This is the default deployment for this Helm
  Chart.
- **Kong Enterprise K8S**  
  This package builds up on top of the Open-Source Gateway and bundles in all
  the Enterprise-only plugins as well.
  When Kong Enterprise K8S is combined with the Ingress based
  configuration method, you get Kong for Kubernetes Enterprise.
  This package also comes with 24x7 support from Kong Inc.
- **Kong Enterprise**  
  This is the full-blown Enterprise package which packs with itself all the
  Enterprise functionality like Manager, Portal, Vitals, etc.
  This package can't be run in DB-less mode.

The package to run can be changed via `image.repository` and `image.tag`
parameters. If you would like to run the Enterprise package, please read
the [Kong Enterprise Parameters](#kong-enterprise-parameters) section.

### Configuration method

Kong can be configured via two methods:
- **Ingress and CRDs**  
  The configuration for Kong is done via `kubectl` and Kubernetes-native APIs.
  This is also known as Kong Ingress Controller or Kong for Kubernetes and is
  the default deployment pattern for this Helm Chart. The configuration
  for Kong is managed via Ingress and a few
  [Custom Resources](https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/concepts/custom-resources.md).
  For more details, please read the
  [documentation](https://github.com/Kong/kubernetes-ingress-controller/tree/master/docs)
  on Kong Ingress Controller.
  To configure and fine-tune the controller, please read the
  [Ingress Controller Parameters](#ingress-controller-parameters) section.
- **Admin API**  
  This is the traditional method of running and configuring Kong.
  By default, the Admin API of Kong is not exposed as a Service. This
  can be controlled via `admin.enabled` and `env.admin_listen` parameters.

## Configuration

### Kong parameters

| Parameter                          | Description                                                                           | Default             |
| ---------------------------------- | ------------------------------------------------------------------------------------- | ------------------- |
| image.repository                   | Kong image                                                                            | `kong`              |
| image.tag                          | Kong image version                                                                    | `1.3`               |
| image.pullPolicy                   | Image pull policy                                                                     | `IfNotPresent`      |
| image.pullSecrets                  | Image pull secrets                                                                    | `null`              |
| replicaCount                       | Kong instance count                                                                   | `1`                 |
| admin.enabled                      | Create Admin Service                                                                  | `false`             |
| admin.useTLS                       | Secure Admin traffic                                                                  | `true`              |
| admin.servicePort                  | TCP port on which the Kong admin service is exposed                                   | `8444`              |
| admin.containerPort                | TCP port on which Kong app listens for admin traffic                                  | `8444`              |
| admin.nodePort                     | Node port when service type is `NodePort`                                             |                     |
| admin.hostPort                     | Host port to use for admin traffic                                                    |                     |
| admin.type                         | k8s service type, Options: NodePort, ClusterIP, LoadBalancer                          | `NodePort`          |
| admin.loadBalancerIP               | Will reuse an existing ingress static IP for the admin service                        | `null`              |
| admin.loadBalancerSourceRanges     | Limit admin access to CIDRs if set and service type is `LoadBalancer`                 | `[]`                |
| admin.ingress.enabled              | Enable ingress resource creation (works with proxy.type=ClusterIP)                    | `false`             |
| admin.ingress.tls                  | Name of secret resource, containing TLS secret                                        |                     |
| admin.ingress.hosts                | List of ingress hosts.                                                                | `[]`                |
| admin.ingress.path                 | Ingress path.                                                                         | `/`                 |
| admin.ingress.annotations          | Ingress annotations. See documentation for your ingress controller for details        | `{}`                |
| proxy.http.enabled                 | Enables http on the proxy                                                             | true                |
| proxy.http.servicePort             | Service port to use for http                                                          | 80                  |
| proxy.http.containerPort           | Container port to use for http                                                        | 8000                |
| proxy.http.nodePort                | Node port to use for http                                                             | 32080               |
| proxy.http.hostPort                | Host port to use for http                                                             |                     |
| proxy.tls.enabled                  | Enables TLS on the proxy                                                              | true                |
| proxy.tls.containerPort            | Container port to use for TLS                                                         | 8443                |
| proxy.tls.servicePort              | Service port to use for TLS                                                           | 8443                |
| proxy.tls.nodePort                 | Node port to use for TLS                                                              | 32443               |
| proxy.tls.hostPort                 | Host port to use for TLS                                                              |                     |
| proxy.tls.overrideServiceTargetPort| Override service port to use for TLS without touching Kong containerPort              |                     |
| proxy.type                         | k8s service type. Options: NodePort, ClusterIP, LoadBalancer                          | `LoadBalancer`      |
| proxy.clusterIP                    | k8s service clusterIP                                                                 |                     |
| proxy.loadBalancerSourceRanges     | Limit proxy access to CIDRs if set and service type is `LoadBalancer`                 | `[]`                |
| proxy.loadBalancerIP               | To reuse an existing ingress static IP for the admin service                          |                     |
| proxy.externalIPs                  | IPs for which nodes in the cluster will also accept traffic for the proxy             | `[]`                |
| proxy.externalTrafficPolicy        | k8s service's externalTrafficPolicy. Options: Cluster, Local                          |                     |
| proxy.ingress.enabled              | Enable ingress resource creation (works with proxy.type=ClusterIP)                    | `false`             |
| proxy.ingress.tls                  | Name of secret resource, containing TLS secret                                        |                     |
| proxy.ingress.hosts                | List of ingress hosts.                                                                | `[]`                |
| proxy.ingress.path                 | Ingress path.                                                                         | `/`                 |
| proxy.ingress.annotations          | Ingress annotations. See documentation for your ingress controller for details        | `{}`                |
| plugins                            | Install custom plugins into Kong via ConfigMaps or Secrets                            | `{}`                |
| env                                | Additional [Kong configurations](https://getkong.org/docs/latest/configuration/)      |                     |
| runMigrations                      | Run Kong migrations job                                                               | `true`              |
| waitImage.repository               | Image used to wait for database to become ready                                       | `busybox`           |
| waitImage.tag                      | Tag for image used to wait for database to become ready                               | `latest`            |
| waitImage.pullPolicy               | Wait image pull policy                                                                | `IfNotPresent`      |
| postgresql.enabled                 | Spin up a new postgres instance for Kong                                              | `false`             |
| dblessConfig.configMap             | Name of an existing ConfigMap containing the `kong.yml` file. This must have the key `kong.yml`.| `` |
| dblessConfig.config                | Yaml configuration file for the dbless (declarative) configuration of Kong | see in `values.yaml`    |

### Ingress Controller Parameters

All of the following properties are nested under the `ingressController`
section of `values.yaml` file:

| Parameter                          | Description                                                                           | Default                                                                      |
| ---------------------------------- | ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| enabled                            | Deploy the ingress controller, rbac and crd                                           | true                                                                         |
| replicaCount                       | Number of desired ingress controllers                                                 | 1                                                                            |
| image.repository                   | Docker image with the ingress controller                                              | kong-docker-kubernetes-ingress-controller.bintray.io/kong-ingress-controller |
| image.tag                          | Version of the ingress controller                                                     | 0.7.0                                                                        |
| readinessProbe                     | Kong ingress controllers readiness probe                                              |                                                                              |
| livenessProbe                      | Kong ingress controllers liveness probe                                               |                                                                              |
| env                                | Specify Kong Ingress Controller configuration via environment variables               |                                                                              |
| ingressClass                       | The ingress-class value for controller                                                | kong                                                                         |
| admissionWebhook.enabled           | Whether to enable the validating admission webhook                                    | false                                                                        |
| admissionWebhook.failurePolicy     | How unrecognized errors from the admission endpoint are handled (Ignore or Fail)      | Fail                                                                         |
| admissionWebhook.port              | The port the ingress controller will listen on for admission webhooks                 | 8080                                                                         |

For a complete list of all configuration values you can set in the 
`env` section, please read the Kong Ingress Controller's
[configuration document](https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/references/cli-arguments.md).

### General Parameters

| Parameter                          | Description                                                                           | Default             |
| ---------------------------------- | ------------------------------------------------------------------------------------- | ------------------- |
| updateStrategy                     | update strategy for deployment                                                        | `{}`                |
| readinessProbe                     | Kong readiness probe                                                                  |                     |
| livenessProbe                      | Kong liveness probe                                                                   |                     |
| affinity                           | Node/pod affinities                                                                   |                     |
| nodeSelector                       | Node labels for pod assignment                                                        | `{}`                |
| podAnnotations                     | Annotations to add to each pod                                                        | `{}`                |
| resources                          | Pod resource requests & limits                                                        | `{}`                |
| tolerations                        | List of node taints to tolerate                                                       | `[]`                |
| podDisruptionBudget.enabled        | Enable PodDisruptionBudget for Kong                                                   | `false`             |
| podDisruptionBudget.maxUnavailable | Represents the minimum number of Pods that can be unavailable (integer or percentage) | `50%`               |
| podDisruptionBudget.minAvailable   | Represents the number of Pods that must be available (integer or percentage)          |                     |
| podSecurityPolicy.enabled          | Enable podSecurityPolicy for Kong                                                     | `false`             |
| serviceMonitor.enabled             | Create ServiceMonitor for Prometheus Operator                                         | false               |
| serviceMonitor.interval            | Scrapping interval                                                                    | 10s                 |
| serviceMonitor.namespace           | Where to create ServiceMonitor                                                        |                     |
| secretVolumes                      | Mount given secrets as a volume in Kong container to override default certs and keys. | `[]`                |
| serviceMonitor.labels              | ServiceMonito Labels                                                                  | {}                  |

#### The `env` section

The `env` section can be used to configured all properties of Kong.
Any key value put under this section translates to environment variables
used to control Kong's configuration. Every key is prefixed with `KONG_`
and upper-cased before setting the environment variable.

Furthermore, all `kong.env` parameters can also accept a mapping instead of a
value to ensure the parameters can be set through configmaps and secrets.

An example :

```yaml
kong:
  env:                       # load PG password from a secret dynamically
     pg_user: kong
     pg_password:
       valueFrom:
         secretKeyRef:
            key: kong
            name: postgres
  nginx_worker_processes: "2"
```

For complete list of Kong configurations please check the
[Kong configuration docs](https://docs.konghq.com/latest/configuration).

> **Tip**: You can use the default [values.yaml](values.yaml)

##### Admin/Proxy listener override

If you specify `env.admin_listen` or `env.proxy_listen`, this chart will use
the value provided by you as opposed to constructing a listen variable
from fields like `proxy.http.containerPort` and `proxy.http.enabled`.
This allows you to be more prescriptive when defining listen directives.

**Note:** Overriding `env.proxy_listen` and `env.admin_listen` will
potentially cause `admin.containerPort`, `proxy.http.containerPort` and
`proxy.tls.containerPort` to become out of sync,
and therefore must be updated accordingly.

For example, updating to `env.proxy_listen: 0.0.0.0:4444, 0.0.0.0:4443 ssl`
will need `proxy.http.containerPort: 4444` and `proxy.tls.containerPort: 4443`
to be set in order for the service definition to work properly.

## Kong Enterprise Parameters

### Overview

Kong Enterprise requires some additional configuration not needed when using
Kong Open-Source. To use Kong Enterprise, at the minimum,
you need to do the following:

- set `enterprise.enabled` to `true` in `values.yaml` file
- Update values.yaml to use a Kong Enterprise image
- Satisfy the two  prerequsisites below for Enterprise License and
  Enterprise Docker Registry

Once you have these set, it is possible to install Kong Enterprise,
but please make sure to review the below sections for other settings that
you should consider configuring before installing Kong.

Some of the more important configuration is grouped in sections
under the `.enterprise` key in values.yaml, though most enterprise-specific
configuration can be placed under the `.env` key.

### Prerequisites

#### Kong Enterprise License

All Kong Enterprise deployments require a license. If you do not have a copy
of yours, please contact Kong Support. Once you have it, you will need to
store it in a Secret. Save your secret in a file named `license` (no extension)
and then create and inspect your secret:

```bash
$ kubectl create secret generic kong-enterprise-license --from-file=./license
```

Set the secret name in `values.yaml`, in the `.enterprise.license_secret` key.
Please ensure the above secret is created in the same namespace in which
Kong is going to be deployed.

#### Kong Enterprise Docker registry access

Next, we need to setup Docker credentials in order to allow Kubernetes
nodes to pull down Kong Enterprise Docker image, which is hosted as a private
repository.

As part of your sign up for Kong Enterprise, you should have received
credentials for these as well.

```bash
$ kubectl create secret docker-registry kong-enterprise-docker \
    --docker-server=kong-docker-kong-enterprise-k8s.bintray.io \
    --docker-username=<your-username> \
    --docker-password=<your-password>
secret/kong-enterprise-docker created
```

Set the secret name in `values.yaml` in the `image.pullSecrets` section.
Again, Please ensure the above secret is created in the same namespace in which
Kong is going to be deployed.

### Service location hints

Kong Enterprise add two GUIs, Kong Manager and the Kong Developer Portal, that
must know where other Kong services (namely the admin and files APIs) can be
accessed in order to function properly. Kong's default behavior for attempting
to locate these absent configuration is unlikely to work in common Kubernetes
environments. Because of this, you should set each of `admin_gui_url`,
`admin_api_uri`, `proxy_url`, `portal_api_url`, `portal_gui_host`, and
`portal_gui_protocol` under the `.env` key in values.yaml to locations where
each of their respective services can be accessed to ensure that Kong services
can locate one another and properly set CORS headers. See the
[Property Reference documentation](https://docs.konghq.com/enterprise/latest/property-reference/)
for more details on these settings.

### RBAC

You can create a default RBAC superuser when initially setting up an
environment, by setting the `KONG_PASSWORD` environment variable on the initial
migration Job's Pod. This will create a `kong_admin` admin whose token and
basic-auth password match the value of `KONG_PASSWORD`.
You can create a secret holding the initial password value and then
mount the secret as an environment variable using the `env` section.

Note that RBAC is **NOT** currently enabled on the admin API container for the
controller Pod when the ingress controller is enabled. This admin API container
is not exposed outside the Pod, so only the controller can interact with it. We
intend to add RBAC to this container in the future after updating the controller
to add support for storing its RBAC token in a Secret, as currently it would
need to be stored in plaintext. RBAC is still enforced on the admin API of the
main deployment when using the ingress controller, as that admin API *is*
accessible outside the Pod.

### Sessions

Login sessions for Kong Manager and the Developer Portal make use of
[the Kong Sessions plugin](https://docs.konghq.com/enterprise/latest/kong-manager/authentication/sessions).
Their configuration must be stored in Secrets, as it contains an HMAC key.
If using either RBAC or the Portal, create a Secret with `admin_gui_session_conf`
and `portal_session_conf` keys.

```
$ cat admin_gui_session_conf
{"cookie_name":"admin_session","cookie_samesite":"off","secret":"admin-secret-CHANGEME","cookie_secure":true,"storage":"kong"}
$ cat portal_session_conf
{"cookie_name":"portal_session","cookie_samesite":"off","secret":"portal-secret-CHANGEME","cookie_secure":true,"storage":"kong"}
$ kubectl create secret generic kong-session-config --from-file=admin_gui_session_conf --from-file=portal_session_conf
secret/kong-session-config created
```
The exact plugin settings may vary in your environment. The `secret` should
always be changed for both configurations.

After creating your secret, set its name in values.yaml, in the
`.enterprise.rbac.session_conf_secret` and
`.enterprise.portal.session_conf_secret` keys.

### Email/SMTP

Email is used to send invitations for
[Kong Admins](https://docs.konghq.com/enterprise/latest/kong-manager/networking/email)
and [Developers](https://docs.konghq.com/enterprise/latest/developer-portal/configuration/smtp).

Email invitations rely on setting a number of SMTP settings at once. For
convenience, these are grouped under the `.enterprise.smtp` key in values.yaml.
Setting `.enterprise.smtp.disabled: true` will set `KONG_SMTP_MOCK=on` and
allow Admin/Developer invites to proceed without sending email. Note, however,
that these have limited functionality without sending email.

If your SMTP server requires authentication, you should the `username` and
`smtp_password_secret` keys under `.enterprise.smtp.auth`.
`smtp_password_secret` must be a Secret containing an `smtp_password` key whose
value is your SMTP password.

## Changelog

### 0.36.5

> PR https://github.com/helm/charts/pull/20099

#### Improvements

- Allow `grpc` protocol for KongPlugins

### 0.36.4

> PR https://github.com/helm/charts/pull/20051

#### Fixed

- Issue: [`Ingress Controller errors when chart is redeployed with Admission
  Webhook enabled`](https://github.com/helm/charts/issues/20050)

### 0.36.3

> PR https://github.com/helm/charts/pull/19992

#### Fixed

- Fix spacing in ServiceMonitor when label is specified in config

### 0.36.2

> PR https://github.com/helm/charts/pull/19955

#### Fixed

- Set `sideEffects` and `admissionReviewVersions` for Admission Webhook
- timeouts for liveness and readiness probes has been changed from `1s` to `5s`

### 0.36.1

> PR https://github.com/helm/charts/pull/19946

#### Fixed

- Added missing watch permission to custom resources

### 0.36.0

> PR https://github.com/helm/charts/pull/19916

#### Upgrade Instructions

- When upgrading from <0.35.0, in-place chart upgrades will fail.
  It is necessary to delete the helm release with `helm del --purge $RELEASE` and redeploy from scratch.
  Note that this will cause downtime for the kong proxy. 

#### Improvements 

- Fixed Deployment's label selector that prevented in-place chart upgrades.

### 0.35.1

> PR https://github.com/helm/charts/pull/19914

#### Improvements

- Update CRDs to Ingress Controller 0.7
- Optimize readiness and liveness probes for more responsive health checks
- Fixed incorrect space in NOTES.txt

### 0.35.0

> PR [#19856](https://github.com/helm/charts/pull/19856)

#### Improvements

- Labels on all resources have been updated to adhere to the Helm Chart
  guideline here:
  https://v2.helm.sh/docs/developing_charts/#syncing-your-chart-repository

### 0.34.2

> PR [#19854](https://github.com/helm/charts/pull/19854)

This release contains no user-visible changes

#### Under the hood

 - Various tests have been consolidated to speed up CI.

### 0.34.1

> PR [#19887](https://github.com/helm/charts/pull/19887)

#### Fixed

- Correct indentation for Job securityContexts.

### 0.34.0

> PR [#19885](https://github.com/helm/charts/pull/19885)

#### New features

- Update default version of Ingress Controller to 0.7.0

### 0.33.1

> PR [#19852](https://github.com/helm/charts/pull/19852)

#### Fixed

- Correct an issue with white space handling within `final_env` helper.

### 0.33.0

> PR [#19840](https://github.com/helm/charts/pull/19840)

#### Dependencies

- Postgres sub-chart has been bumped up to 8.1.2

#### Fixed

- Removed podDisruption budge for Ingress Controller. Ingress Controller and
  Kong run in the same pod so this was no longer applicable
- Migration job now receives the same environment variable and configuration
  as that of the Kong pod.
- If Kong is configured to run with Postgres, the Kong pods now always wait
  for Postgres to start. Previously this was done only when the sub-chart
  Postgres was deployed.
- A hard-coded container name is used for kong: `proxy`. Previously this
  was auto-generated by Helm. This deterministic naming allows for simpler
  scripts and documentation.

#### Under the hood

Following changes have no end user visible effects:

- All Custom Resource Definitions have been consolidated into a single
  template file
- All RBAC resources have been consolidated into a single template file
- `wait-for-postgres` container has been refactored and de-duplicated

### 0.32.1

#### Improvements

- This is a doc only release. No code changes have been done.
- Post installation steps have been simplified and now point to a getting
  started page
- Misc updates to README:
  - Document missing variables
  - Remove outdated variables
  - Revamp and rewrite major portions of the README
  - Added a table of content to make the content navigable

### 0.32.0

#### Improvements

- Create and mount emptyDir volumes for `/tmp` and `/kong_prefix` to allow
  for read-only root filesystem securityContexts and PodSecurityPolicys.
- Use read-only mounts for custom plugin volumes.
- Update stock PodSecurityPolicy to allow emptyDir access.
- Override the standard `/usr/local/kong` prefix to the mounted emptyDir
  at `/kong_prefix` in `.Values.env`.
- Add securityContext injection points to template. By default,
  it sets Kong pods to run with UID 1000.

#### Fixes

- Correct behavior for the Vitals toggle.
  Vitals defaults to on in all current Kong Enterprise releases, and
  the existing template only created the Vitals environment variable
  if `.Values.enterprise.enabled == true`. Inverted template to create
  it (and set it to "off") if that setting is instead disabled.
- Correct an issue where custom plugin configurations would block Kong
  from starting.

### 0.31.0

#### Breaking changes

- Admin Service is disabled by default (`admin.enabled`)
- Default for `proxy.type` has been changed to `LoadBalancer`

#### New features

- Update default version of Kong to 1.4
- Update default version of Ingress Controller to 0.6.2
- Add support to disable kong-admin service via `admin.enabled` flag.

### 0.31.2

#### Fixes

- Do not remove white space between documents when rendering
  `migrations-pre-upgrade.yaml`

### 0.30.1

#### New Features

- Add support for specifying Proxy service ClusterIP

### 0.30.0

#### Breaking changes

- `admin_gui_auth_conf_secret` is now required for Kong Manager
  authentication methods other than `basic-auth`.
  Users defining values for `admin_gui_auth_conf` should migrate them to
  an externally-defined secret with a key of `admin_gui_auth_conf` and
  reference the secret name in `admin_gui_auth_conf_secret`.

### 0.29.0

#### New Features

- Add support for specifying Ingress Controller environment variables.

### 0.28.0

#### New Features

- Added support for the Validating Admission Webhook with the Ingress Controller.

### 0.27.2

#### Fixes

- Do not create a ServiceAccount if it is not necessary.
- If a configuration change requires creating a ServiceAccount,
  create a temporary ServiceAccount to allow pre-upgrade tasks to
  complete before the regular ServiceAccount is created.

### 0.27.1

#### Documentation updates
- Retroactive changelog update for 0.24 breaking changes.

### 0.27.0

#### Breaking changes

- DB-less mode is enabled by default.
- Kong is installed as an Ingress Controller for the cluster by default.

### 0.25.0

#### New features

- Add support for PodSecurityPolicy
- Require creation of a ServiceAccount

### 0.24.0

#### Breaking changes

- The configuration format for ingresses in values.yaml has changed. 
Previously, all ingresses accepted an array of hostnames, and would create
ingress rules for each. Ingress configuration for services other than the proxy
now accepts a single hostname, which allows simpler TLS configuration and
automatic population of `admin_api_uri` and similar settings. Configuration for
the proxy ingress is unchanged, but its documentation now accurately reflects
the TLS configuration needed.

## Seeking help

If you run into an issue, bug or have a question, please reach out to the Kong
community via [Kong Nation](https://discuss.konghq.com).
Please do not open issues in [this](https://github.com/helm/charts) repository
as the maintainers will not be notified and won't respond.
