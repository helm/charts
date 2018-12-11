{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "reloader-name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "reloader-fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "reloader-labels.selector" -}}
app: {{ template "reloader-name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "reloader-labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.reloader.serviceAccount.create -}}
    {{ default (include "reloader-fullname" .) .Values.reloader.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.reloader.serviceAccount.name }}
{{- end -}}
{{- end -}}
