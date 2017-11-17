{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gcloud-sqlproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gcloud-sqlproxy.fullname" -}}
{{- $name := .Values.nameOverride | default (printf "%s-%s" .Release.Name .Release.Name) -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
