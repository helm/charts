{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "chowkidar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "chowkidar.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "chowkidar.labels.selector" -}}
app: {{ template "chowkidar.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "chowkidar.labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.chowkidar.serviceAccount.create -}}
    {{ default (include "chowkidar.fullname" .) .Values.chowkidar.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.chowkidar.serviceAccount.name }}
{{- end -}}
{{- end -}}