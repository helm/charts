{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jamadar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "jamadar.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "jamadar.labels.selector" -}}
app: {{ template "jamadar.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "jamadar.labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.jamadar.serviceAccount.create -}}
    {{ default (include "jamadar.fullname" .) .Values.jamadar.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.jamadar.serviceAccount.name }}
{{- end -}}
{{- end -}}