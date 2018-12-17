{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitwebhookproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gitwebhookproxy.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gitwebhookproxy.labels.selector" -}}
app: {{ template "gitwebhookproxy.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "gitwebhookproxy.labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
{{- end -}}
