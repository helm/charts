# external-dns

[ExternalDNS](https://github.com/kubernetes-incubator/external-dns) is a Kubernetes addon that configures public DNS servers with information about exposed Kubernetes services to make them discoverable.

## TL;DR;

```console
$ helm install stable/external-dns
```

## Introduction

This chart bootstraps a [ExternalDNS](https://github.com/bitnami/bitnami-docker-external-dns) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/external-dns
```

The command deploys ExternalDNS on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the external-dns chart and their default values.


| Parameter                           | Description                                                                                              | Default                                                     |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `global.imageRegistry`              | Global Docker image registry                                                                             | `nil`                                                       |
| `global.imagePullSecrets`           | Global Docker registry secret names as an array                                                          | `[]` (does not add image pull secrets to deployed pods)     |
| `image.registry`                    | ExternalDNS image registry                                                                               | `docker.io`                                                 |
| `image.repository`                  | ExternalDNS Image name                                                                                   | `bitnami/external-dns`                                      |
| `image.tag`                         | ExternalDNS Image tag                                                                                    | `{TAG_NAME}`                                                |
| `image.pullPolicy`                  | ExternalDNS image pull policy                                                                            | `IfNotPresent`                                              |
| `image.pullSecrets`                 | Specify docker-registry secret names as an array                                                         | `[]` (does not add image pull secrets to deployed pods)     |
| `nameOverride`                      | String to partially override external-dns.fullname template with a string (will prepend the release name)| `nil`                                                       |
| `fullnameOverride`                  | String to fully override external-dns.fullname template with a string                                    | `nil`                                                       |
| `sources`                           | K8s resources type to be observed for new DNS entries by ExternalDNS                                     | `[service, ingress]`                                        |
| `provider`                          | DNS provider where the DNS records will be created (mandatory) (options: aws, azure, google, ...)        | `aws`                                                       |
| `namespace`                         | Limit sources of endpoints to a specific namespace (default: all namespaces)                             | `""`                                                        |
| `fqdnTemplates`                     | Templated strings that are used to generate DNS names from sources that don't define a hostname themselves   | `[]`                                                    |
| `combineFQDNAnnotation`             | Combine FQDN template and annotations instead of overwriting                                             | `false`                                                     |
| `ignoreHostnameAnnotation`          | Ignore hostname annotation when generating DNS names, valid only when fqdn-template is set               | `false`                                                     |
| `publishInternalServices`           | Whether to publish DNS records for ClusterIP services or not                                             | `false`                                                     |
| `publishHostIP`                     | Allow external-dns to publish host-ip for headless services                                              | `false`                                                     |
| `serviceTypeFilter`                 | The service types to take care about (default: all, options: ClusterIP, NodePort, LoadBalancer, ExternalName)   | `[]`                                                 |
| `aws.credentials.accessKey`         | When using the AWS provider, set `aws_access_key_id` in the AWS credentials (optional)                   | `""`                                                        |
| `aws.credentials.secretKey`         | When using the AWS provider, set `aws_secret_access_key` in the AWS credentials (optional)               | `""`                                                        |
| `aws.credentials.mountPath`         | When using the AWS provider, determine `mountPath` for `credentials` secret                              | `"/.aws"`                                                   |
| `aws.region`                        | When using the AWS provider, `AWS_DEFAULT_REGION` to set in the environment (optional)                   | `us-east-1`                                                 |
| `aws.zoneType`                      | When using the AWS provider, filter for zones of this type (optional, options: public, private)          | `""`                                                        |
| `aws.assumeRoleArn`                 | When using the AWS provider, assume role by specifying --aws-assume-role to the external-dns daemon      | `""`                                                        |
| `aws.batchChangeSize`               | When using the AWS provider, set the maximum number of changes that will be applied in each batch        | `1000`                                                      |
| `aws.zoneTags`                      | When using the AWS provider, filter for zones with these tags                                            | `[]`                                                        |
| `aws.preferCNAME`                   | When using the AWS provider, replaces Alias recors with CNAME (options: true, false)                     | `[]`                                                        |
| `azure.secretName`                  | When using the Azure provider, set the secret containing the `azure.json` file                           | `""`                                                        |
| `azure.cloud`                       | When using the Azure provider, set the Azure Clound                                                      | `""`                                                        |
| `azure.resourceGroup`               | When using the Azure provider, set the Azure Resource Group                                              | `""`                                                        |
| `azure.tenantId`                    | When using the Azure provider, set the Azure Tenant ID                                                   | `""`                                                        |
| `azure.subscriptionId`              | When using the Azure provider, set the Azure Subscription ID                                             | `""`                                                        |
| `azure.aadClientId`                 | When using the Azure provider, set the Azure AAD Client ID                                               | `""`                                                        |
| `azure.aadClientSecret`             | When using the Azure provider, set the Azure AAD Client Secret                                           | `""`                                                        |
| `azure.useManagedIdentityExtension` | When using the Azure provider, set if you use Azure MSI                                                  | `""`                                                        |
| `cloudflare.apiToken`               | When using the Cloudflare provider, `CF_API_TOKEN` to set (optional)                                     | `""`                                                        |
| `cloudflare.apiKey`                 | When using the Cloudflare provider, `CF_API_KEY` to set (optional)                                       | `""`                                                        |
| `cloudflare.email`                  | When using the Cloudflare provider, `CF_API_EMAIL` to set (optional)                                     | `""`                                                        |
| `cloudflare.proxied`                | When using the Cloudflare provider, enable the proxy feature (DDOS protection, CDN...) (optional)        | `true`                                                      |
| `coredns.etcdEndpoints`             | When using the CoreDNS provider, set etcd backend endpoints (comma-separated list)                       | `"http://etcd-extdns:2379"`                                 |
| `coredns.etcdTLS.enabled`           | When using the CoreDNS provider, enable secure communication with etcd                                   | `false`                                                     |
| `coredns.etcdTLS.secretName`        | When using the CoreDNS provider, specify a name of existing Secret with etcd certs and keys              | `"etcd-client-certs"`                                       |
| `coredns.etcdTLS.mountPath`         | When using the CoreDNS provider, set destination dir to mount data from `coredns.etcdTLS.secretName` to  | `"/etc/coredns/tls/etcd"`                                   |
| `coredns.etcdTLS.caFilename`        | When using the CoreDNS provider, specify CA PEM file name from the `coredns.etcdTLS.secretName`          | `"ca.crt"`                                                  |
| `coredns.etcdTLS.certFilename`      | When using the CoreDNS provider, specify cert PEM file name from the `coredns.etcdTLS.secretName`        | `"cert.pem"`                                                |
| `coredns.etcdTLS.keyFilename`       | When using the CoreDNS provider, specify private key PEM file name from the `coredns.etcdTLS.secretName` | `"key.pem"`                                                 |
| `designate.customCA.enabled`        | When using the Designate provider, enable a custom CA (optional)                                         | false                                                       |
| `designate.customCA.content`        | When using the Designate provider, set the content of the custom CA                                      | ""                                                          |
| `designate.customCA.mountPath`      | When using the Designate provider, set the mountPath in which to mount the custom CA configuration       | "/config/designate"                                         |
| `designate.customCA.filename`       | When using the Designate provider, set the custom CA configuration filename                              | "designate-ca.pem"                                          |
| `digitalocean.apiToken`             | When using the DigitalOcean provider, `DO_TOKEN` to set (optional)                                       | `""`                                                        |
| `google.project`                    | When using the Google provider, specify the Google project (required when provider=google)               | `""`                                                        |
| `google.serviceAccountSecret`       | When using the Google provider, specify the existing secret which contains credentials.json (optional)   | `""`                                                        |
| `google.serviceAccountKey`          | When using the Google provider, specify the service account key JSON file. (required when `google.serviceAccountSecret` is not provided. In this case a new secret will be created holding this service account | `""`    |
| `infoblox.gridHost`                 | When using the Infoblox provider, specify the Infoblox Grid host (required when provider=infoblox)       | `""`                                                        |
| `infoblox.wapiUsername`             | When using the Infoblox provider, specify the Infoblox WAPI username                                     | `"admin"`                                                   |
| `infoblox.wapiPassword`             | When using the Infoblox provider, specify the Infoblox WAPI password (required when provider=infoblox)   | `""`                                                        |
| `infoblox.domainFilter`             | When using the Infoblox provider, specify the domain (optional)                                          | `""`                                                        |
| `infoblox.noSslVerify`              | When using the Infoblox provider, disable SSL verification (optional)                                    | `false`                                                     |
| `infoblox.wapiPort`                 | When using the Infoblox provider, specify the Infoblox WAPI port (optional)                              | `""`                                                        |
| `infoblox.wapiVersion`              | When using the Infoblox provider, specify the Infoblox WAPI version (optional)                           | `""`                                                        |
| `infoblox.wapiConnectionPoolSize`   | When using the Infoblox provider, specify the Infoblox WAPI request connection pool size (optional)      | `""`                                                        |
| `infoblox.wapiHttpTimeout`          | When using the Infoblox provider, specify the Infoblox WAPI request timeout in seconds (optional)        | `""`                                                        |
| `rfc2136.host`                      | When using the rfc2136 provider, specify the RFC2136 host (required when provider=rfc2136)               | `""`                                                        |
| `rfc2136.port`                      | When using the rfc2136 provider, specify the RFC2136 port (optional)                                     | `53`                                                        |
| `rfc2136.zone`                      | When using the rfc2136 provider, specify the zone (required when provider=rfc2136)                       | `""`                                                        |
| `rfc2136.tsigSecret`                | When using the rfc2136 provider, specify the tsig secret to enable security (optional)                   | `""`                                                        |
| `rfc2136.tsigKeyname`               | When using the rfc2136 provider, specify the tsig keyname to enable security (optional)                  | `"externaldns-key"`                                         |
| `rfc2136.tsigSecretAlg`             | When using the rfc2136 provider, specify the tsig secret to enable security (optional)                   | `"hmac-sha256"`                                             |
| `rfc2136.tsigAxfr`                  | When using the rfc2136 provider, enable AFXR to enable security (optional)                               | `true`                                                      |
| `pdns.apiUrl`                       | When using the PowerDNS provider, specify the API URL of the server.                                     | `""`                                                        |
| `pdns.apiPort`                      | When using the PowerDNS provider, specify the API port of the server.                                    | `8081`                                                      |
| `pdns.apiKey`                       | When using the PowerDNS provider, specify the API key of the server.                                     | `""`                                                        |
| `annotationFilter`                  | Filter sources managed by external-dns via annotation using label selector (optional)                    | `""`                                                        |
| `domainFilters`                     | Limit possible target zones by domain suffixes (optional)                                                | `[]`                                                        |
| `zoneIdFilters`                     | Limit possible target zones by zone id (optional)                                                        | `[]`                                                        |
| `crd.create`                        | Install and use the integrated DNSEndpoint CRD                                                           | `false`                                                     |
| `crd.apiversion`                    | Sets the API version for the CRD to watch                                                                | `""`                                                        |
| `crd.kind`                          | Sets the kind for the CRD to watch                                                                       | `""`                                                        |
| `dryRun`                            | When enabled, prints DNS record changes rather than actually performing them (optional)                  | `false`                                                     |
| `logLevel`                          | Verbosity of the logs (options: panic, debug, info, warn, error, fatal)                                  | `info`                                                      |
| `logFormat`                         | Which format to output logs in (options: text, json)                                                     | `text`                                                      |
| `interval`                          | Interval update period to use                                                                            | `1m`                                                        |
| `istioIngressGateways`              | The fully-qualified name of the Istio ingress gateway services .                                         | `""`                                                        |
| `policy`                            | Modify how DNS records are sychronized between sources and providers (options: sync, upsert-only )       | `upsert-only`                                               |
| `registry`                          | Registry method to use (options: txt, noop)                                                              | `txt`                                                       |
| `txtOwnerId`                        | When using the TXT registry, a name that identifies this instance of ExternalDNS (optional)              | `"default"`                                                 |
| `txtPrefix`                         | When using the TXT registry, a prefix for ownership records that avoids collision with CNAME entries (optional) | `""`                                                 |
| `extraArgs`                         | Extra arguments to be passed to external-dns                                                             | `{}`                                                        |
| `extraEnv`                          | Extra environment variables to be passed to external-dns                                                 | `[]`                                                        |
| `replicas`                          | Desired number of ExternalDNS replicas                                                                   | `1`                                                         |
| `affinity`                          | Affinity for pod assignment (this value is evaluated as a template)                                      | `{}`                                                        |
| `nodeSelector`                      | Node labels for pod assignment (this value is evaluated as a template)                                   | `{}`                                                        |
| `tolerations`                       | Tolerations for pod assignment (this value is evaluated as a template)                                   | `[]`                                                        |
| `podAnnotations`                    | Additional annotations to apply to the pod.                                                              | `{}`                                                        |
| `podLabels`                         | Additional labels to be added to pods                                                                    | {}                                                          |
| `podSecurityContext.fsGroup`        | Group ID for the container                                                                               | `1001`                                                      |
| `podSecurityContext.runAsUser`      | User ID for the container                                                                                | `1001`                                                      |
| `priorityClassName`                 | priorityClassName                                                                                        | `""`                                                        |
| `securityContext`                   | Security context for the container                                                                       | `{}`                                                        |
| `service.type`                      | Kubernetes Service type                                                                                  | `ClusterIP`                                                 |
| `service.port`                      | ExternalDNS client port                                                                                  | `7979`                                                      |
| `service.nodePort`                  | Port to bind to for NodePort service type (client port)                                                  | `nil`                                                       |
| `service.clusterIP`                 | IP address to assign to service                                                                          | `""`                                                        |
| `service.externalIPs`               | Service external IP addresses                                                                            | `[]`                                                        |
| `service.loadBalancerIP`            | IP address to assign to load balancer (if supported)                                                     | `""`                                                        |
| `service.loadBalancerSourceRanges`  | List of IP CIDRs allowed access to load balancer (if supported)                                          | `[]`                                                        |
| `service.annotations`               | Annotations to add to service                                                                            | `{}`                                                        |
| `rbac.create`                       | Weather to create & use RBAC resources or not                                                            | `true`                                                      |
| `rbac.serviceAccountName`           | ServiceAccount (ignored if rbac.create == true)                                                          | `default`                                                   |
| `rbac.serviceAccountAnnotations`    | Additional Service Account annotations                                                                   | `{}`                                                        |
| `rbac.apiVersion`                   | Version of the RBAC API                                                                                  | `v1beta1`                                                   |
| `rbac.pspEnabled`                   | PodSecurityPolicy                                                                                        | `false`                                                     |
| `resources`                         | CPU/Memory resource requests/limits.                                                                     | `{}`                                                        |
| `livenessProbe`                     | Deployment Liveness Probe                                                                                | See `values.yaml`                                           |
| `readinessProbe`                    | Deployment Readiness Probe                                                                               | See `values.yaml`                                           |
| `metrics.enabled`                   | Enable prometheus to access external-dns metrics endpoint                                                | `false`                                                     |
| `metrics.podAnnotations`            | Annotations for enabling prometheus to access the metrics endpoint                                       |                                                             |
| `metrics.serviceMonitor.enabled`    | Create ServiceMonitor object                                                                             | `false`                                                     |
| `metrics.serviceMonitor.selector`   | Additional labels for ServiceMonitor object                                                              | `{}`                                                        |
| `metrics.serviceMonitor.interval`   | Interval at which metrics should be scraped                                                              | `30s`                                                       |
| `metrics.serviceMonitor.scrapeTimeout`   | Timeout after which the scrape is ended                                                             | `30s`                                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set provider=aws stable/external-dns
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/external-dns
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Desired number of ExternalDNS replicas:
```diff
- replicas: 1
+ replicas: 3
```

- Enable prometheus to access external-dns metrics endpoint:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

## Tutorials

Find information about the requirements for each DNS provider on the link below:

- [ExternalDNS Tutorials](https://github.com/kubernetes-incubator/external-dns/tree/master/docs/tutorials)

For instance, to install ExternalDNS on AWS, you need to:

- Provide the K8s worker node which runs the cluster autoscaler with a minimum IAM policy (check [IAM permissions docs](https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws.md#iam-permissions) for more information).
- Setup a hosted zone on Route53 and annotate the Hosted Zone ID and its associated "nameservers" as described on [these docs](https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws.md#set-up-a-hosted-zone).
- Install ExternalDNS chart using the command below:

> Note: replace the placeholder HOSTED_ZONE_IDENTIFIER and HOSTED_ZONE_NAME, with your hosted zoned identifier and name, respectively.

```bash
$ helm install --name my-release \
  --set provider=aws \
  --set aws.zoneType=public \
  --set txtOwnerId=HOSTED_ZONE_IDENTIFIER \
  --set domainFilters[0]=HOSTED_ZONE_NAME \
  stable/external-dns
```

## Upgrading

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is `my-release`:

```console
$ kubectl delete deployment my-release-external-dns
$ helm upgrade my-release stable/external-dns
```

Other mayor changes included in this major version are:

- Default image changes from `registry.opensource.zalan.do/teapot/external-dns` to `bitnami/external-dns`.
- The parameters below are renamed:
  - `aws.secretKey` -> `aws.credentials.secretKey`
  - `aws.accessKey` -> `aws.credentials.accessKey`
  - `aws.credentialsPath` -> `aws.credentials.mountPath`
  - `designate.customCA.directory` -> `designate.customCA.mountPath`
- Support to Prometheus metrics is added.
