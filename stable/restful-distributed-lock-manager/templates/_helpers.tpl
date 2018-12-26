{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rdlm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rdlm.labels.selector" -}}
app: {{ template "rdlm.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- define "rdlm.labels.chart" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service | quote }}
{{- end -}}