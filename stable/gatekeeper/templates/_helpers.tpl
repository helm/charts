{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gatekeeper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gatekeeper.fullname" -}}
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
{{- define "gatekeeper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add Helm metadata to selector labels specifically for deployments/daemonsets/statefulsets/\s.
*/}}
{{- define "gatekeeper.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gatekeeper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gatekeeper.commonLabels" -}}
{{- include "gatekeeper.selectorLabels" . }}
helm.sh/chart: {{ include "gatekeeper.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "gatekeeper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (include "gatekeeper.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the image tag to use
*/}}
{{- define "gatekeeper.imageTag" -}}
{{- if .Values.image.tag -}}
{{ .Values.image.tag }}
{{- else -}}
v{{ .Chart.AppVersion }}
{{- end -}}
{{- end -}}
