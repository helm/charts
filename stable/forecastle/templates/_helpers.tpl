{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "forecastle.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "forecastle.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "forecastle.labels.selector" -}}
app: {{ template "forecastle.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "forecastle.labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.forecastle.serviceAccount.create -}}
    {{ default (include "forecastle.fullname" .) .Values.forecastle.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.forecastle.serviceAccount.name }}
{{- end -}}
{{- end -}}