# Keycloak Proxy

Keycloak has an HTTP(S) proxy that you can put in front of web applications and services where it is not possible to install the Keycloak adapter. You can set up URL filters so that certain URLs are secured either by browser login and/or bearer token authentication. You can also define role constraints for URL patterns within your applications.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/keycloak-proxy
```

## Introduction

This chart bootstraps a [Keycloak Proxy](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html) Deployment on a [Kubernetes](https://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager. It provisions a fully featured Keycloak Proxy installation.
For more information on Keycloak and its capabilities, see its [documentation](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html) and [Docker Hub repository](https://hub.docker.com/r/jboss/keycloak-proxy/).

## Prerequisites Details

Keycloak Proxy basically works with Keycloak service.
So you need install a [Keycloak](https://github.com/kubernetes/charts/tree/master/incubator/keycloak).
If you already have a Keycloak environment, you can use it.

## Installing the Chart

To install the chart with the release name `keycloak-proxy`:

```console
$ helm install --name keycloak-proxy incubator/keycloak-proxy
```

## Uninstalling the Chart

To uninstall/delete the `keycloak-proxy` deployment:

```console
$ helm delete keycloak-proxy
```

## Configuration

The following table lists the configurable parameters of the Keycloak chart and their default values.

Parameter | Description | Default
--- | --- | ---
`imageRepository` | Keycloak Proxy image repository | `jboss/keycloak-proxy`
`imageTag` | Keycloak Proxy image version | `3.4.0.Final`
`imagePullPolicy` | Keycloak Proxy image pull policy | `IfNotPresent`
`service.type` | The service type | `ClusterIP`
`service.port` | The service port | `80`
`service.nodePort` | The service nodePort | `""`
`ingress.enabled` | If true, an ingress is be created | `false`
`ingress.annotations` | Annotations for the ingress | `{}`
`ingress.hosts` | A list of hosts for the ingresss | `[keycloak-proxy.example.com]`
`ingress.tls.enabled` | If true, tls is enabled for the ingress | `false`
`ingress.tls.existingSecret` | If tls is enabled, uses an existing secret with this name | `""`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak-proxy -f values.yaml incubator/keycloak-proxy
```

## Proxy Configuration(Required)

The following configurations are required for Single Sign-On.

```
<proxy.json>
{
   "target-url":"http://url-to-the-target-server.example.com",
   "bind-address":"0.0.0.0",
   "http-port":"8080",
   "applications":[
      {
         "base-path":"/",
         "adapter-config":{
            "realm":"REALM_NAME",
            "realm-public-key": "REALM_PUBLIC_KEY",
            "auth-server-url":"http://url-to-keycloak.example.com/auth",
            "ssl-required":"external",
            "resource":"CLIENT_ID",
            "credentials": {
              "secret": "CLIENT_SECRET"
            }
         },
         "constraints":[
           {
              "pattern":"/*",
              "roles-allowed":[
                "user"
              ]
           }
         ],
         "proxy-address-forwarding": true
      }
   ]
}
```

### Basic Config

Please refer to [Keycloak Proxy](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html) for more information.

Key | Value
--- | ---
`target-url` | The URL this server is proxying.

### Adapter Config

Please refer to [Adapter Config](https://www.keycloak.org/docs/3.3/securing_apps/topics/oidc/java/java-adapter-config.html) for more information.

Key | Value
--- | ---
`target-url` | The URL this server is proxying.
`realm` | Name of the realm.
`realm-public-key` | PEM format of the realm public key. You can obtain this from the administration console. This is OPTIONAL and it’s not recommended to set it. If not set, the adapter will download this from Keycloak and it will always re-download it when needed (eg. Keycloak rotate it’s keys). However if realm-public-key is set, then adapter will never download new keys from Keycloak, so when Keycloak rotate it’s keys, adapter will break.
`auth-server-url` | The base URL of the Keycloak server. All other Keycloak pages and REST service endpoints are derived from this. It is usually of the form https://host:port/auth. This is REQUIRED.
`resource` | The client-id of the application. Each application has a client-id that is used to identify the application. This is REQUIRED.
`credentials` | Specify the credentials of the application. This is an object notation where the key is the credential type and the value is the value of the credential type. Currently password and jwt is supported. This is REQUIRED only for clients with 'Confidential' access type.

### Constraint Config

Please refer to [Keycloak Proxy](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html) for more information.

Key | Value
--- | ---
`pattern` | URL pattern to match relative to the base-path of the application. Must start with '/' REQUIRED. You may only have one wildcard and it must come at the end of the pattern.
`roles-allowed` | Array of strings of roles allowed to access this url pattern. OPTIONAL.
