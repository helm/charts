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
*/}}
{{- define "kafka-connect.fullName" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the full hostname, a combination of release name and domain name
*/}}
{{- define "kafka-connect.hostName" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s.%s" .Release.Name .Values.global.domain -}}
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

