{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "synapse.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "synapse.fullname" -}}
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
Throw this in here because we can't call templates from subcharts.
*/}}
{{- define "postgresql.fullname" -}} 
  {{- $values := default .Values .Values.postgresql -}}
  {{- if $values.fullnameOverride -}} 
    {{- printf $values.fullnameOverride | trunc 56 | trimSuffix "-" -}} 
  {{- else -}} 
    {{- $name := default .Chart.Name $values.nameOverride -}} 
    {{- printf "%s-%s" .Release.Name $name | trunc 56 | trimSuffix "-" -}} 
  {{- end -}} 
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "synapse.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate chart secret name
*/}}
{{- define "synapse.secretName" -}}
  {{- default (include "synapse.fullname" .) .Values.secret.nameOverride -}}
{{- end -}}

{{/*
Generate all the labels for chart-deployed resources
*/}}
{{- define "synapse.labels" -}}
app.kubernetes.io/name: {{ template "synapse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ template "synapse.chart" . }}
{{- if .Values.extraLabels -}}
{{- toYaml .Values.extraLabels -}}
{{- end -}}
{{- end -}}

