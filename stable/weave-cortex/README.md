#Cortex
This is a chart to install cortex into a kubernetes cluster locally, without the dependency on the weave-cloud. 

Below is the list of properties that can be configured through the values.yaml,
or  through --set <oroperty>=<value>  when installing the helm chart.

When using this deployment you may want to set the ip address of your clusters DNS service.
If you are getting errors with nginx finding services, then this is likely the cause.
You can use the following command to get your clusters kube-dns ip address.
```
kubectl get service kube-dns --namespace kube-system -o jsonpath={.spec.clusterIP}
```

Then on helm install you may set the ``nginx.http.resolverAddress`` the the ip of your DNS.

If you would like to use an s3 bucket from amazon, then you may also update the S3 URI,
and disable the fakeS3 service.

Set ``fakeS3.enabled=false``, and set ``global.s3URI=<your S3 bucket>``

### global
|Property|Default Value|
|---|---|
|global.s3URI|"s3://abc:123@s3.default.svc.cluster.local:4569"|
|global.dynamoDBURI|"dynamodb://user:pass@dynamodb.default.svc.cluster.local:8000"|
|global.consulURI|"consul.default.svc.cluster.local:8500"|
|global.memcachedURI|"memcached.default.svc.cluster.local"|
|global.memcachedTimeout|"100ms"|
|global.memcachedService|"memcached"|
|global.configDbURI|"postgres://postgres@configs-db.default.svc.cluster.local/configs?sslmode=disable"|
|global.configs|"http://configs.default.svc.cluster.local:80"|
|global.alertmanagerURI|"http://alertmanager.default.svc.cluster.local/api/prom/alertmanager/"|
### alertmanager
|Property|Default Value|
|---|---|
|alertmanager.image.repository|"quay.io/weaveworks/cortex-alertmanager"|
|alertmanager.image.tag|"master-0a92a540"|
|alertmanager.image.imagePullPolicy|"IfNotPresent"|
|alertmanager.listenPort|80|
|alertmanager.servicePort|80|
|alertmanager.configURL|"http://configs.default.svc.cluster.local:80"|
|alertmanager.externalURI|"/api/prom/alertmanager"|
|alertmanager.loglevel|"debug"|
### postgressConfigDB
|Property|Default Value|
|---|---|
|postgressConfigDB.servicePort|5432|
|postgressConfigDB.listenPort|5432|
|postgressConfigDB.image.repository|"postgres"|
|postgressConfigDB.image.tag|9.6|
|postgressConfigDB.image.pullPolicy|"IfNotPresent"|
### cortexConfigs
|Property|Default Value|
|---|---|
|cortexConfigs.listenPort|80|
|cortexConfigs.servicePort|80|
|cortexConfigs.migrationsURI|"/migrations"|
|cortexConfigs.image.repository|"quay.io/weaveworks/cortex-configs"|
|cortexConfigs.image.tag|"master-eb4b2116"|
|cortexConfigs.image.pullPolicy|"IfNotPresent"|
### consul
|Property|Default Value|
|---|---|
|consul.serverNoScrapePort|8300|
|consul.serfNoScrapePort|8301|
|consul.clientNoScrapePort|8400|
|consul.httpNoScrapePort|8500|
|consul.serviceHttpPort|8500|
|consul.image.repository|"consul"|
|consul.image.tag|"0.7.1"|
|consul.image.pullPolicy|"IfNotPresent"|
### distributor
|Property|Default Value|
|---|---|
|distributor.logLevel|"debug"|
|distributor.listenPort|80|
|distributor.servicePort|80|
|distributor.consulHostName|"consul.default.svc.cluster.local"|
|distributor.replicationFactor|1|
|distributor.image.repository|"quay.io/weaveworks/cortex-distributor"|
|distributor.image.tag|"master-eb4b2116"|
|distributor.image.pullPolicy|"IfNotPresent"|
### dynamodb
|Property|Default Value|
|---|---|
|dynamodb.listenPort|8000|
|dynamodb.servicePort|8000|
|dynamodb.image.repository|"deangiberson/aws-dynamodb-local"|
|dynamodb.image.tag|"latest"|
|dynamodb.image.pullPolicy|"IfNotPresent"|
### ingester
|Property|Default Value|
|---|---|
|ingester.replicas|1|
|ingester.minReadySeconds|60|
|ingester.joinAfter|"30s"|
|ingester.claimOnRollout|false|
|ingester.terminationGracePeriodSeconds|2400|
|ingester.listenPort|80|
|ingester.servicePort|80|
|ingester.strategy.rollingUpdateMaxSurge|0|
|ingester.strategy.rollingUpdateMinAvailable|1|
|ingester.image.repository|"quay.io/weaveworks/cortex-ingester"|
|ingester.image.tag|"master-747f3493"|
|ingester.image.pullPolicy|"IfNotPresent"|
### memcached
|Property|Default Value|
|---|---|
|memcached.replicas|1|
|memcached.maxMemMB|64|
|memcached.listenPort|11211|
|memcached.servicePort|11211|
|memcached.image.repository|"memcached"|
|memcached.image.tag|"1.4.25"|
|memcached.image.pullPolicy|"IfNotPresent"|
### nginx
|Property|Default Value|
|---|---|
|nginx.replicas|1|
|nginx.listenPort|80|
|nginx.servicePort|80|
|nginx.serviceType|"NodePort"|
|nginx.nodePort|30080|
|nginx.image.repository|"nginx"|
|nginx.image.tag|"latest"|
|nginx.image.pullPolicy|"IfNotPresent"|
|nginx.config.workerProcesses|5|
|nginx.config.errorLog|"/dev/stderr"|
|nginx.config.pid|"nginx.pid"|
|nginx.config.workerRLimitNoFile|8192|
|nginx.config.workerConnections|4096|
|nginx.config.http.sendfile|true|
|nginx.config.http.tcpNoPush|true|
|nginx.config.http.resolverAddress|"10.0.0.10"|
|nginx.config.server.listenPort|80|
|nginx.config.server.pushPassthroughURI|"http://distributor.default.svc.cluster.local"|
|nginx.config.server.queryPassthroughURI|"http://querier.default.svc.cluster.local"|
### querier
|Property|Default Value|
|---|---|
|querier.replicas|1|
|querier.listenPort|80|
|querier.servicePort|80|
|querier.image.repository|"quay.io/weaveworks/cortex-querier"|
|querier.image.tag|"master-eb4b2116"|
|querier.image.pullPolicy|"IfNotPresent"|
### ruler
|Property|Default Value|
|---|---|
|ruler.replicas|1|
|ruler.logLevel|"debug"|
|ruler.listenPort|80|
|ruler.servicePort|80|
|ruler.image.repository|"quay.io/weaveworks/cortex-ruler"|
|ruler.image.tag|"master-eb4b2116"|
|ruler.image.pullPolicy|"IfNotPresent"|
### fakeS3
|Property|Default Value|
|---|---|
|fakeS3.enabled|true|
|fakeS3.replicas|1|
|fakeS3.listenPort|4569|
|fakeS3.servicePort|4569|
|fakeS3.image.repository|"lphoward/fake-s3"|
|fakeS3.image.tag|"latest"|
|fakeS3.image.pullPolicy|"IfNotPresent"|
### tableManager
|Property|Default Value|
|---|---|
|tableManager.replicas|1|
|tableManager.listenPort|80|
|tableManager.servicePort|80|
|tableManager.image.repository|"quay.io/weaveworks/cortex-table-manager"|
|tableManager.image.tag|"master-d18915fb"|
|tableManager.image.pullPolicy|"IfNotPresent"|
### retrieval
|Property|Default Value|
|---|---|
|retrieval.replicas|1|
|retrieval.listenPort|80|
|retrieval.servicePort|80|
|retrieval.image.repository|"prom/prometheus"|
|retrieval.image.tag|"v1.4.1"|
|retrieval.image.pullPolicy|"IfNotPresent"|

Retrieval is a configured prometheus instance with the following config.
The config can be changed by overriding the  ```retrieval.configFiles``` in the values.yaml

```
prometheus.yml: |-
      global:
        scrape_interval: 30s # By default, scrape targets every 15 seconds.

      remote_write:
        url: http://nginx.default.svc.cluster.local:80/api/prom/push

      scrape_configs:
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        # You can specify the following annotations (on pods):
        #   prometheus.io.scrape: false - don't scrape this pod
        #   prometheus.io.scheme: https - use https for scraping
        #   prometheus.io.port - scrape this port
        #   prometheus.io.path - scrape this path
        relabel_configs:

        # Always use HTTPS for the api server
        - source_labels: [__meta_kubernetes_service_label_component]
          regex: apiserver
          action: replace
          target_label: __scheme__
          replacement: https

        # Drop anything annotated with prometheus.io.scrape=false
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
          action: drop
          regex: false

        # Drop any endpoint who's pod port name ends with -noscrape
        - source_labels: [__meta_kubernetes_pod_container_port_name]
          action: drop
          regex: .*-noscrape

        # Allow pods to override the scrape scheme with prometheus.io.scheme=https
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]
          action: replace
          target_label: __scheme__
          regex: ^(https?)$
          replacement: $1

        # Allow service to override the scrape path with prometheus.io.path=/other_metrics_path
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: ^(.+)$
          replacement: $1

        # Allow services to override the scrape port with prometheus.io.port=1234
        - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
          action: replace
          target_label: __address__
          regex: (.+?)(\:\d+)?;(\d+)
          replacement: $1:$3

        # Drop pods without a name label
        - source_labels: [__meta_kubernetes_pod_label_name]
          action: drop
          regex: ^$

        # Rename jobs to be <namespace>/<name, from pod name label>
        - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_pod_label_name]
          action: replace
          separator: /
          target_label: job
          replacement: $1

        # Rename instances to be the pod name
        - source_labels: [__meta_kubernetes_pod_name]
          action: replace
          target_label: instance

        # Include node name as a extra field
        - source_labels: [__meta_kubernetes_pod_node_name]
          target_label: node

      # This scrape config gather all nodes
      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
          - role: node

        # couldn't get prometheus to validate the kublet cert for scraping, so don't bother for now
        tls_config:
          insecure_skip_verify: true
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        relabel_configs:
        - target_label: __scheme__
          replacement: https
        - source_labels: [__meta_kubernetes_node_label_kubernetes_io_hostname]
          target_label: instance

      # This scrape config just pulls in the default/kubernetes service
      - job_name: 'kubernetes-service'
        kubernetes_sd_configs:
          - role: endpoints

        tls_config:
          insecure_skip_verify: true
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        relabel_configs:
        - source_labels: [__meta_kubernetes_service_label_component]
          regex: apiserver
          action: keep

        - target_label: __scheme__
          replacement: https

        - source_labels: []
          target_label: job
          replacement: default/kubernetes
```
