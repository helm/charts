{{ define "elasticsearch.yml" -}}
cluster.name: {{ .Values.cluster.name }}
{{ if .Values.cluster.routing_attributes }}
cluster.routing.allocation.awareness.attributes: {{ .Values.cluster.routing_attributes }}
{{ end }}

node.data: ${NODE_DATA:true}
node.master: ${NODE_MASTER:true}
{{- if hasPrefix "5." .Values.appVersion }}
node.ingest: ${NODE_INGEST:true}
{{- else if hasPrefix "6." .Values.appVersion }}
node.ingest: ${NODE_INGEST:true}
{{- end }}
node.name: ${HOSTNAME}

network.host: 0.0.0.0
transport.tcp.port: 9300
http.port: 9200

{{- if hasPrefix "1." .Values.appVersion }}
# see https://github.com/kubernetes/kubernetes/issues/3595
bootstrap.mlockall: ${BOOTSTRAP_MLOCKALL:false}

discovery:
  zen:
    ping.unicast.hosts: ${DISCOVERY_SERVICE:}
    minimum_master_nodes: ${MINIMUM_MASTER_NODES:2}

{{- else if hasPrefix "2." .Values.appVersion }}
# see https://github.com/kubernetes/kubernetes/issues/3595
bootstrap.mlockall: ${BOOTSTRAP_MLOCKALL:false}

discovery:
  zen:
    ping.unicast.hosts: ${DISCOVERY_SERVICE:}
    minimum_master_nodes: ${MINIMUM_MASTER_NODES:2}
{{- else if hasPrefix "5." .Values.appVersion }}
# see https://github.com/kubernetes/kubernetes/issues/3595
bootstrap.memory_lock: ${BOOTSTRAP_MEMORY_LOCK:false}

discovery:
  zen:
    ping.unicast.hosts: ${DISCOVERY_SERVICE:}
    minimum_master_nodes: ${MINIMUM_MASTER_NODES:2}

{{- if .Values.cluster.xpackEnable }}
# see https://www.elastic.co/guide/en/x-pack/current/xpack-settings.html
xpack.ml.enabled: ${XPACK_ML_ENABLED:false}
xpack.monitoring.enabled: ${XPACK_MONITORING_ENABLED:false}
xpack.security.enabled: ${XPACK_SECURITY_ENABLED:false}
xpack.watcher.enabled: ${XPACK_WATCHER_ENABLED:false}
{{- end }}
{{- else if hasPrefix "6." .Values.appVersion }}
# see https://github.com/kubernetes/kubernetes/issues/3595
bootstrap.memory_lock: ${BOOTSTRAP_MEMORY_LOCK:false}

discovery:
  zen:
    ping.unicast.hosts: ${DISCOVERY_SERVICE:}
    minimum_master_nodes: ${MINIMUM_MASTER_NODES:2}

{{- if .Values.cluster.xpackEnable }}
# see https://www.elastic.co/guide/en/x-pack/current/xpack-settings.html
xpack.ml.enabled: ${XPACK_ML_ENABLED:false}
xpack.monitoring.enabled: ${XPACK_MONITORING_ENABLED:false}
xpack.security.enabled: ${XPACK_SECURITY_ENABLED:false}
xpack.watcher.enabled: ${XPACK_WATCHER_ENABLED:false}
{{- end }}
{{- end }}

# see https://github.com/elastic/elasticsearch-definitive-guide/pull/679
processors: ${PROCESSORS:}

# avoid split-brain w/ a minimum consensus of two masters plus a data node
gateway.expected_master_nodes: ${EXPECTED_MASTER_NODES:2}
gateway.expected_data_nodes: ${EXPECTED_DATA_NODES:1}
gateway.recover_after_time: ${RECOVER_AFTER_TIME:5m}
gateway.recover_after_master_nodes: ${RECOVER_AFTER_MASTER_NODES:2}
gateway.recover_after_data_nodes: ${RECOVER_AFTER_DATA_NODES:1}
{{- if .Values.cluster.config }}
{{ toYaml .Values.cluster.config . }}
{{- end }}


# indices configuration
{{- if .Values.index }}
index:
{{ toYaml .Values.index | indent 2 }}
{{- end }}

# additional plugins
{{ if .Values.plugins }}
plugin.mandatory: {{ $.Value.plugins | join ", " }}
{{ end }}

# slowlog logging
{{- if .Values.cluster.slowlogEnable }}
index.indexing.slowlog.threshold.index.trace: ${SLOWLOG_INDEXING_TRACE:500ms}
index.indexing.slowlog.threshold.index.debug: ${SLOWLOG_INDEXING_DEBUG:2s}
index.indexing.slowlog.threshold.index.info: ${SLOWLOG_INDEXING_INFO:5s}
index.indexing.slowlog.threshold.index.warn: ${SLOWLOG_INDEXING_WARN:10s}
index.search.slowlog.threshold.fetch.trace: ${SLOWLOG_SEARCH_FETCH_TRACE:200ms}
index.search.slowlog.threshold.fetch.debug: ${SLOWLOG_SEARCH_FETCH_DEBUG:500ms}
index.search.slowlog.threshold.fetch.info: ${SLOWLOG_SEARCH_FETCH_INFO:800ms}
index.search.slowlog.threshold.fetch.warn: ${SLOWLOG_SEARCH_FETCH_WARN:1s}
index.search.slowlog.threshold.query.trace: ${SLOWLOG_SEARCH_QUERY_TRACE:500ms}
index.search.slowlog.threshold.query.debug: ${SLOWLOG_SEARCH_QUERY_DEBUG:2s}
index.search.slowlog.threshold.query.info: ${SLOWLOG_SEARCH_QUERY_INFO:5s}
index.search.slowlog.threshold.query.warn: ${SLOWLOG_SEARCH_QUERY_WARN:10s}
{{- end }}

# gc logging
{{- if .Values.cluster.gclogEnable }}
monitor.jvm.gc.old.debug: ${GC_LOG_OLD_DEBUG:2s}
monitor.jvm.gc.old.info: ${GC_LOG_OLD_INFO:5s}
monitor.jvm.gc.old.warn: ${GC_LOG_OLD_WARN:10s}
monitor.jvm.gc.young.debug: ${GC_LOG_YOUNG_DEBUG:400ms}
monitor.jvm.gc.young.info: ${GC_LOG_YOUNG_INFO:700ms}
monitor.jvm.gc.young.warn: ${GC_LOG_YOUNG_WARN:1s}
{{- end }}

{{ end-}}