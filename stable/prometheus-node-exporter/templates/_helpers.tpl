{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-node-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-node-exporter.fullname" -}}
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

{{/* Generate basic labels */}}
{{- define "prometheus-node-exporter.labels" }}
{{- if .Values.labelsOverride}}
{{ toYaml .Values.labelsOverride }}
{{- else}}
app.kubernetes.io/name: {{ template "prometheus-node-exporter.fullname" . }}
helm.sh/chart: {{ template "prometheus-node-exporter.fullname" . }}-{{.Chart.Version  }}
app.kubernetes.io/managed-by: "Helm"
app.kubernetes.io/instance: {{ template "prometheus-node-exporter.fullname" . }}
app.kubernetes.io/version: {{.Chart.AppVersion }}
{{- end }}
{{- if .Values.podLabels}}
{{ toYaml .Values.podLabels }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prometheus-node-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "prometheus-node-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "prometheus-node-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "prometheus-node-exporter.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Define selector used to identify pods managed by this chart.
*/}}
{{- define "prometheus-node-exporter.selector" -}}
{{- if .Values.selectorOverride}}
{{ toYaml .Values.selectorOverride }}
{{- else}}
app.kubernetes.io/name: {{ template "prometheus-node-exporter.fullname" . }}
app.kubernetes.io/instance: {{ template "prometheus-node-exporter.fullname" . }}
{{- end -}}
{{- end -}}
