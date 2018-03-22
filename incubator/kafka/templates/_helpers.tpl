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
*/}}
{{- define "kafka.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafka.zookeeper.fullname" -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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
