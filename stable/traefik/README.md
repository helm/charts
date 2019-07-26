# Traefik

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer made to deploy
microservices with ease.

## Introduction

This chart bootstraps Traefik as a Kubernetes ingress controller with optional support for SSL and
Let's Encrypt.

__NOTE:__ Operators will typically wish to install this component into the `kube-system` namespace
where that namespace's default service account will ensure adequate privileges to watch `Ingress`
resources _cluster-wide_.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- Kubernetes 1.6+ if you want to enable RBAC
- You are deploying the chart to a cluster with a cloud provider capable of provisioning an
external load balancer (e.g. AWS or GKE)
- You control DNS for the domain(s) you intend to route through Traefik
- __Suggested:__ PV provisioner support in the underlying infrastructure

## A Quick Note on Versioning

Up until version 1.2.1-b of this chart, the semantic version of the chart was
kept in-sync with the semantic version of the (default) version of Traefik
installed by the chart. A dash and a letter were appended to Traefik's
semantic version to indicate incrementally improved versions of the chart
itself. For example, chart version 1.2.1-a and 1.2.1-b _both_ provide Traefik
1.2.1, but 1.2.1-b is a chart that is incrementally improved in some way from
its immediate predecessor-- 1.2.1-a.

This convention, in practice, suffered from a few problems, not the least of
which was that it defied what was permitted by
[semver 2.0.0](http://semver.org/spec/v2.0.0.html). This, in turn, lead to some
difficulty in Helm understanding the versions of this chart.

Beginning with version 1.3.0 of this chart, the version references _only_
the revision of the chart itself. The `appVersion` field in `chart.yaml` now
conveys information regarding the revision of Traefik that the chart provides.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install stable/traefik --name my-release --namespace kube-system
```

After installing the chart, create DNS records for applicable domains to direct inbound traffic to
the load balancer. You can use the commands below to find the load balancer's IP/hostname:

__NOTE:__ It may take a few minutes for this to become available.

You can watch the status by running:

```bash
$ kubectl get svc my-release-traefik --namespace kube-system -w
```

Once `EXTERNAL-IP` is no longer `<pending>`:

```bash
$ kubectl describe service my-release-traefik -n kube-system | grep Ingress | awk '{print $3}'
```

__NOTE:__ If ACME support is enabled, it is only _after_ this step is complete that Traefik will be
able to successfully use the ACME protocol to obtain certificates from Let's Encrypt.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the
release.

## Configuration

The following table lists the configurable parameters of the Traefik chart and their default values.

| Parameter                              | Description                                                                                                                  | Default                                           |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `fullnameOverride`                     | Override the full resource names                                                                                             | `{release-name}-traefik` (or traefik if release-name is traefik) |
| `image`                                | Traefik image name                                                                                                           | `traefik`                                         |
| `imageTag`                             | The version of the official Traefik image to use                                                                             | `1.7.12`                                           |
| `imagePullSecrets`                     | A list of image pull secrets (if needed)                                                                                     | None                                           |
| `serviceType`                          | A valid Kubernetes service type                                                                                              | `LoadBalancer`                                    |
| `loadBalancerIP`                       | An available static IP you have reserved on your cloud platform                                                              | None                                              |
| `startupArguments`                       | A list of startup arguments which are passed to traefik                                                              | `[]`                                              |
| `loadBalancerSourceRanges`             | List of IP CIDRs allowed access to load balancer (if supported)                                                              | None                                              |
| `externalIP`                           | Static IP for the service                                                                                                    | None                                              |
| `whiteListSourceRange`                 | Enable IP whitelisting at the entrypoint level.                                                                              | `false`                                           |
| `externalTrafficPolicy`                | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                      | `Cluster`                                         |
| `replicas`                             | The number of replicas to run; __NOTE:__ Full Traefik clustering with leader election is not yet supported, which can affect any configured Let's Encrypt setup; see Clustering section | `1` |
| `podDisruptionBudget`                  | Pod disruption budget                                                                                                        | `{}`                                              |
| `priorityClassName`                    | Pod priority class name                                                                                                      | `""`                                              |
| `rootCAs`                              | Register Certificates in the RootCA. These certificates will be use for backends calls. __NOTE:__ You can use file path or cert content directly | `[]`                          |
| `resources`                            | Resource definitions for the generated pods                                                                                  | `{}`                                              |
| `cpuRequest`                           | **DEPRECATED**: use `resources` instead. Initial share of CPU requested per Traefik pod                                      | None                                              |
| `memoryRequest`                        | **DEPRECATED**: use `resources` instead. Initial share of memory requested per Traefik pod                                   | None                                              |
| `cpuLimit`                             | **DEPRECATED**: use `resources` instead. CPU limit per Traefik pod                                                           | None                                              |
| `memoryLimit`                          | **DEPRECATED**: use `resources` instead. Memory limit per Traefik pod                                                        | None                                              |
| `rbac.enabled`                         | Whether to enable RBAC with a specific cluster role and binding for Traefik                                                  | `false`                                           |
| `deploymentStrategy`                   | Specify deployment spec rollout strategy                                                                                     | `{}`                                              |
| `securityContext`                      | Security context                                                                                                             | `{}`                                              |
| `useNonPriviledgedPorts`               | Use non privileged ports to listen. Needed if container is not running as root                                               | `false`                                           |
| `env`                                  | Environment variables for the container                                                                                      | `{}`                                              |
| `nodeSelector`                         | Node labels for pod assignment                                                                                               | `{}`                                              |
| `affinity`                             | Affinity settings                                                                                                            | `{}`                                              |
| `tolerations`                          | List of node taints to tolerate                                                                                              | `[]`                                              |
| `proxyProtocol.enabled`                | Enable PROXY protocol support.                                                                                               | `false`                                           |
| `proxyProtocol.trustedIPs`             | List of PROXY IPs (CIDR ranges) trusted to accurately convey the end-user IP.                                                | `[]`                                              |
| `forwardedHeaders.enabled`             | Enable support specify trusted clients for forwarded headers.                                                                | `false`                                           |
| `forwardedHeaders.trustedIPs`          | List of IPs (CIDR ranges) to be authorized to trust the client forwarded headers (X-Forwarded-*).                            | `[]`                                              |
| `debug.enabled`                        | Turn on/off Traefik's debug mode. Enabling it will override the logLevel to `DEBUG` and provide `/debug/vars` endpoint that allows Go runtime stats to be inspected, such as number of Goroutines and memory stats | `false`                                   |
| `logLevel`                             | Accepted values, in order of severity: "debug", "info", "warn", "error", "fatal", "panic". Messages at and above the selected level will be logged. | `info` |
| `ssl.enabled`                          | Whether to enable HTTPS                                                                                                      | `false`                                           |
| `ssl.enforced`                         | Whether to redirect HTTP requests to HTTPS                                                                                   | `false`                                           |
| `ssl.permanentRedirect`                | When ssl.enforced is set, use a permanent (301) redirect instead of a temporary redirect (302)                               | `false`                                           |
| `ssl.upstream`                         | Whether to skip configuring certs (ie: SSL is terminated by L4 ELB)                                                          | `false`                                           |
| `ssl.insecureSkipVerify`               | Whether to verify certs on SSL connections                                                                                   | `false`                                           |
| `ssl.tlsMinVersion`                    | Minimum TLS version for https entrypoint                                                                                     | None                                              |
| `ssl.cipherSuites`                     | Specify a non-empty list of TLS ciphers to override the default one | None |
| `ssl.sniStrict`                        | Enable strict SNI checking, so that connections cannot be made if a matching certificate does not exist.                     | false                                             |
| `ssl.generateTLS`                      | Generate self sign cert by Helm. If it's `true` the `defaultCert` and the `defaultKey` parameters will be ignored.           | false                                             |
| `ssl.defaultCN`                        | Specify generated self sign cert CN                                                                                          | ""                                                |
| `ssl.defaultSANList`                   | Specify generated self sign cert SAN list                                                                                    | `[]`                                              |
| `ssl.defaultIPList`                    | Specify generated self sign cert IP list                                                                                     | `[]`                                              |
| `ssl.defaultCert`                      | Base64 encoded default certificate                                                                                           | A self-signed certificate                         |
| `ssl.defaultKey`                       | Base64 encoded private key for the certificate above                                                                         | The private key for the certificate above         |
| `ssl.auth.basic`                       | Basic auth for all SSL endpoints, see Authentication section                                          | unset by default; this means basic auth is disabled |
| `acme.enabled`                         | Whether to use Let's Encrypt to obtain certificates                                                                          | `false`                                           |
| `acme.keyType`                         | KeyType used for generating certificate private key. Allow value 'EC256', 'EC384', 'RSA2048', 'RSA4096', 'RSA8192'.                                                                          | `RSA4096`                                           |
| `acme.challengeType`                   | Type of ACME challenge to perform domain validation. `tls-sni-01` (deprecated), `tls-alpn-01` (recommended), `http-01` or `dns-01` | `tls-sni-01`                                |
| `acme.delayBeforeCheck`         | By default, the provider will verify the TXT DNS challenge record before letting ACME verify. If delayBeforeCheck is greater than zero, this check is delayed for the configured duration in seconds. Useful when Traefik cannot resolve external DNS queries. | `0` |
| `acme.dnsProvider.name`                | Which DNS provider to use. See [here](https://github.com/xenolf/lego/tree/master/providers/dns) for the list of possible values. | `nil`                                         |
| `acme.dnsProvider.existingSecretName`  | Don't create a secret for DNS provider configuration environment variables, but use the specified one instead. Secret should contain the required environment variables. Useful to avoid storing secrets in helm | `""`                   |
| `acme.dnsProvider.$name`               | The configuration environment variables (encoded as a secret) needed for the DNS provider to do DNS challenge. Example configuration: [AWS Route 53](#example-aws-route-53), [Google Cloud DNS](#example-gcloud). | `{}` |
| `acme.email`                           | Email address to be used in certificates obtained from Let's Encrypt                                                         | `admin@example.com`                               |
| `acme.onHostRule`                      | Whether to generate a certificate for each frontend with Host rule                                                           | `true`                                            |
| `acme.staging`                         | Whether to get certs from Let's Encrypt's staging environment                                                                | `true`                                            |
| `acme.logging`                         | Display debug log messages from the ACME client library                                                                      | `false`                                           |
| `acme.domains.enabled`                 | Enable certificate creation by default for specific domain                                                                   | `false`                                           |
| `acme.domains.domainsList`             | List of domains & (optional) subject names                                                                                   | `[]`                                              |
| `acme.domains.domainsList.main`        | Main domain name of the generated certificate                                                                                | *.example.com                                     |
| `acme.domains.domainsList.sans`        | optional list of alternative subject names to give to the certificate                                                        | `[]`                                              |
| `acme.resolvers`                       | DNS servers list to use for DNS challenge                                                                                    | `[]`                                              |
| `acme.persistence.enabled`             | Create a volume to store ACME certs (if ACME is enabled)                                                                     | `true`                                            |
| `acme.persistence.annotations`         | PVC annotations                                                                                                              | `{}`                                              |
| `acme.persistence.storageClass`        | Type of `StorageClass` to request, will be cluster-specific                                                                  | `nil` (uses alpha storage class annotation)       |
| `acme.persistence.accessMode`          | `ReadWriteOnce` or `ReadOnly`                                                                                                | `ReadWriteOnce`                                   |
| `acme.persistence.existingClaim`       | An Existing PVC name                                                                                                         | `nil`                                             |
| `acme.persistence.size`                | Minimum size of the volume requested                                                                                         | `1Gi`                                             |
| `kvprovider.storeAcme`                 | Store acme certificates in KV Provider (needed for [HA](https://docs.traefik.io/configuration/acme/#as-a-key-value-store-entry)) | `false`                                       |
| `kvprovider.importAcme`                | Import acme certificates from acme.json of a mounted pvc (see: acme.persistence.existingClaim)                               | `false`                                           |
| `kvprovider.$name.endpoint`            | Endpoint of the provider like \<kv-provider-fqdn>:\<port>                                                                    | None                                              |
| `kvprovider.$name.watch`               | Wether traefik should watch for changes                                                                                      | `true`                                            |
| `kvprovider.$name.prefix`              | Prefix where traefik data will be stored                                                                                     | traefik                                           |
| `kvprovider.$name.filename`            | Advanced configuration. See: https://docs.traefik.io/                                                                        | provider default                                  |
| `kvprovider.$name.username`            | Optional username                                                                                                            | None                                              |
| `kvprovider.$name.password`            | Optional password                                                                                                            | None                                              |
| `kvprovider.$name.tls.ca`              | Optional TLS certificate authority                                                                                           | None                                              |
| `kvprovider.$name.tls.cert`            | Optional TLS certificate                                                                                                     | None                                              |
| `kvprovider.$name.tls.key`             | Optional TLS keyfile                                                                                                         | None                                              |
| `kvprovider.$name.tls.insecureSkipVerify`    | Optional Wether to skip verify                                                                                         | None                                              |
| `kvprovider.etcd.useAPIV3`             | Use V3 or use V2 API of ETCD                                                                                                 | `false`                                           |
| `dashboard.enabled`                    | Whether to enable the Traefik dashboard                                                                                      | `false`                                           |
| `dashboard.domain`                     | Domain for the Traefik dashboard                                                                                             | `traefik.example.com`                             |
| `dashboard.serviceType`                | ServiceType for the Traefik dashboard Service                                                                                | `ClusterIP`                                       |
| `dashboard.service.annotations`        | Annotations for the Traefik dashboard Service definition, specified as a map                                                 | None                                              |
| `dashboard.ingress.annotations`        | Annotations for the Traefik dashboard Ingress definition, specified as a map                                                 | None                                              |
| `dashboard.ingress.labels`             | Labels for the Traefik dashboard Ingress definition, specified as a map                                                      | None                                              |
| `dashboard.ingress.tls`                | TLS settings for the Traefik dashboard Ingress definition                                                                    | None                                              |
| `dashboard.auth.basic`                 | Basic auth for the Traefik dashboard specified as a map, see Authentication section                                          | unset by default; this means basic auth is disabled |
| `dashboard.statistics.recentErrors`    | Number of recent errors to show in the ‘Health’ tab                                                                          | None                                              |
| `service.annotations`                  | Annotations for the Traefik Service definition, specified as a map                                                           | None                                              |
| `service.labels`                       | Additional labels for the Traefik Service definition, specified as a map.                                                    | None                                              |
| `service.nodePorts.http`               | Desired nodePort for service of type NodePort used for http requests                                                         | blank ('') - will assign a dynamic node port      |
| `service.nodePorts.https`              | Desired nodePort for service of type NodePort used for https requests                                                        | blank ('') - will assign a dynamic node port      |
| `gzip.enabled`                         | Whether to use gzip compression                                                                                              | `true`                                            |
| `kubernetes.namespaces`                | List of Kubernetes namespaces to watch                                                                                       | All namespaces                                    |
| `kubernetes.labelSelector`             | Valid Kubernetes ingress label selector to watch (e.g `realm=public`).                                                       | No label filter                                   |
| `kubernetes.ingressClass`              | Value of `kubernetes.io/ingress.class` annotation to watch - must start with `traefik` if set                                | None                                              |
| `kubernetes.ingressEndpoint.hostname`  | Desired static hostname to update for ingress status spec                                                                    | None                                              |
| `kubernetes.ingressEndpoint.ip`        | Desired static IP to update for ingress status spec                                                                          | None                                              |
| `kubernetes.ingressEndpoint.publishedService` | Desired `namespace/service` to source ingress status spec from                                                        | None                                              |
| `kubernetes.ingressEndpoint.useDefaultPublishedService` | Whether to source `namespace/service` status spec from the service created by this chart. Mutually exclusive with `kubernetes.ingressEndpoint.publishedService`                   | None                                              |
| `fileBackend`                          | File Backend configuration                                                                                                   | None                                           |
| `accessLogs.enabled`                   | Whether to enable Traefik's access logs                                                                                      | `false`                                           |
| `accessLogs.filePath`                  | The path to the log file. Logs to stdout if omitted                                                                          | None                                              |
| `accessLogs.format`                    | What format the log entries should be in. Either `common` or `json`                                                          | `common`                                          |
| `accessLogs.fields.defaultMode`        | The default behaviour for fields logged in JSON access logs, other than headers. Either `keep` or `drop`                     | `keep`                                            |
| `accessLogs.fields.names`              | A map of field-specific logging behaviours in JSON access logs, with field names as keys, and either `keep` or `drop` as the value for each map entry | None                     |
| `accessLogs.fields.headers.defaultMode`| The default behaviour for logging HTTP headers in JSON access logs. Either `keep`, `drop` or `redact`                        | `keep`                                            |
| `accessLogs.fields.headers.names`      | A map of HTTP-header-specific logging behaviours in JSON access logs, with HTTP header names as keys, and `keep`, `drop` or `redact` as the value for each map entry | None      |
| `metrics.prometheus.enabled`           | Whether to enable the `/metrics` endpoint for metric collection by Prometheus.                                               | `false`                                           |
| `metrics.prometheus.restrictAccess`    | Whether to limit access to the metrics port (8080) to the dashboard service. When `false`, it is accessible on the main Traefik service as well. | `false`                       |
| `metrics.prometheus.buckets`           | A list of response times (in seconds) - for each list element, Traefik will report all response times less than the element. | `[0.1,0.3,1.2,5]`                                 |
| `metrics.datadog.enabled`              | Whether to enable pushing metrics to Datadog.                                                                                | `false`                                           |
| `metrics.datadog.address`              | Datadog host in the format <hostname>:<port>                                                                                 | `localhost:8125`                                  |
| `metrics.datadog.pushInterval`         | How often to push metrics to Datadog.                                                                                        | `10s`                                             |
| `metrics.statsd.enabled`               | Whether to enable pushing metrics to Statsd.                                                                                 | `false`                                           |
| `metrics.statsd.address`               | Statsd host in the format <hostname>:<port>                                                                                  | `localhost:8125`                                  |
| `metrics.statsd.pushInterval`          | How often to push metrics to Statsd.                                                                                         | `10s`                                             |
| `deployment.podAnnotations`            | Annotations for the Traefik pod definition                                                                                   | None                                              |
| `deployment.podLabels`                 | Labels for the Traefik pod definition                                                                                        | None                                              |
| `deployment.hostPort.httpEnabled`      | Whether to enable hostPort binding to host for http.                                                                         | `false`                                           |
| `deployment.hostPort.httpPort`         | Desired host port used for http requests.                                                                                    | `80`                                              |
| `deployment.hostPort.httpsEnabled`     | Whether to enable hostPort binding to host for https.                                                                        | `false`                                           |
| `deployment.hostPort.httpsPort`        | Desired host port used for https requests.                                                                                   | `443`                                             |
| `deployment.hostPort.dashboardEnabled` | Whether to enable hostPort binding to host for dashboard.                                                                    | `false`                                           |
| `deployment.hostPort.dashboardPort`    | Desired host port used for accessing dashboard.                                                                              | `8080`                                            |
| `sendAnonymousUsage`                   | Send anonymous usage statistics.                                                                                             | `false`                                           |
| `tracing.enabled`                      | Whether to enable request tracing                                                                                            | `false`                                           |
| `tracing.backend`                      | Tracing backend to use, either `jaeger` or `zipkin` or `datadog`                                                             | None                                              |
| `tracing.serviceName`                  | Service name to be used in tracing backend                                                                                   | `traefik`                                         |
| `tracing.jaeger.localAgentHostPort`    | Location of the Jaeger agent where spans will be sent                                                                        | `127.0.0.1:6831`                                  |
| `tracing.jaeger.samplingServerUrl`     | Address of the Jaeger agent HTTP sampling server                                                                             | `http://localhost:5778/sampling`                  |
| `tracing.jaeger.samplingType`          | Type of Jaeger sampler to use, one of: `const`, `probabilistic`, `ratelimiting`                                              | `const`                                           |
| `tracing.jaeger.samplingParam`         | Value passed to the Jaeger sampler                                                                                           | `1.0`                                             |
| `tracing.zipkin.httpEndpoint`          | Zipkin HTTP endpoint                                                                                                         | `http://localhost:9411/api/v1/spans`              |
| `tracing.zipkin.debug`                 | Enables Zipkin debugging                                                                                                     | `false`                                           |
| `tracing.zipkin.sameSpan`              | Use Zipkin SameSpan RPC style traces                                                                                         | `false`                                           |
| `tracing.zipkin.id128Bit`              | Use Zipkin 128 bit root span IDs                                                                                             | `true`                                            |
| `tracing.datadog.localAgentHostPort`   | Location of the Datadog agent where spans will be sent                                                                       | `127.0.0.1:8126`                                  |
| `tracing.datadog.debug`                | Enables Datadog debugging                                                                                                    | `false`                                           |
| `tracing.datadog.globalTag`            | Apply shared tag in a form of Key:Value to all the traces                                                                    | `""`                                              |
| `timeouts.responding.readTimeout`      | The maximum duration for reading the entire request, including the body. If zero, no timeout exists.                         | `"0s"`                                            |
| `timeouts.responding.writeTimeout`     | The maximum duration before timing out writes of the response. If zero, no timeout exists.                                   | `"0s"`                                            |
| `timeouts.responding.idleTimeout`      | The maximum duration an idle (keep-alive) connection will remain idle before closing itself. If zero, no timeout exists.     | `"0s"`                                            |
| `timeouts.forwarding.dialTimeout`      | The amount of time to wait until a connection to a backend server can be established. If zero, no timeout exists.            | `"30s"`                                           |
| `timeouts.forwarding.responseHeaderTimeout` | The amount of time to wait for a server's response headers after fully writing the request (including its body, if any). If zero, no timeout exists. | `"30s"`              |
| `autoscaling`                          | HorizontalPodAutoscaler for the traefik Deployment                                                                           | `{}`                                              |
| `configFiles`                          | Config files to make available in the deployment. key=filename, value=file contents                                          | `{}`                                              |
| `secretFiles`                          | Secret files to make available in the deployment. key=filename, value=file contents                                          | `{}`                                              |
| `testFramework.image`                  | `test-framework` image repository.                                                                                           | `dduportal/bats`                                  |
| `testFramework.tag`                    | `test-framework` image tag.                                                                                                  | `0.4.0`                                           |
| `forwardAuth.entryPoints`              | Enable forward authentication for these entryPoints: "http", "https", "httpn"                                                |                                                   |
| `forwardAuth.address`                  | URL for forward authentication                                                                                               |                                                   |
| `forwardAuth.trustForwardHeader`       | Trust X-Forwarded-* headers                                                                                                  |                                                   |
| `extraVolumeMounts`      | Any extra volumes mounts to define for the Traefik container                                                                                                                                                                                                               | `[]`                                                                                                                      |
| `extraVolumes`           | Any extra volumes to define for the pod                                                                                                                                                                                                                                     | `[]`                                                                                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release --namespace kube-system \
  --set dashboard.enabled=true,dashboard.domain=traefik.example.com stable/traefik
```

The above command enables the Traefik dashboard on the domain `traefik.example.com`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm install --name my-release --namespace kube-system --values values.yaml stable/traefik
```

### Clustering / High Availability

To enable cluster support, you need one of:
* etcd
* consul
* boltdb
* zookeeper

as kvprovider, especially when you are using Let's Encrypt.
If you have already certificates stored as acme.json in an existing persistent volume claim, you can import it.

Given you have:
* a running [etcd operator](https://github.com/helm/charts/tree/master/stable/etcd-operator):
* you have created a master chart requiring this traefik chart
* an existing pvc with an `acme.json` called `acme-certs-pvc`
* you have an etcd template like:
  ```
  apiVersion: "etcd.database.coreos.com/v1beta2"
  kind: "EtcdCluster"
  metadata:
    name: {{ .Values.etcdCluster.name }}
    labels:
       app: {{ .Values.etcdCluster.name }}
    annotations:
       etcd.database.coreos.com/scope: clusterwide
  spec:
    size: 3
    version: "3.1.8"
  ```
* and these values in your values.yaml
  ```
  etcdCluster:
    name: traefik-etcd-cluster

  traefik:
    replicas: 3
    acme:
      persistence:
        enabled: true
        existingClaim: acme-certs-pvc
    kvprovider:
      storeAcme: true
      importAcme: true
      etcd:
        endpoint: "traefik-etcd-cluster-client:2379"
        useAPIV3: false
        watch: true
        prefix: traefik
  ```

Then you are good to migrate your old certs into the kvprovider and run traefik in HA/Cluster-Mode.


### Dashboard Basic Auth

[Basic auth](https://docs.traefik.io/configuration/entrypoints/#authentication) can be specified via `dashboard.auth.basic` as a map of usernames to passwords as below.
See the linked Traefik documentation for accepted passwords encodings.
It is advised to single quote passwords to avoid issues with special characters:

```bash
$ helm install --name my-release --namespace kube-system \
  --set dashboard.enabled=true,dashboard.auth.basic.test='$apr1$H6uskkkW$IgXLP6ewTrSuBkTrqE8wj/' \
  stable/traefik
```

Alternatively in YAML form:

```yaml
dashboard:
  enabled: true
  domain: traefik.example.com
  auth:
    basic:
      test: $apr1$H6uskkkW$IgXLP6ewTrSuBkTrqE8wj/
```

### Let's Encrypt domain verification using DNS challenge

When obtaining an ACME (Let's Encrypt) certificate, sometimes it's more desirable to do DNS challenge, for example, if the
server you want to obtain a certificate for does not have a public IP address.

First, check if your DNS provider is supported by [lego](https://github.com/xenolf/lego/tree/master/providers/dns)(the ACME library that Traefik is using).
Next, you will need to configure the Traefik chart to use DNS challenge. In the ACME section:

```yaml
acme:
  enabled: true
  challengeType: "dns-01"
  dnsProvider:
    name:  # name of the dns provider to use
    $name: # the configuration of the dns provider. See the following section for an example
      # variables that the specific dns provider requires
```

### Let's Encrypt wildcard certificate

To obtain an ACME (Let's Encrypt) wildcard certificate you must use a DNS challenge as explained above.
Then you need to specify the wildcard domain name in the `acme.domains` section like this :

```yaml
acme:
  enabled: true
  challengeType: "dns-01"
  dnsProvider:
    name:  # name of the dns provider to use
    $name: # the configuration of the dns provider. See the following section for an example
      # variables that the specific dns provider requires
  domains:
    enabled: true
    domainsList:
      - main: "*.example.com" # name of the wildcard domain name for the certificate
      - sans:
        - "example.com" # OPTIONAL: Alternative name(s) for the certificate, if you want the same certificate for the root of the domain name for example
      - main: "*.example2.com" # name of the wildcard domain name for the certificate
```

#### Example: AWS Route 53

Using `route53` as DNS provider requires the following configuration variables to be set:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

The configuration would look like this:

```yaml
acme:
  enabled: true
  dnsProvider:
    name: route53
    route53:
      AWS_ACCESS_KEY_ID: ...
      AWS_SECRET_ACCESS_KEY: ...
      AWS_REGION: us-east-1
```

#### Example: Google Cloud DNS

Using `gcloud` as DNS provider requires the following configuration variables to be set:
- `GCE_PROJECT`
- `GCE_SERVICE_ACCOUNT_FILE`

The configuration would look like this:

```yaml

secretFiles:
  gcloud-credentials.json: '{"type":"service_account","project_id":"<projectName>","private_key_id":"<hash>",...}'

acme:
  enabled: true
  dnsProvider:
    name: gcloud
    gcloud:
      GCE_PROJECT: <projectName>
      GCE_SERVICE_ACCOUNT_FILE: /secrets/gcloud-credentials.json
```

### Proxy Protocol

In situations where Traefik lives behind an Internet-facing loadbalancer (like an AWS ELB) and you still want it to see the actual source IP of the visitor instead of the internal IP of the loadbalancer, you can enable the loadbalancer to use the Proxy protocol to talk to Traefik. This effectively makes the loadbalancer transparent, as Traefik will still get the actual visitor IP address for each request. This only works if Traefik knows it's receiving traffic via the Proxy Protocol and the loadbalancer IP addresses need to be whitelisted as well.

How to set this up on AWS is described in the Kubernetes documentation [here](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-protocol-support-on-aws), it can easily be done by adding an annotation to the Service definition.

**Caution**

If only one of the components (either the loadbalancer or Traefik) is set to use the Proxy protocol and the other is not, this will break badly as they will not be able to communicate with each other.
