{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "xposer-name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "xposer-fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "xposer-labels.selector" -}}
app: {{ template "xposer-name" . }}
group: {{ .Values.xposer.labels.group }}
provider: {{ .Values.xposer.labels.provider }}
{{- end -}}

{{- define "xposer-labels.stakater" -}}
{{ template "xposer-labels.selector" . }}
version: {{ .Values.xposer.labels.version }}
{{- end -}}

{{- define "xposer-labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
release: {{ .Release.Name | quote }}
heritage: {{ .Release.Service | quote }}
{{- end -}}