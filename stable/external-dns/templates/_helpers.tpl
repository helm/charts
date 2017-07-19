{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "external-dns.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "external-dns.labels" }}
app: {{ .Chart.Name }}
heritage: {{.Release.Service | quote }}
release: {{.Release.Name | quote }}
{{- end }}

{{- define "external-dns.sa-name" }}
{{- $saName := default "external-dns-sa" .Values.saNameOverride -}}
{{- printf "%s-%s" .Release.Name $saName -}}
{{- end }}
