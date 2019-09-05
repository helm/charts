{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "aad-pod-identity.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 59 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars (minus 4 for suffix) because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aad-pod-identity.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 59 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 59 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 59 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "aad-pod-identity.mic.fullname" -}}
{{- printf "%s-mic" (include "aad-pod-identity.fullname" .) -}}
{{- end }}

{{- define "aad-pod-identity.nmi.fullname" -}}
{{- printf "%s-nmi" (include "aad-pod-identity.fullname" .) -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aad-pod-identity.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "aad-pod-identity.azureidentity.namespace" -}}
{{- if .Values.azureIdentity.namespace -}}
{{ .Values.azureIdentity.namespace }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}

{{- define "aad-pod-identity.azureidentitybinding.namespace" -}}
{{- if .Values.azureIdentity.namespace -}}
{{ .Values.azureIdentity.namespace }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}