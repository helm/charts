{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cluster-autoscaler.name" -}}
{{- default (printf "%s-%s" .Values.cloudProvider .Chart.Name) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cluster-autoscaler.fullname" -}}
{{- $name := default (printf "%s-%s" .Values.cloudProvider .Chart.Name) .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
