# Graylog

This chart provide the [Graylog](https://www.graylog.org/) deployments.
Note: It is strongly recommend to use on Official Graylog image to run this chart.

## Quick Installation
This chart requires the following charts before install Graylog

1. MongoDB
2. Elasticsearch

To install the Graylog Chart with all dependencies

```bash
kubectl create namespace graylog

helm install --namespace "graylog" -n "graylog" stable/graylog
```

## Manually Install Dependencies
This method is *recommended* when you want to expand the availability, scalability, and security of the services. You need to install MongoDB replicaset and Elasticsearch with proper settings before install Graylog.

To install MongoDB, run

```bash
helm install --namespace "graylog" -n "mongodb" stable/mongodb-replicaset
```

To install Elasticsearch, run

```bash
helm install --namespace "graylog" -n "elasticsearch" stable/elasticsearch
```

Note: There are many alternative Elasticsearch available on GitHub. If you found the `stable/elasticsearch` is not suitable, you can search other charts from GitHub repositories.

## Install Chart
To install the Graylog Chart into your Kubernetes cluster (This Chart requires persistent volume by default, you may need to create a storage class before install chart.

```bash
helm install --namespace "graylog" -n "graylog" stable/graylog \
  --set tags.install-mongodb=false\
  --set tags.install-elasticsearch=false\
  --set graylog.mongodb.uri=mongodb://mongodb-mongodb-replicaset-0.mongodb-mongodb-replicaset.graylog.svc.cluster.local:27017/graylog?replicaSet=rs0 \
  --set graylog.elasticsearch.hosts=http://elasticsearch-client.graylog.svc.cluster.local:9200
```

After installation succeeds, you can get a status of Chart

```bash
helm status "graylog"
```

If you want to delete your Chart, use this command
```bash
helm delete --purge "graylog"
```

## Install Chart with specific Graylog cluster size
By default, this Chart will create a graylog with 2 nodes (1 master, 1 coordinating). If you want to change the cluster size during installation, you can use `--set graylog.replicas={value}` argument. Or edit `values.yaml`

For example:
Set cluster size to 5

```bash
helm install --namespace "graylog" -n "graylog" --set graylog.replicas=5 stable/graylog
```

The command above will install 1 master and 4 coordinating.

## Install Chart with specific node pool
Sometime you may need to deploy your graylog to specific node pool to allocate resources.

### Using node selector
For example, you have 6 vms in node pools and you want to deploy graylog to node which labeled as `cloud.google.com/gke-nodepool: graylog-pool`
Set the following values in `values.yaml`

```yaml
graylog:
   nodeSelector: { cloud.google.com/gke-nodepool: graylog-pool }
```

### Using tolerations
For example, you have 6 vms in node pools and 3 nodes are tainted with `NO_SCHEDULE graylog=true`
Set the following values in `values.yaml`

```yaml
graylog:
  tolerations:
    - key: graylog
      value: "true"
      operator: "Equal"
```

## Configuration

The following table lists the configurable parameters of the Graylog chart and their default values.

| Parameter                               | Description                                                                                                                                           | Default                               |
|-----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| `graylog.image.repository`              | `graylog` image repository   | `graylog/graylog:3.1.2-1`                 |
| `graylog.imagePullPolicy`               | Image pull policy                                                                                                                                     | `IfNotPresent`                        |
| `graylog.replicas`                      | The number of Graylog instances in the cluster. The chart will automatic create assign master to one of replicas                                      | `2`                                   |
| `graylog.resources`                     | CPU/Memory resource requests/limits                                                                                                                   | Memory: `1024Mi`, CPU: `500m`         |
| `graylog.heapSize`                      | Override Java heap size. If this value empty, chart will allocate heapsize using `-XX:+UseCGroupMemoryLimitForHeap`                                   | ``                                    |
| `graylog.nodeSelector`                  | Graylog server pod assignment                                                                                                                         | `{}`                                  |
| `graylog.affinity`                      | Graylog server affinity                                                                                                                               | `{}`                                  |
| `graylog.tolerations`                   | Graylog server tolerations                                                                                                                            | `[]`                                  |
| `graylog.nodeSelector`                  | Graylog server node selector                                                                                                                          | `{}`                                  |
| `graylog.env`                           | Graylog server env variables                                                                                                                          | `{}`                                  |
| `graylog.service.type`                  | Kubernetes Service type                                                                                                                               | `ClusterIP`                           |
| `graylog.service.port`                  | Graylog Service port                                                                                                                                  | `9000`                                |
| `graylog.service.master.port`           | Graylog Master Service port                                                                                                                           | `9000`                                |
| `graylog.service.master.annotations`    | Graylog Master Service annotations                                                                                                                    | `{}`                                  |
| `graylog.podAnnotations`                | Kubernetes Pod annotations                                                                                                                            | `{}`                                  |
| `graylog.terminationGracePeriodSeconds` | Pod termination grace period                                                                                                                          | `120`                                 |
| `graylog.updateStrategy`                | Update Strategy of the StatefulSet                                                                                                                    | `RollingUpdate`                           |
| `graylog.persistence.enabled`           | Use a PVC to persist data                                                                                                                             | `true`                                |
| `graylog.persistence.storageClass`      | Storage class of backing PVC                                                                                                                          | `nil` (uses storage class annotation) |
| `graylog.persistence.accessMode`        | Use volume as ReadOnly or ReadWrite                                                                                                                   | `ReadWriteOnce`                       |
| `graylog.persistence.size`              | Size of data volume                                                                                                                                   | `10Gi`                                |
| `graylog.ingress.enabled`               | If true, Graylog Ingress will be created                                                                                                              | `false`                               |
| `graylog.ingress.port`                  | Graylog Ingress port                                                                                                                                  | `false`                               |
| `graylog.ingress.annotations`           | Graylog Ingress annotations                                                                                                                           | `{}`                                  |
| `graylog.ingress.hosts`                 | Graylog Ingress host names                                                                                                                            | `[]`                                  |
| `graylog.ingress.tls`                   | Graylog Ingress TLS configuration (YAML)                                                                                                              | `[]`                                  |
| `graylog.ingress.extraPaths`            | Ingress extra paths to prepend to every host configuration. Useful when configuring [custom actions with AWS ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#actions). | `[]`                                  |
| `graylog.input`                         | Graylog Input configuration (YAML) Sees #Input section for detail                                                                                     | `{}`                                  |
| `graylog.metrics.enabled`               | If true, add Prometheus annotations to pods                                                                                                           | `false`                               |
| `graylog.geoip.enabled`                 | If true, Maxmind Geoip Lite will be installed to ${GRAYLOG_HOME}/etc/GeoLite2-City.mmdb                                                               | `false`                               |
| `graylog.plugins`                       | A list of Graylog installation plugins                                                                                                                | `[]`                                  |
| `graylog.rootUsername`                  | Graylog root user name                                                                                                                                | `admin`                               |
| `graylog.rootPassword`                  | Graylog root password. If not set, random 10-character alphanumeric string                                                                            | ``                                    |
| `graylog.rootEmail`                     | Graylog root email.                                                                                                                                   | ``                                    |
| `graylog.existingRootSecret`            | Graylog existing root secret                                                                                                                          | ``                                    |
| `graylog.rootTimezone`                  | Graylog root timezone.                                                                                                                                | `UTC`                                 |
| `graylog.elasticsearch.hosts`           | Graylog Elasticsearch host name. You need to specific where data will be stored.                                                                      | ``                                    |
| `graylog.mongodb.uri`                   | Graylog MongoDB connection string. You need to specific where data will be stored.                                                                    | ``                                    |
| `graylog.transportEmail.enabled`        | If true, enable transport email settings on Graylog                                                                                                   | `false`                               |
| `graylog.config`                        | Add additional server configuration to `graylog.conf` file.                                                                                           | ``                                    |
| `graylog.serverFiles`                   | Add additional server files on /etc/graylog/server. This is useful for enable TLS on input                                                            | `{}`                                  |
| `graylog.journal.deleteBeforeStart`     | Delete all journal files before start Graylog                                                                                                         | `false`                               |
| `graylog.init.resources`                | Configure resource requests and limits for the Graylog StatefulSet initContainer                                                                      | `{}`                                  |
| `graylog.provisioner.enabled`           | Enable optional Job to run an arbitrary Bash script                                                                                                   | `false`                               |
| `graylog.provisioner.script`            | The contents of the provisioner Bash script                                                                                                           | ``                                    |
| `rbac.create`                           | If true, create & use RBAC resources                                                                                                                  | `true`                                |
| `rbac.serviceAccount.create`            | If true, create the Graylog service account                                                                                                           | `true`                                |
| `rbac.serviceAccount.name`              | Name of the server service account to use or create                                                                                                   | `{{ graylog.fullname }}`              |
| `tags.install-mongodb`                  | If true, this chart will install MongoDB from requirement dependencies. If you want to install MongoDB by yourself, please set to `false`             | `true`                                |
| `tags.install-elasticsearch`            | If true, this chart will install Elasticsearch from requirement dependencies. If you want to install Elasticsearch by yourself, please set to `false` | `true`                                |

## How it works
This chart will create a Graylog statefulset with one Master node. The chart will automatically create Master node Pod label `graylog-role=master`, if it does not exists. The others Pods will be label with `graylog-role=coordinating`

This chart will automatically calculate Java heap size from given `resources.requests.memory` value. If you want to specify number of heap size, you can set `graylog.heapSize` to your desired value. The `graylog.heapSize` value must be in JVM `-Xmx` format.

## Input
You can enable input ports by edit the `input` values. For example, you want to create a GELF input on port `12222`, and `12223` with Cloud LoadBalancer and syslog on UDP port `5410` without load balancer.

```
  input:
    tcp:
      service:
        type: LoadBalancer
        loadBalancerIP:
      ports:
        - name: gelf1
          port: 12222
        - name: gelf2
          port: 12223
    udp:
      service:
        type: ClusterIP
      ports:
        - name: syslog
          port: 5410
```

Note: Name must be in IANA_SVC_NAME (at most 15 characters, matching regex [a-z0-9]([a-z0-9-]*[a-z0-9])* and it must contains at least one letter [a-z], hyphens cannot be adjacent to other hyphens)

Note: The port list should be sorted by port number.


## Input TLS
To enable TLS on input in Graylog, you need to specify the server private key and certificate. You can add them in `graylog.serverFiles` value. For example

```yaml
graylog:
  serverFiles:
    server.cert: |
      -----BEGIN CERTIFICATE-----
      MIIFYTCCA0mgAwIBAgICEAIwDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMCVEgx
      EDAOBgNVBAgMB0Jhbmdrb2sxEDAOBgNVBAcMB0Jhbmdrb2sxGDAWBgNVBAoMD09t
      aXNlIENvLiwgTHRkLjEPMA0GA1UECwwGRGV2b3BzMRQwEgYDVQQDDAtjYS5vbWlz
      ZS5jbzAeFw0xNzA2MDEwOTQ0NTJaFw0xOTA2MjEwOTQ0NTJaMHkxCzAJBgNVBAYT
      AlRIMRAwDgYDVQQIDAdCYW5na29rMRAwDgYDVQQHDAdCYW5na29rMRgwFgYDVQQK
      DA9PbWlzZSBDby4sIEx0ZC4xDzANBgNVBAsMBkRldm9wczEbMBkGA1UEAwwSZ3Jh
      4YE6FOKJmiDV7KsmoSO2JTEaZAK6sdxI7zFJJH0TNFIuKewEBsVH/W5RccjwK/z/
      BHwoTQc95zbfFjt1JwDiq8jGTVnQoXH99wAIW+HDYq6hqHyqW3YuQ8QvXfi/ebAs
      rn0urmEC7JhsZIg92AqVYEgdp5H6uFqPIK1U6aYrz5zzZpRfEA==
      -----END CERTIFICATE-----
    server.key: |
      -----BEGIN PRIVATE KEY-----
      MIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQC1zwgrnurQGlwe
      ZcKe2RXLs9XzQo4PzNsbxRQXSZef/siUZ/X3phd7Tt7QbQv8sxoZFR1/R4neN3KV
      tsWJ6YL3CY1IwqzxtR6SHzkg/CgUFgP4Jq9NDodOFRlmkZBK9iO9x/VITxLZPBQt
      f+ygeNhfG/oZZxlLSWNC/adlFfUGI8TujCGGyydxAegyWRYmhkLM7F3vRqMXiUn2
      UP/nPEMasHiHS7r99RzJILbU494aNYTxprfBAoGAdWwO/4I/r3Zo672AvCs2s/P6
      G85cX2hKMFy3B4/Ww53jFA3bsWTOyXBv4srl3v9C3xkQmDwUxPDshEN45JX1AMIc
      vxQkW5cm2IaPHB1BsuQpAuW6qIBT/NZqLmexb4jipAjTN4wQ2dkjI/zK2/SST5wb
      vNufGafZ1IpvkUsDkA0=
      -----END PRIVATE KEY-----
```

Then configure Graylog input to

| Parameter      | Value                           |
|----------------|---------------------------------|
| tls_cert_file: | /etc/graylog/server/server.cert |
| tls_enable:    | true                            |
| tls_key_file:  | /etc/graylog/server/server.key  |

## Get Graylog status
You can get your Graylog status by running the command

```
kubectl get po -L graylog-role
```

Output
```
NAME                        READY     STATUS    RESTARTS   AGE       graylog-ROLE
graylog-0                   1/1       Running     0          1d        master
graylog-1                   1/1       Running     0          1d        coordinating
graylog-2                   1/1       Running     0          1m        coordinating
```
## Trouble shooting

If you are encounter "Unprocessed Messages" or Journal files corrupted, you may need to delete all journal files before staring Graylog.
You can do this automatically by setting `graylog.journal.deleteBeforeStart` to `true`

The chart will delete all journal files before starting Graylog.

Note: All uncommitted logs will be permanently DELETED when this value is true
