{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "node-problem-detector.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "node-problem-detector.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "node-problem-detector.labels" }}
app: {{ template "node-problem-detector.name" . }}
heritage: {{.Release.Service }}
release: {{.Release.Name }}
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels }}
{{- end }}
{{- end }}

{{/* Create the name of the service account to use */}}
{{- define "node-problem-detector.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "node-problem-detector.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
