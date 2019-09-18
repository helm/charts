{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "newrelic.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "newrelic.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Generate mode label */}}
{{- define "newrelic.mode" }}
{{- if .Values.privileged -}}
privileged
{{- else -}}
unprivileged
{{- end }}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "newrelic.labels" }}
app: {{ template "newrelic.name" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
heritage: {{.Release.Service }}
release: {{.Release.Name }}
mode: {{ template "newrelic.mode" . }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "newrelic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "newrelic.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "newrelic.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the image name depending on the "privileged" flag
*/}}
{{- define "newrelic.image" -}}
{{- if .Values.privileged -}}
"{{ .Values.image.repository }}:{{ .Values.image.tag }}"
{{- else -}}
"{{ .Values.image.repository }}:{{ .Values.image.tag }}-unprivileged"
{{- end -}}
{{- end -}}