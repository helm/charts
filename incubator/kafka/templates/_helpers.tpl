{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafka.zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Form the Zookeeper URL. If zookeeper is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "zookeeper.url" }}
{{- $port := .Values.zookeeper.port | toString }}
{{- if .Values.zookeeper.enabled -}}
{{- printf "%s:%s" (include "kafka.zookeeper.fullname" .) $port }}
{{- else -}}
{{- $zookeeperConnect := printf "%s:%s" .Values.zookeeper.url $port }}
{{- $zookeeperConnectOverride := index .Values "configurationOverrides" "zookeeper.connect" }}
{{- default $zookeeperConnect $zookeeperConnectOverride }}
{{- end -}}
{{- end -}}

{{/*
Derive offsets.topic.replication.factor in following priority order: configurationOverrides, replicas
*/}}
{{- define "kafka.replication.factor" }}
{{- $replicationFactorOverride := index .Values "configurationOverrides" "offsets.topic.replication.factor" }}
{{- default .Values.replicas $replicationFactorOverride }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels for kafka components
*/}}

{{- define "kafka.common.matchLabels" -}}
app.kubernetes.io/name: {{ include "kafka.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "kafka.common.metaLabels" -}}
helm.sh/chart: {{ include "kafka.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "kafka.broker.matchLabels" -}}
app.kubernetes.io/component: kafka-broker
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.broker.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.broker.matchLabels" . }}
{{- end -}}

{{- define "kafka.config.matchLabels" -}}
app.kubernetes.io/component: kafka-config
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.config.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.config.matchLabels" . }}
{{- end -}}

{{- define "kafka.monitor.matchLabels" -}}
app.kubernetes.io/component: kafka-monitor
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.monitor.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.monitor.matchLabels" . }}
{{- end -}}

{{- define "serviceMonitor.namespace" -}}
{{- if .Values.prometheus.operator.serviceMonitor.releaseNamespace -}}
{{ .Release.Namespace }}
{{- else -}}
{{ .Values.prometheus.operator.serviceMonitor.namespace }}
{{- end -}}
{{- end -}}

{{- define "prometheusRule.namespace" -}}
{{- if .Values.prometheus.operator.prometheusRule.releaseNamespace -}}
{{ .Release.Namespace }}
{{- else -}}
{{ .Values.prometheus.operator.prometheusRule.namespace }}
{{- end -}}
{{- end -}}
