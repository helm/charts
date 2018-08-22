# Fluentd 

Helm chart to run [fluentd](https://www.fluentd.org/) on kubernetes.

## Use cases

We tried to write chart flexible enough to use in all possible configurations

### Listen port and save logs to Elastic Search

This configuration is **Default**, so we provide `quick start` and `full config` example to install.

#### Quick start
`helm install --name logs incubator/fluentd`
Now you can forward logs to port `24220` and it would be saved to Elastic Search `elasticsearch-client.default.svc.cluster.local`  

#### Full config

Create `values.yaml` file containing this values (replace ${%VARS%} with values for your infrastructure)

```yaml
image:
  repository: gcr.io/google-containers/fluentd-elasticsearch
  tag: v2.0.4

env:
  open:
    OUTPUT_HOST: ${ELASTIC_SEARCH_HOST}
    OUTPUT_PORT: ${ELASTIC_SEARCH_PORT}
    OUTPUT_BUFFER_CHUNK_LIMIT: 2M
    OUTPUT_BUFFER_QUEUE_LIMIT: 8

configDir: /etc/fluent/config.d
configMap:
  general.conf: |
    <match fluentd.**>
      @type null
    </match>

    <source>
      @type monitor_agent
      bind 0.0.0.0
      port ${FLUENTD_PORT}
      tag fluentd.monitor.metrics
    </source>
  forward-input.conf: |
    <source>
      @type forward
      port 24224
      bind 0.0.0.0
    </source>
  output.conf: |
    <match **>
      @id elasticsearch
      @type elasticsearch
      @log_level info
      include_tag_key true
      # Replace with the host/port to your Elasticsearch cluster.
      host "#{ENV['OUTPUT_HOST']}"
      port "#{ENV['OUTPUT_PORT']}"
      logstash_format true
      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever
        retry_max_interval 30
        chunk_limit_size "#{ENV['OUTPUT_BUFFER_CHUNK_LIMIT']}"
        queue_limit_length "#{ENV['OUTPUT_BUFFER_QUEUE_LIMIT']}"
        overflow_action block
      </buffer>
    </match>

service:
  type: ClusterIP
  ports:
  - name: "monitor-agent"
    protocol: TCP
    externalPort: ${FLUENTD_PORT}
    containerPort: ${FLUENTD_PORT}
```

`helm install --name logs incubator/fluentd -f values.yaml`


## Read k8s logs and forward to Elastic Search

This is installation can be replacement for [fluentd-elasticsearch](https://github.com/kubernetes/charts/tree/master/incubator/fluentd-elasticsearch)


### Use fluentd official containers for kubernetes

Create `values.yaml` file containing this values (replace ${%VARS%} with values for your infrastructure)

```yaml
image:
 repository: fluent/fluentd-kubernetes-daemonset
 tag: v0.12.33-elasticsearch
env:
 open:
   FLUENT_ELASTICSEARCH_HOST: ${FLUENT_ELASTICSEARCH_HOST}
   FLUENT_ELASTICSEARCH_PORT: ${FLUENT_ELASTICSEARCH_PORT}
 secret:
  FLUENT_ELASTICSEARCH_USER: ${FLUENT_ELASTICSEARCH_USER}
  FLUENT_ELASTICSEARCH_PASSWORD: ${FLUENT_ELASTICSEARCH_PASSWORD}
## Mount fluentd configs from chart into tmp dir, because all required configs build in image
## https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v0.12/alpine-elasticsearch/conf
configDir: /tmp/conf
```
 
`helm install --name logs incubator/fluentd -f values.yaml`

### Use custom configs

This is approach used in [fluentd-elasticsearch](https://github.com/kubernetes/charts/tree/master/incubator/fluentd-elasticsearch)

Create `values.yaml` file containing this values (replace ${%VARS%} with values for your infrastructure)

```yaml
image:
 repository: gcr.io/google-containers/fluentd-elasticsearch
 tag: v2.0.4

env:
 open:
   OUTPUT_HOST: ${ELASTIC_SEARCH_HOST}
   OUTPUT_PORT: ${ELASTIC_SEARCH_PORT}
   OUTPUT_BUFFER_CHUNK_LIMIT: 2M
   OUTPUT_BUFFER_QUEUE_LIMIT: 8

configDir: /etc/fluent/config.d
configMap:
  system.conf: |-
    <system>
      root_dir /tmp/fluentd-buffers/
    </system>
  containers.input.conf: |-
    <source>
      @id fluentd-containers.log
      @type tail
      path /var/log/containers/*.log
      pos_file /var/log/fluentd-containers.log.pos
      time_format %Y-%m-%dT%H:%M:%S.%NZ
      tag raw.kubernetes.*
      format json
      read_from_head true
    </source>
    # Detect exceptions in the log output and forward them as one log entry.
    <match raw.kubernetes.**>
      @id raw.kubernetes
      @type detect_exceptions
      remove_tag_prefix raw
      message log
      stream stream
      multiline_flush_interval 5
      max_bytes 500000
      max_lines 1000
    </match>
  system.input.conf: |-
    # Example:
    # 2015-12-21 23:17:22,066 [salt.state       ][INFO    ] Completed state [net.ipv4.ip_forward] at time 23:17:22.066081
    <source>
      @id minion
      @type tail
      format /^(?<time>[^ ]* [^ ,]*)[^\[]*\[[^\]]*\]\[(?<severity>[^ \]]*) *\] (?<message>.*)$/
      time_format %Y-%m-%d %H:%M:%S
      path /var/log/salt/minion
      pos_file /var/log/salt.pos
      tag salt
    </source>
    # Example:
    # Dec 21 23:17:22 gke-foo-1-1-4b5cbd14-node-4eoj startupscript: Finished running startup script /var/run/google.startup.script
    <source>
      @id startupscript.log
      @type tail
      format syslog
      path /var/log/startupscript.log
      pos_file /var/log/startupscript.log.pos
      tag startupscript
    </source>
    # Examples:
    # time="2016-02-04T06:51:03.053580605Z" level=info msg="GET /containers/json"
    # time="2016-02-04T07:53:57.505612354Z" level=error msg="HTTP Error" err="No such image: -f" statusCode=404
    <source>
      @id docker.log
      @type tail
      format /^time="(?<time>[^)]*)" level=(?<severity>[^ ]*) msg="(?<message>[^"]*)"( err="(?<error>[^"]*)")?( statusCode=($<status_code>\d+))?/
      path /var/log/docker.log
      pos_file /var/log/docker.log.pos
      tag docker
    </source>
    # Example:
    # 2016/02/04 06:52:38 filePurge: successfully removed file /var/etcd/data/member/wal/00000000000006d0-00000000010a23d1.wal
    <source>
      @id etcd.log
      @type tail
      # Not parsing this, because it doesn't have anything particularly useful to
      # parse out of it (like severities).
      format none
      path /var/log/etcd.log
      pos_file /var/log/etcd.log.pos
      tag etcd
    </source>
    # Multi-line parsing is required for all the kube logs because very large log
    # statements, such as those that include entire object bodies, get split into
    # multiple lines by glog.
    # Example:
    # I0204 07:32:30.020537    3368 server.go:1048] POST /stats/container/: (13.972191ms) 200 [[Go-http-client/1.1] 10.244.1.3:40537]
    <source>
      @id kubelet.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/kubelet.log
      pos_file /var/log/kubelet.log.pos
      tag kubelet
    </source>
    # Example:
    # I1118 21:26:53.975789       6 proxier.go:1096] Port "nodePort for kube-system/default-http-backend:http" (:31429/tcp) was open before and is still needed
    <source>
      @id kube-proxy.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/kube-proxy.log
      pos_file /var/log/kube-proxy.log.pos
      tag kube-proxy
    </source>
    # Example:
    # I0204 07:00:19.604280       5 handlers.go:131] GET /api/v1/nodes: (1.624207ms) 200 [[kube-controller-manager/v1.1.3 (linux/amd64) kubernetes/6a81b50] 127.0.0.1:38266]
    <source>
      @id kube-apiserver.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/kube-apiserver.log
      pos_file /var/log/kube-apiserver.log.pos
      tag kube-apiserver
    </source>
    # Example:
    # I0204 06:55:31.872680       5 servicecontroller.go:277] LB already exists and doesn't need update for service kube-system/kube-ui
    <source>
      @id kube-controller-manager.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/kube-controller-manager.log
      pos_file /var/log/kube-controller-manager.log.pos
      tag kube-controller-manager
    </source>
    # Example:
    # W0204 06:49:18.239674       7 reflector.go:245] pkg/scheduler/factory/factory.go:193: watch of *api.Service ended with: 401: The event in requested index is outdated and cleared (the requested history has been cleared [2578313/2577886]) [2579312]
    <source>
      @id kube-scheduler.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/kube-scheduler.log
      pos_file /var/log/kube-scheduler.log.pos
      tag kube-scheduler
    </source>
    # Example:
    # I1104 10:36:20.242766       5 rescheduler.go:73] Running Rescheduler
    <source>
      @id rescheduler.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/rescheduler.log
      pos_file /var/log/rescheduler.log.pos
      tag rescheduler
    </source>
    # Example:
    # I0603 15:31:05.793605       6 cluster_manager.go:230] Reading config from path /etc/gce.conf
    <source>
      @id glbc.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/glbc.log
      pos_file /var/log/glbc.log.pos
      tag glbc
    </source>
    # Example:
    # I0603 15:31:05.793605       6 cluster_manager.go:230] Reading config from path /etc/gce.conf
    <source>
      @id cluster-autoscaler.log
      @type tail
      format multiline
      multiline_flush_interval 5s
      format_firstline /^\w\d{4}/
      format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
      time_format %m%d %H:%M:%S.%N
      path /var/log/cluster-autoscaler.log
      pos_file /var/log/cluster-autoscaler.log.pos
      tag cluster-autoscaler
    </source>
    # Logs from systemd-journal for interesting services.
    <source>
      @id journald-docker
      @type systemd
      filters [{ "_SYSTEMD_UNIT": "docker.service" }]
      #pos_file /var/log/journald-docker.pos
      <storage>
        @type local
        persistent true
      </storage>
      read_from_head true
      tag docker
    </source>
    <source>
      @id journald-kubelet
      @type systemd
      filters [{ "_SYSTEMD_UNIT": "kubelet.service" }]
      <storage>
        @type local
        persistent true
      </storage>
      read_from_head true
      tag kubelet
    </source>
    <source>
      @id journald-node-problem-detector
      @type systemd
      filters [{ "_SYSTEMD_UNIT": "node-problem-detector.service" }]
      <storage>
        @type local
        persistent true
      </storage>
      read_from_head true
      tag node-problem-detector
    </source>
  forward.input.conf: |-
    # Takes the messages sent over TCP
    <source>
      @type forward
    </source>
  monitoring.conf: |-
    # Prometheus Exporter Plugin
    # input plugin that exports metrics
    <source>
      @type prometheus
    </source>
    <source>
      @type monitor_agent
    </source>
    # input plugin that collects metrics from MonitorAgent
    <source>
      @type prometheus_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>
    # input plugin that collects metrics for output plugin
    <source>
      @type prometheus_output_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>
    # input plugin that collects metrics for in_tail plugin
    <source>
      @type prometheus_tail_monitor
      <labels>
        host ${hostname}
      </labels>
    </source>
  output.conf: |-
    # Enriches records with Kubernetes metadata
    <filter kubernetes.**>
      @type kubernetes_metadata
    </filter>
    <match **>
      @id elasticsearch
      @type elasticsearch
      @log_level info
      include_tag_key true
      host "#{ENV['OUTPUT_HOST']}"
      port "#{ENV['OUTPUT_PORT']}"
      logstash_format true
      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever
        retry_max_interval 30
        chunk_limit_size "#{ENV['OUTPUT_BUFFER_CHUNK_LIMIT']}"
        queue_limit_length "#{ENV['OUTPUT_BUFFER_QUEUE_LIMIT']}"
        overflow_action block
      </buffer>
    </match>
```

`helm install --name logs incubator/fluentd -f values.yaml`


## Read k8s logs and forward to CloudWatch
   
This is installation can be replacement for [fluentd-cloudwatch](https://github.com/kubernetes/charts/tree/master/incubator/fluentd-cloudwatch)
   
Create `values.yaml` file containing this values (replace ${%VARS%} with values for your infrastructure)

```yaml
image:
 repository: fluent/fluentd-kubernetes-daemonset
 tag: v0.12.33-cloudwatch
env:
 open:
   AWS_REGION: ${AWS_REGION}
   LOG_GROUP_NAME: ${CLOUDWATCH_LOG_GROUP_NAME}
 secret:
  AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
  AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
## Mount fluentd configs from chart into tmp dir, because all required configs build in image
## https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v0.12/alpine-cloudwatch/conf
configDir: /tmp/conf
```
 
 `helm install --name logs incubator/fluentd -f values.yaml`

## Read k8s logs and forward to Datadog


Create `values.yaml` file containing this values (replace ${%VARS%} with values for your infrastructure)

```yaml
image:
 repository: cloudposse/fluentd-datadog-logs
 tag: 0.1.0
env:
 open:
   DATADOG_SOURCE: ${DATADOG_SOURCE}
 secret:
  DATADOG_API_KEY: ${DATADOG_API_KEY}
## Mount fluentd configs from chart into tmp dir, because all required configs build in image
## https://github.com/cloudposse/fluentd-datadog-logs/tree/master/rootfs/fluentd/etc/fluentd.conf
## https://github.com/cloudposse/fluentd-datadog-logs/blob/master/rootfs/fluentd/etc/fluent.conf
configDir: /tmp/conf
```
 
`helm install --name logs incubator/fluentd -f values.yaml`


## Read k8s logs and forward to Elastic Search

Create `values.yaml` file containing this values (replace ${%VARS%} with values for your infrastructure)

```yaml
image:
 repository: cloudposse/fluentd-datadog-logs
 tag: 0.1.0
env:
 open:
   DATADOG_SOURCE: ${DATADOG_SOURCE}
 secret:
  DATADOG_API_KEY: ${DATADOG_API_KEY}
## Mount fluentd configs from chart into tmp dir, because all required configs build in image
## https://github.com/cloudposse/fluentd-datadog-logs/tree/master/rootfs/fluentd/etc/fluentd.conf
## https://github.com/cloudposse/fluentd-datadog-logs/blob/master/rootfs/fluentd/etc/fluent.conf
configDir: /tmp/conf
```
 
`helm install --name logs incubator/fluentd -f values.yaml`
