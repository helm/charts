{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-operator.fullname" -}}
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
{{- define "prometheus-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
prometheus-operator.labels prints the standard prometheus-operator Helm labels.
*/ -}}
{{- define "prometheus-operator.labels.standard" -}}
app: {{ template "prometheus-operator.name" . }}
chart: {{ template "prometheus-operator.chart" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
operator: prometheus
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "prometheus-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "prometheus-operator.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/* Alertmanager labels */}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "alertmanager.chart" -}}
{{- printf "alertmanager-%s" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "alertmanager.name" -}}
{{- default "alertmanager" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "alertmanager.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "alertmanager" .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "alertmanager.labels.standard" -}}
app: {{ template "alertmanager.name" . }}
alertmanager: {{ .Release.Name }}
chart: {{ template "alertmanager.chart" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
component: alertmanager
{{- end -}}
