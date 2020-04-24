# Fluent-Bit Chart

[Fluent Bit](http://fluentbit.io/) is an open source and multi-platform Log Forwarder.

## Chart Details

This chart will do the following:

* Install a configmap for Fluent Bit
* Install a daemonset that provisions Fluent Bit [per-host architecture]

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/fluent-bit
```

When installing this chart on [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/), it's required to specify that so the DaemonSet will be able to mount the log files properly, make sure to append the _--set on\_minikube=true_ option at the end of the _helm_ command, e.g:

```bash
$ helm install --name my-release stable/fluent-bit --set on_minikube=true
```

## Configuration

The following table lists the configurable parameters of the Fluent-Bit chart and the default values.

| Parameter                  | Description                        | Default                 |
| -----------------------    | ---------------------------------- | ----------------------- |
| **Backend Selection**      |
| `backend.type`             | Set the backend to which Fluent-Bit should flush the information it gathers | `forward` |
| **Forward Backend**        |
| `backend.forward.host`     | Target host where Fluent-Bit or Fluentd are listening for Forward messages | `fluentd` |
| `backend.forward.port`     | TCP Port of the target service | `24284` |
| `backend.forward.shared_key`       | A key string known by the remote Fluentd used for authorization. | `` |
| `backend.forward.tls`              | Enable or disable TLS support | `off` |
| `backend.forward.tls_verify`       | Force certificate validation  | `on` |
| `backend.forward.tls_debug`        | Set TLS debug verbosity level. It accept the following values: 0-4 | `1` |
| **ElasticSearch Backend**  |
| `backend.es.host`          | IP address or hostname of the target Elasticsearch instance | `elasticsearch` |
| `backend.es.port`          | TCP port of the target Elasticsearch instance. | `9200` |
| `backend.es.index`         | Elastic Index name | `kubernetes_cluster` |
| `backend.es.type`          | Elastic Type name | `flb_type` |
| `backend.es.retry_limit`   | Max number of retries to attempt (False == no limit) | `False` |
| `backend.es.time_key`          | Elastic Time Key | `@timestamp` |
| `backend.es.logstash_format`          | Enable Logstash format compatibility. | `On` |
| `backend.es.logstash_prefix`  | Index Prefix. If Logstash_Prefix is equal to 'mydata' your index will become 'mydata-YYYY.MM.DD'. | `kubernetes_cluster` |
| `backend.es.logstash_prefix_key`  | Index Prefix key. When included, the value in the record that belongs to the key will be looked up and overwrite `Logstash_Prefix` for index generation. If `Logstash_Prefix_Key` = 'mydata' the index becomes 'mydata-YYYY.MM.DD'. | `` |
| `backend.es.replace_dots`     | Enable/Disable Replace_Dots option. | `On` |
| `backend.es.http_user`        | Optional username credential for Elastic X-Pack access. | `` |
| `backend.es.http_passwd`      | Password for user defined in HTTP_User. | `` |
| `backend.es.http_passwd_secret`     | Secret name for password for user defined in HTTP_User. | `` |
| `backend.es.http_passwd_secret_key` | Secret key for password for user defined in HTTP_User. | `` |
| `backend.es.tls`              | Enable or disable TLS support | `off` |
| `backend.es.tls_verify`       | Force certificate validation  | `on` |
| `backend.es.tls_secret`        | Existing secret storing TLS CA certificate for the Elastic instance. Specify if tls: on. Overrides `backend.es.tls_ca` | `` |
| `backend.es.tls_secret_ca_key` | Existing secret key storing TLS CA certificate for the Elastic instance. Specify if tls: on.                           | `` |
| `backend.es.tls_ca`           | TLS CA certificate for the Elastic instance (in PEM format). Specify if tls: on. | `` |
| `backend.es.tls_debug`        | Set TLS debug verbosity level. It accept the following values: 0-4 | `1` |
| **HTTP Backend**              |
| `backend.http.host`           | IP address or hostname of the target HTTP Server | `127.0.0.1` |
| `backend.http.port`           | TCP port of the target HTTP Server | `80` |
| `backend.http.uri`            | Specify an optional HTTP URI for the target web server, e.g: /something | `"/"`
| `backend.http.http_user`        | Optional username credential for Basic Authentication. | `` |
| `backend.http.http_passwd:`     | Password for user defined in HTTP_User. | `` |
| `backend.http.format`         | Specify the data format to be used in the HTTP request body, by default it uses msgpack, optionally it can be set to json.  | `msgpack` |
| `backend.http.json_date_format`         | Specify the format of the date. Supported formats are double and iso8601 | `double` |
| `backend.http.headers`          | HTTP Headers | `[]` |
| `backend.http.tls`              | Enable or disable TLS support | `off` |
| `backend.http.tls_verify`       | Force certificate validation  | `on` |
| `backend.http.tls_debug`        | Set TLS debug verbosity level. It accept the following values: 0-4 | `1` |
| **Splunk Backend**              |
| `backend.splunk.host`           | IP address or hostname of the target Splunk Server | `127.0.0.1` |
| `backend.splunk.port`           | TCP port of the target Splunk Server | `8088` |
| `backend.splunk.token`            | Specify the Authentication Token for the HTTP Event Collector interface. | `` |
| `backend.splunk.send_raw`         | If enabled, record keys and values are set in the main map. | `off` |
| `backend.splunk.tls`           | Enable or disable TLS support | `on` |
| `backend.splunk.tls_verify`           | Force TLS certificate validation | `off` |
| `backend.splunk.tls_debug`        | Set TLS debug verbosity level. It accept the following values: 0-4 | `1` |
| `backend.splunk.message_key`           | Tag applied to all incoming logs | `kubernetes` |
| **Stackdriver Backend**              |
| `backend.stackdriver.google_service_credentials`           | Contents of a Google Cloud credentials JSON file. | `` |
| `backend.stackdriver.service_account_email`           | Account email associated to the service. Only available if no credentials file has been provided. | `` |
| `backend.stackdriver.service_account_secret`            | Private key content associated with the service account. Only available if no credentials file has been provided. | `` |
| **Parsers**                   |
| `parsers.enabled`                  | Enable custom parsers | `false` |
| `parsers.regex`                    | List of regex parsers | `NULL` |
| `parsers.json`                     | List of json parsers | `NULL` |
| `parsers.logfmt`                   | List of logfmt parsers | `NULL` |
| **General**                   |
| `annotations`                      | Optional deamonset set annotations                      | `NULL`                              |
| `audit.enable`                     | Enable collection of audit logs                         | `false`                             |
| `audit.input.memBufLimit`          | Specify Mem_Buf_Limit in tail input                     | `35mb`                              |
| `audit.input.parser`               | Specify Parser in tail input                            | `docker`                            |
| `audit.input.tag`                  | Specify Tag in tail input                               | `audit.*`                           |
| `audit.input.path`                 | Specify log file(s) through the use of common wildcards | `/var/log/kube-apiserver-audit.log` |
| `audit.input.bufferChunkSize`      | Specify Buffer_Chunk_Size in tail                       | `2MB`                               |
| `audit.input.bufferMaxSize`        | Specify Buffer_Max_Size in tail                         | `10MB`                              |
| `audit.input.skipLongLines`        | Specify Skip_Long_Lines in tail                         | `On`                                |
| `audit.input.key`                  | Specify Key in tail                                     | `kubernetes-audit`                             |
| `podAnnotations`                   | Optional pod annotations                  | `NULL`                |
| `podLabels`                        | Optional pod labels                       | `NULL`                |
| `fullConfigMap`                    | User has provided entire config (parsers + system)  | `false`      |
| `existingConfigMap`                | ConfigMap override                         | ``                    |
| `extraEntries.input`               |    Extra entries for existing [INPUT] section                     | ``                    |
| `extraEntries.filter`              |    Extra entries for existing [FILTER] section                     | ``                    |
| `extraEntries.output`              |   Extra entries for existing [OUPUT] section                     | ``                    |
| `extraPorts`                       | List of extra ports                        |                       |
| `extraVolumeMounts`                | Mount an extra volume, required to mount ssl certificates when elasticsearch has tls enabled |          |
| `extraVolume`                      | Extra volume                               |                                                |
| `service.flush`                    | Interval to flush output (seconds)        | `1`                   |
| `service.logLevel`                 | Diagnostic level (error/warning/info/debug/trace)        | `info`                   |
| `filter.enableExclude`             | Enable the use of monitoring for a pod annotation of `fluentbit.io/exclude: true`. If present, discard logs from that pod.         | `true`                                 |
| `filter.enableParser`              | Enable the use of monitoring for a pod annotation of `fluentbit.io/parser: parser_name`. parser_name must be the name of a parser contained within parsers.conf         | `true`                                 |
| `filter.kubeURL`                   | Optional custom configmaps                 | `https://kubernetes.default.svc:443`            |
| `filter.kubeCAFile`                | Optional custom configmaps       | `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`    |
| `filter.kubeTokenFile`             | Optional custom configmaps       | `/var/run/secrets/kubernetes.io/serviceaccount/token`     |
| `filter.kubeTag`                   | Optional top-level tag for matching in filter         | `kube`                                 |
| `filter.kubeTagPrefix`             | Optional tag prefix used by Tail   | `kube.var.log.containers.`                                |
| `filter.mergeJSONLog`              | If the log field content is a JSON string map, append the map fields as part of the log structure         | `true`                                 |
| `filter.mergeLogKey`               | If set, append the processed log keys under a new root key specified by this variable. | `nil` |
| `filter.useJournal`                | If true, the filter reads logs coming in Journald format.  | `false` |
| `image.fluent_bit.repository`      | Image                                      | `fluent/fluent-bit`                               |
| `image.fluent_bit.tag`             | Image tag                                  | `1.3.7`                                           |
| `image.pullPolicy`                 | Image pull policy                          | `Always`                                          |
| `nameOverride`                     | Override name of app                   | `nil`                                        |
| `fullnameOverride`                 | Override full name of app              | `nil`                                        |
| `image.pullSecrets`                | Specify image pull secrets                 | `nil`                                             |
| `input.tail.memBufLimit`           | Specify Mem_Buf_Limit in tail input        | `5MB`                                             |
| `input.tail.parser`                | Specify Parser in tail input.        | `docker`                                             |
| `input.tail.path`                  | Specify log file(s) through the use of common wildcards.        | `/var/log/containers/*.log`                                             |
| `input.tail.ignore_older`          | Ignores files that have been last modified before this time in seconds. Supports m,h,d (minutes, hours,days) syntax.        | ``                                             |
| `input.systemd.enabled`            | [Enable systemd input](https://docs.fluentbit.io/manual/input/systemd)                   | `false`                                       |
| `input.systemd.filters.systemdUnit` | Please see https://docs.fluentbit.io/manual/input/systemd | `[docker.service, kubelet.service`, `node-problem-detector.service]`                                       |
| `input.systemd.maxEntries`         | Please see https://docs.fluentbit.io/manual/input/systemd | `1000`                             |
| `input.systemd.readFromTail`       | Please see https://docs.fluentbit.io/manual/input/systemd | `true`                             |
| `input.systemd.stripUnderscores`       | Please see https://docs.fluentbit.io/manual/input/systemd | `false`                             |
| `input.systemd.tag`                | Please see https://docs.fluentbit.io/manual/input/systemd | `host.*`                           |
| `rbac.create`                      | Specifies whether RBAC resources should be created.   | `true`                                 |
| `rbac.pspEnabled`                  | Specifies whether a PodSecurityPolicy should be created. | `false`                             |
| `serviceAccount.create`            | Specifies whether a ServiceAccount should be created. | `true`                                 |
| `serviceAccount.name`              | The name of the ServiceAccount to use.     | `NULL`                                            |
| `serviceAccount.annotations`       | Annotations to add to the service account. | `{}`                                              |
| `rawConfig`                        | Raw contents of fluent-bit.conf            | `@INCLUDE fluent-bit-service.conf`<br>`@INCLUDE fluent-bit-input.conf`<br>`@INCLUDE fluent-bit-filter.conf`<br>` @INCLUDE fluent-bit-output.conf`                                                                         |
| `resources`                        | Pod resource requests & limits                                 | `{}`                          |
| `securityContext`                  | [Security settings for a container](https://kubernetes.io/docs/concepts/policy/security-context) | `{}` |
| `podSecurityContext`               | [Security settings for a pod](https://kubernetes.io/docs/concepts/policy/security-context)       | `{}` |
| `hostNetwork`                      | Use host's network                         | `false`                                           |
| `dnsPolicy`                        | Specifies the dnsPolicy to use             | `ClusterFirst`                                    |
| `priorityClassName`                | Specifies the priorityClassName to use     | `NULL`                                            |
| `tolerations`                      | Optional daemonset tolerations             | `NULL`                                            |
| `nodeSelector`                     | Node labels for fluent-bit pod assignment  | `NULL`                                            |
| `affinity`                         | Expressions for affinity                   | `NULL`                                            |
| `metrics.enabled`                  | Specifies whether a service for metrics should be exposed | `false`                            |
| `metrics.service.annotations`      | Optional metrics service annotations       | `NULL`                                            |
| `metrics.service.labels`           | Additional labels for the fluent-bit metrics service definition, specified as a map.                                                    | None                                              |
| `metrics.service.port`             | Port on where metrics should be exposed    | `2020`                                            |
| `metrics.service.type`             | Service type for metrics                   | `ClusterIP`                                       |
| `metrics.serviceMonitor.enabled`          | Set this to `true` to create ServiceMonitor for Prometheus operator                   | `false` |
| `metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `metrics.serviceMonitor.namespace`        | Optional namespace in which to create ServiceMonitor                                  | `nil`   |
| `metrics.serviceMonitor.interval`         | Scrape interval. If not set, the Prometheus default scrape interval is used           | `nil`   |
| `metrics.serviceMonitor.scrapeTimeout`    | Scrape timeout. If not set, the Prometheus default scrape timeout is used             | `nil`   |
| `trackOffsets`                     | Specify whether to track the file offsets for tailing docker logs. This allows fluent-bit to pick up where it left after pod restarts but requires access to a `hostPath` | `false` |
| `testFramework.image`              | `test-framework` image repository.         | `dduportal/bats`                                  |
| `testFramework.tag`                | `test-framework` image tag.                | `0.4.0`                                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/fluent-bit
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Upgrading

### From < 1.0.0 To >= 1.0.0

Values `extraInputs`, `extraFilters` and `extraOutputs` have been removed in version `1.0.0` of the fluent-bit chart.
To add additional entries to the existing sections, please use the `extraEntries.input`, `extraEntries.filter` and `extraEntries.output` values.
For entire sections, please use the `rawConfig` value, inserting blocks of text as desired.

### From < 1.8.0 to >= 1.8.0

Version `1.8.0` introduces the use of release name as full name if it contains the chart name(fluent-bit in this case). E.g. with a release name of `fluent-bit`, this renames the DaemonSet from `fluent-bit-fluent-bit` to `fluent-bit`. The suggested approach is to delete the release and reinstall it.
