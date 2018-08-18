{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "presto.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "presto.fullname" -}}
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

{{- define "presto.coordinator" -}}
{{ template "presto.fullname" . }}-coordinator
{{- end -}}

{{- define "presto.worker" -}}
{{ template "presto.fullname" . }}-worker
{{- end -}}

{{- define "presto.connectors" -}}
{{ template "presto.fullname" . }}-connectors
{{- end -}}

{{- define "presto.connectors.volumeMount.nameKeyVal" -}}
{{- if (eq "configMap" .Values.server.connectors.volumeMount.type) -}}
{{- if (eq "" .Values.server.connectors.volumeMount.name) -}}
name: {{ template "presto.connectors" . }}
{{- else -}}
name: {{ .Values.server.connectors.volumeMount.name }}
{{- end -}}
{{- else -}}
{{- if (eq "secret" .Values.server.connectors.volumeMount.type) -}}
secretName: {{ .Values.server.connectors.volumeMount.name }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "presto.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
