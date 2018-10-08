# Keycloak Proxy

Keycloak has an HTTP(S) proxy that you can put in front of web applications and services where it is not possible to install the Keycloak adapter. You can set up URL filters so that certain URLs are secured either by browser login and/or bearer token authentication. You can also define role constraints for URL patterns within your applications.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/keycloak-proxy
```

## Introduction

This chart bootstraps a [Keycloak Proxy](https://www.keycloak.org/docs/3.4/server_installation/index.html#_proxy) Deployment on a [Kubernetes](https://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager. It provisions a fully featured Keycloak Proxy installation.
For more information on Keycloak and its capabilities, see its [documentation](https://www.keycloak.org/docs/3.4/server_installation/index.html#_proxy) and [Docker Hub repository](https://hub.docker.com/r/jboss/keycloak-proxy/).

## Prerequisites Details

Keycloak Proxy is designed primarily for Keycloak, an OpenID Connect identity provider. But it also works with other OpenID Connect identity providers.

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
`image.repository` | Keycloak Proxy image repository | `jboss/keycloak-proxy`
`image.tag` | Keycloak Proxy image version | `3.4.2.Final`
`image.pullPolicy` | Keycloak Proxy image pull policy | `IfNotPresent`
`service.type` | The service type | `ClusterIP`
`service.port` | The service port | `80`
`service.nodePort` | The service nodePort | `""`
`ingress.enabled` | If true, an ingress is be created | `false`
`ingress.annotations` | Annotations for the ingress | `{}`
`ingress.path` | Path for backend | `/`
`ingress.hosts` | A list of hosts for the ingresss | `[keycloak-proxy.example.com]`
`ingress.tls.secretName` | If tls is enabled, uses an existing secret with this name | `""`
`ingress.tls.hosts` | A list of hosts for   | `""`
`resources` | CPU/Memory resource requests/limits | `{}`
`nodeSelector` | Node labels for pod assignment | `{}`
`tolerations` | Tolerations for pod assignment | `[]`
`affinity` | Node/Pod affinities | `{}`
`configmap.targetUrl` | The URL this server is proxying | `http://url-to-the-target-server.example.com`
`configmap.realm` | Name of the realm | `REALM_NAME`
`configmap.realmPublicKey` | PEM format of the realm public key. You can obtain this from the administration console. This is OPTIONAL and it’s not recommended to set it. If not set, the adapter will download this from Keycloak and it will always re-download it when needed (eg. Keycloak rotate it’s keys). However if realm-public-key is set, then adapter will never download new keys from Keycloak, so when Keycloak rotate it’s keys, adapter will break | `""`
`configmap.authServerUrl` | The base URL of the Keycloak server. All other Keycloak pages and REST service endpoints are derived from this. It is usually of the form https://host:port/auth | `http://url-to-keycloak.example.com/auth`
`configmap.resource` | The client-id of the application. Each application has a client-id that is used to identify the application | `CLIENT_ID`
`configmap.secret` | Specify the credentials of the application. This is an object notation where the key is the credential type and the value is the value of the credential type. Currently password and jwt is supported. This is REQUIRED only for clients with 'Confidential' access type | `CLIENT_SECRET`
`configmap.pattern` | URL pattern to match relative to the base-path of the application. Must start with '/' REQUIRED. You may only have one wildcard and it must come at the end of the pattern | `/admin`
`configmap.rolesAllowed` | Array of strings of roles allowed to access this url pattern | `admin`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak-proxy -f values.yaml incubator/keycloak-proxy
```

## Proxy Configuration

The following configurations which are located in a configmap are required to request authentication and authorization.
Please refer to [Keycloak Proxy](https://www.keycloak.org/docs/3.4/server_installation/index.html#_proxy) and [Adapter Config](https://www.keycloak.org/docs/3.4/securing_apps/index.html#_java_adapter_config) for more information.

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "fullname" . }}-configmap
  labels:
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
data:
  proxy.json: |
    {
       "target-url":"{{ .Values.configmap.targetUrl }}",
       "bind-address":"0.0.0.0",
       "http-port":"8080",
       "applications":[
          {
             "base-path":"/",
             "adapter-config":{
                "realm":"{{ .Values.configmap.realm }}",
                "realm-public-key": "{{ .Values.configmap.realmPublicKey }}",
                "auth-server-url":"{{ .Values.configmap.authServerUrl }}",
                "ssl-required":"external",
                "resource":"{{ .Values.configmap.resource }}",
                "credentials": {
                  "secret": "{{ .Values.configmap.secret }}"
                }
             },
             "constraints":[
               {
                  "pattern":"{{ .Values.configmap.pattern }}",
                  "roles-allowed":[
                    "{{ .Values.configmap.rolesAllowed }}"
                  ]
               }
             ],
             "proxy-address-forwarding": true
          }
       ]
    }
```
## Demo

[Keycloak Proxy Demo](https://github.com/YunSangJun/keycloak-proxy-demo) will help you understand the concept and behavior of this Proxy.
