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
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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
Generate the Kafka connect string.
*/}}
{{- define "kafka.connect" }}
{{ template "kafka.fullname" . }}:{{ .Values.service.ports.client.port }}
{{- end -}}

{{/*
Generate the Zookeeper connect string. If zookeeper is installed as part of this chart, use k8s
service discovery, else use user-provided connect string.
*/}}
{{- define "zookeeper.connect" }}
{{- if .Values.zookeeper.connect -}}
{{- .Values.zookeeper.connect }}
{{- else -}}
{{- $zookeeperPort := .Values.zookeeper.ports.client.containerPort }}
{{- $zookeeperConnectSubchart := printf "%s:%s" ( include "kafka.zookeeper.fullname" . ) $zookeeperPort }}
{{- $zookeeperConnectOverride := index .Values "configurationOverrides" "zookeeper.connect" }}
{{- default $zookeeperConnectSubchart $zookeeperConnectOverride }}
{{- end -}}
{{- end -}}
