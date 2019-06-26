{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka-connect.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka-connect.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka-connect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kafka-connect.labels" -}}
app.kubernetes.io/name: {{ include "kafka-connect.name" . }}
helm.sh/chart: {{ include "kafka-connect.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Default GroupId to Release Name but allow it to be overridden
*/}}
{{- define "kafka-connect.groupId" -}}
{{- if .Values.overrideGroupId -}}
{{- .Values.overrideGroupId -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "kafka-connect.kafka.bootstrapServers" -}}
{{- if .Values.kafka.overrideBootstrapServers -}}
{{- .Values.kafka.overrideBootstrapServers -}}
{{- else -}}
{{- printf "PLAINTEXT://%s-kafka-headless:9092" .Release.Name }}
{{- end -}}
{{- end -}}

{{/*
Form the Kafka Schema Registry URL. If Schema Registry is installed as part of this chart, use k8s
service discovery, else use user-provided URL
*/}}
{{- define "kafka-connect.schemaRegistryUrl" -}}
{{- if .Values.schemaRegistry.overrideURL -}}
{{- .Values.schemaRegistry.overrideURL -}}
{{- else -}}
{{- printf "http://%s:8081" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Form the Kafka Connect Config Storage Topic Name
*/}}
{{- define "kafka-connect.configStorageTopic" -}}
{{- if .Values.configStorageNameOverride -}}
{{- .Values.configStorageNameOverride -}}
{{- else -}}
{{- printf "connect-%s-config" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Form the Kafka Connect Offset Storage Topic Name
*/}}
{{- define "kafka-connect.offsetStorageTopic" -}}
{{- if .Values.offsetStorageNameOverride -}}
{{- .Values.offsetStorageNameOverride -}}
{{- else -}}
{{- printf "connect-%s-offset" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Form the Kafka Connect Status Storage Topic Name
*/}}
{{- define "kafka-connect.statusStorageTopic" -}}
{{- if .Values.statusStorageNameOverride -}}
{{- .Values.statusStorageNameOverride -}}
{{- else -}}
{{- printf "connect-%s-status" .Release.Name -}}
{{- end -}}
{{- end -}}
