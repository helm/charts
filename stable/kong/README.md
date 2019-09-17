## Kong

[Kong](https://KongHQ.com/) is an open-source API Gateway and Microservices
Management Layer, delivering high performance and reliability.

## TL;DR;

```bash
$ helm install stable/kong
```

## Introduction

This chart bootstraps all the components needed to run Kong on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled.
- PV provisioner support in the underlying infrastructure if persistence
  is needed for Kong datastore.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/kong
```

If using Kong Enterprise, several additional steps are necessary before
installing the chart. At minimum, you must:
* Create a [license secret](#license).
* Set `enterprise.enabled: true` in values.yaml.
* Update values.yaml to use a Kong Enterprise image. If needed, follow the
instructions in values.yaml to add a registry pull secret.

Reading through [the full list of Enterprise considerations](#kong-enterprise-specific-parameters)
is recommended.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

### General Configuration Parameters

The following table lists the configurable parameters of the Kong chart
and their default values.

| Parameter                          | Description                                                                           | Default             |
| ---------------------------------- | ------------------------------------------------------------------------------------- | ------------------- |
| image.repository                   | Kong image                                                                            | `kong`              |
| image.tag                          | Kong image version                                                                    | `1.3`               |
| image.pullPolicy                   | Image pull policy                                                                     | `IfNotPresent`      |
| image.pullSecrets                  | Image pull secrets                                                                    | `null`              |
| replicaCount                       | Kong instance count                                                                   | `1`                 |
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
| proxy.type                         | k8s service type. Options: NodePort, ClusterIP, LoadBalancer                          | `NodePort`          |
| proxy.loadBalancerSourceRanges     | Limit proxy access to CIDRs if set and service type is `LoadBalancer`                 | `[]`                |
| proxy.loadBalancerIP               | To reuse an existing ingress static IP for the admin service                          |                     |
| proxy.externalIPs                  | IPs for which nodes in the cluster will also accept traffic for the proxy             | `[]`                |
| proxy.externalTrafficPolicy        | k8s service's externalTrafficPolicy. Options: Cluster, Local                          |                     |
| proxy.ingress.enabled              | Enable ingress resource creation (works with proxy.type=ClusterIP)                    | `false`             |
| proxy.ingress.tls                  | Name of secret resource, containing TLS secret                                        |                     |
| proxy.ingress.hosts                | List of ingress hosts.                                                                | `[]`                |
| proxy.ingress.path                 | Ingress path.                                                                         | `/`                 |
| proxy.ingress.annotations          | Ingress annotations. See documentation for your ingress controller for details        | `{}`                |
| updateStrategy                     | update strategy for deployment                                                        | `{}`                |
| env                                | Additional [Kong configurations](https://getkong.org/docs/latest/configuration/)      |                     |
| runMigrations                      | Run Kong migrations job                                                               | `true`              |
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
| serviceMonitor.enabled             | Create ServiceMonitor for Prometheus Operator                                         | false               |
| serviceMonitor.interval            | Scrapping interval                                                                    | 10s                 |
| serviceMonitor.namespace           | Where to create ServiceMonitor                                                        |                     |

### Admin/Proxy listener override

If you specify `env.admin_listen` or `env.proxy_listen`, this chart will use
the value provided by you as opposed to constructing a listen variable
from fields like `proxy.http.containerPort` and `proxy.http.enabled`. This allows
you to be more prescriptive when defining listen directives.

**Note:** Overriding `env.proxy_listen` and `env.admin_listen` will potentially cause
`admin.containerPort`, `proxy.http.containerPort` and `proxy.tls.containerPort` to become out of sync,
and therefore must be updated accordingly.

I.E. updatating to `env.proxy_listen: 0.0.0.0:4444, 0.0.0.0:4443 ssl` will need
`proxy.http.containerPort: 4444` and `proxy.tls.containerPort: 4443` to be set in order
for the service definition to work properly.

### Kong-specific parameters

Kong has a choice of either Postgres or Cassandra as a backend datatstore.
This chart allows you to choose either of them with the `env.database`
parameter.  Postgres is chosen by default.

Additionally, this chart allows you to use your own database or spin up a new
instance by using the `postgres.enabled` or `cassandra.enabled` parameters.
Enabling both will create both databases in your cluster, but only one
will be used by Kong based on the `env.database` parameter.
Postgres is enabled by default.

| Parameter                     | Description                                                             | Default               |
| ------------------------------| ------------------------------------------------------------------------| ----------------------|
| cassandra.enabled             | Spin up a new cassandra cluster for Kong                                | `false`               |
| postgresql.enabled            | Spin up a new postgres instance for Kong                                | `true`                |
| waitImage.repository          | Image used to wait for database to become ready                         | `busybox`             |
| waitImage.tag                 | Tag for image used to wait for database to become ready                 | `latest`              |
| env.database                  | Choose either `postgres`, `cassandra` or `"off"` (for dbless mode)      | `postgres`            |
| env.pg_user                   | Postgres username                                                       | `kong`                |
| env.pg_database               | Postgres database name                                                  | `kong`                |
| env.pg_password               | Postgres database password (required if you are using your own database)| `kong`                |
| env.pg_host                   | Postgres database host (required if you are using your own database)    | ``                    |
| env.pg_port                   | Postgres database port                                                  | `5432`                |
| env.cassandra_contact_points  | Cassandra contact points (required if you are using your own database)  | ``                    |
| env.cassandra_port            | Cassandra query port                                                    | `9042`                |
| env.cassandra_keyspace        | Cassandra keyspace                                                      | `kong`                |
| env.cassandra_repl_factor     | Replication factor for the Kong keyspace                                | `2`                   |
| dblessConfig.configMap        | Name of an existing ConfigMap containing the `kong.yml` file. This must have the key `kong.yml`.| `` |
| dblessConfig.config           | Yaml configuration file for the dbless (declarative) configuration of Kong | see in `values.yaml`    |

All `kong.env` parameters can also accept a mapping instead of a value to ensure the parameters can be set through configmaps and secrets.

An example :

```yaml
kong:
  env:
     pg_user: kong
     pg_password:
       valueFrom:
         secretKeyRef:
            key: kong
            name: postgres
```


For complete list of Kong configurations please check https://getkong.org/docs/latest/configuration/.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kong --name my-release \
  --set=image.tag=1.3,env.database=cassandra,cassandra.enabled=true
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install stable/kong --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Kong Enterprise-specific parameters

Kong Enterprise requires some additional configuration not needed when using
Kong OSS. Some of the more important configuration is grouped in sections
under the `.enterprise` key in values.yaml, though most enterprise-specific
configuration can be placed under the `.env` key.

To use Kong Enterprise, change your image to a Kong Enterprise image and set
`.enterprise.enabled: true` in values.yaml to render Enterprise sections of the
templates. Review the sections below for other settings you should consider
configuring before installing the chart.

#### Service location hints

Kong Enterprise add two GUIs, Kong Manager and the Kong Developer Portal, that
must know where other Kong services (namely the admin and files APIs) can be
accessed in order to function properly. Kong's default behavior for attempting
to locate these absent configuration is unlikely to work in common Kubernetes
environments. Because of this, you should set each of `admin_gui_url`,
`admin_api_uri`, `proxy_url`, `portal_api_url`, `portal_gui_host`, and
`portal_gui_protocol` under the `.env` key in values.yaml to locations where
each of their respective services can be accessed to ensure that Kong services
can locate one another and properly set CORS headers. See the [Property Reference documentation](https://docs.konghq.com/enterprise/0.35-x/property-reference/)
for more details on these settings.

#### License

All Kong Enterprise deployments require a license. If you do not have a copy
of yours, please contact Kong Support. Once you have it, you will need to
store it in a Secret. Save your secret in a file named `license` (no extension)
and then create and inspect your secret:

```
$ kubectl create secret generic kong-enterprise-license --from-file=./license
$ kubectl get secret kong-enterprise-license -o yaml
apiVersion: v1
data:
  license: eyJsaWNlbnNlIjp7InNpZ25hdHVyZSI6IkhFWSBJIFNFRSBZT1UgUEVFS0lORyBJTlNJREUgTVkgQkFTRTY0IEVYQU1QTEUiLCJwYXlsb2FkIjp7ImN1c3RvbWVyIjoiV0VMTCBUT08gQkFEIiwibGljZW5zZV9jcmVhdGlvbl9kYXRlIjoiMjAxOC0wNi0wNSIsInByb2R1Y3Rfc3Vic2NyaXB0aW9uIjoiVEhFUkVTIE5PVEhJTkcgSEVSRSIsImFkbWluX3NlYXRzIjoiNSIsInN1cHBvcnRfcGxhbiI6IkZha2UiLCJsaWNlbnNlX2V4cGlyYXRpb25fZGF0ZSI6IjIwMjAtMjAtMjAiLCJsaWNlbnNlX2tleSI6IlRTT0kgWkhJViJ9LCJ2ZXJzaW9uIjoxfX0K
kind: Secret
metadata:
  creationTimestamp: "2019-05-17T21:45:16Z"
  name: kong-enterprise-license
  namespace: default
  resourceVersion: "48695485"
  selfLink: /api/v1/namespaces/default/secrets/kong-enterprise-license
  uid: 0f2e8903-78ed-11e9-b1a6-42010a8a02ec
type: Opaque
```
Set the secret name in values.yaml, in the `.enterprise.license_secret` key.

#### RBAC

Note that you can create a default RBAC superuser when initially setting up an
environment, by setting the `KONG_PASSWORD` environment variable on the initial
migration Job's Pod. This will create a `kong_admin` admin whose token and
basic-auth password match the value of `KONG_PASSWORD`

Using RBAC within Kubernetes environments requires providing Kubernetes an RBAC
user for its readiness and liveness checks. We recommend creating a user that
has permission to read `/status` and nothing else. For example, with RBAC still
disabled:

```
$ curl -sX POST http://admin.kong.example/rbac/users --data name=statuschecker --data user_token=REPLACE_WITH_SOME_TOKEN
{"user_token_ident":"45239","user_token":"$2b$09$cL.xbvRQCzE35A0osl8VTej7u0BgJOIgpTVjxpwZ1U8.jNdMwyQRW","id":"fe8824dc-09a7-4b68-b5e6-541e4b9b4ced","name":"statuschecker","enabled":true,"comment":null,"created_at":1558131229}

$ curl -sX POST http://admin.kong.example/rbac/roles --data name=read-status
{"comment":null,"created_at":1558131353,"id":"e32507a5-e636-40b2-88c0-090042db7d79","name":"read-status","is_default":false}

$ curl -sX POST http://admin.kong.example/rbac/roles/read-status/endpoints --data endpoint="/status" --data actions=read
{"endpoint":"\/status","created_at":1558131423,"workspace":"default","actions":["read"],"negative":false,"role":{"id":"e32507a5-e636-40b2-88c0-090042db7d79"}}

$ curl -sX POST http://admin.kong.example/rbac/users/statuschecker/roles --data roles=read-status
{"roles":[{"created_at":1558131353,"id":"e32507a5-e636-40b2-88c0-090042db7d79","name":"read-status"}],"user":{"user_token_ident":"45239","user_token":"$2b$09$cL.xbvRQCzE35A0osl8VTej7u0BgJOIgpTVjxpwZ1U8.jNdMwyQRW","id":"fe8824dc-09a7-4b68-b5e6-541e4b9b4ced","name":"statuschecker","comment":null,"enabled":true,"created_at":1558131229}}
```
Probes will then need to include that user's token, e.g. for the readinessProbe:

```
readinessProbe:
  httpGet:
    path: "/status"
    port: admin
    scheme: HTTP
    httpHeaders:
      - name: Kong-Admin-Token
        value: REPLACE_WITH_SOME_TOKEN
    ...
```

Note that RBAC is **NOT** currently enabled on the admin API container for the
controller Pod when the ingress controller is enabled. This admin API container
is not exposed outside the Pod, so only the controller can interact with it. We
intend to add RBAC to this container in the future after updating the controller
to add support for storing its RBAC token in a Secret, as currently it would
need to be stored in plaintext. RBAC is still enforced on the admin API of the
main deployment when using the ingress controller, as that admin API *is*
accessible outside the Pod.

#### Sessions

Login sessions for Kong Manager and the Developer Portal make use of [the Kong
Sessions plugin](https://docs.konghq.com/enterprise/0.35-x/kong-manager/authentication/sessions/).
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
`.enterprise.rbac.session_conf_secret` keys.

#### Email/SMTP

Email is used to send invitations for [Kong Admins](https://docs.konghq.com/enterprise/enterprise/0.35-x/kong-manager/networking/email/)
and [Developers](https://docs.konghq.com/enterprise/enterprise/0.35-x/developer-portal/configuration/smtp/).

Email invitations rely on setting a number of SMTP settings at once. For
convenience, these are grouped under the `.enterprise.smtp` key in values.yaml.
Setting `.enterprise.smtp.disabled: true` will set `KONG_SMTP_MOCK=on` and
allow Admin/Developer invites to proceed without sending email. Note, however,
that these have limited functionality without sending email.

If your SMTP server requires authentication, you should the `username` and
`smtp_password_secret` keys under `.enterprise.smtp.auth`.
`smtp_password_secret` must be a Secret containing an `smtp_password` key whose
value is your SMTP password.

### DB-less Configuration


When deploying Kong in DB-less mode (`env.database: "off"`) and without the Ingress
Controller (`ingressController.enabled: false`), Kong needs a config to run. In
this case, configuration can be provided using an exsiting ConfigMap
(`dblessConfig.configMap`) or pushed directly into the values file under
`dblessConfig.config`. See the example configuration in the default values.yaml
for more details.

### Kong Ingress Controller

Kong Ingress Controller's primary purpose is to satisfy Ingress resources
created in your Kubernetes cluster.
It uses CRDs for more fine grained control over routing and
for Kong specific configuration.
To deploy the ingress controller together with
kong run the following command:

```bash
# without a database
helm install stable/kong --set ingressController.enabled=true \
  --set postgresql.enabled=false --set env.database=off
# with a database
helm install stable/kong --set ingressController.enabled=true
```

If you like to use a static IP:

```shell
helm install stable/kong --set ingressController.enabled=true --set proxy.loadBalancerIP=[Your IP goes there] --set proxy.type=LoadBalancer --name kong --namespace kong
```

**Note**: Kong Ingress controller doesn't support custom SSL certificates
on Admin port. We will be removing this limitation in the future.

Kong ingress controller relies on several Custom Resource Definition objects to
declare the the Kong configurations and synchronize the configuration with the
Kong admin API. Each of this new objects  declared in Kubernetes have a
one-to-one relation with a Kong resource.
The custom resources are:

- KongConsumer
- KongCredential
- KongPlugin
- KongIngress

You can can learn about kong ingress custom resource definitions [here](https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/custom-resources.md).


| Parameter                          | Description                                                                           | Default                                                                      |
| ---------------------------------- | ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| enabled                            | Deploy the ingress controller, rbac and crd                                           | false                                                                        |
| replicaCount                       | Number of desired ingress controllers                                                 | 1                                                                            |
| image.repository                   | Docker image with the ingress controller                                              | kong-docker-kubernetes-ingress-controller.bintray.io/kong-ingress-controller |
| image.tag                          | Version of the ingress controller                                                     | 0.2.0                                                                        |
| readinessProbe                     | Kong ingress controllers readiness probe                                              |                                                                              |
| livenessProbe                      | Kong ingress controllers liveness probe                                               |                                                                              |
| ingressClass                       | The ingress-class value for controller                                                | nginx                                                                        |
| podDisruptionBudget.enabled        | Enable PodDisruptionBudget for ingress controller                                     | `false`                                                                      |
| podDisruptionBudget.maxUnavailable | Represents the minimum number of Pods that can be unavailable (integer or percentage) | `50%`                                                                        |
| podDisruptionBudget.minAvailable   | Represents the number of Pods that must be available (integer or percentage)          |                                                                              |

