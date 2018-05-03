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
*/}}
{{- define "prometheus-mysql-exporter.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Secret name for cloudsql credentials
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prometheus-mysql-exporter.cloudsqlsecret" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-cloudsqlsecret" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


