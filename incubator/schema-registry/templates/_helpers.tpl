{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "schema-registry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "schema-registry.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "kafka-zookeeper.url" }}
{{- $port := .Values.kafka.zookeeperPort | toString }}
{{- if .Values.kafka.enabled -}}
{{- printf "%s-zookeeper:%s" .Release.Name $port }}
{{- else -}}
{{- printf "%s:%s" .Values.kafka.zookeeperUrl $port }}
{{- end -}}
{{- end -}}
