{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-mysql-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-mysql-exporter.fullname" -}}
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
{{- define "prometheus-mysql-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Secret name for cloudsql credentials
*/}}
{{- define "prometheus-mysql-exporter.cloudsqlsecret" -}}
{{ template "prometheus-mysql-exporter.fullname" . }}-cloudsqlsecret
{{- end -}}

{{/*
Secret name for DATA_SOURCE_NAME
*/}}
{{- define "prometheus-mysql-exporter.secret" -}}
    {{- if .Values.mysql.existingSecret -}}
        {{- printf "%s" .Values.mysql.existingSecret -}}
    {{- else -}}
        {{ template "prometheus-mysql-exporter.fullname" . }}
    {{- end -}}
{{- end -}}