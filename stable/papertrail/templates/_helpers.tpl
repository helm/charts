{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "papertrail.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "papertrail.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "papertrail.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the papertrail host
*/}}
{{- define "papertrail.host" -}}
{{- default "MISSING" .Values.papertrail.host }}
{{- end -}}

{{/*
Return the papertrail port
*/}}
{{- define "papertrail.port" -}}
{{- default "MISSING" .Values.papertrail.host }}
{{- end -}}

{{/*
Return a formatted logspout name.
*/}}
{{- define "papertrail.logspout.endpoint" -}}
{{- printf "syslog+tls://%s:%s" (include "papertrail.host" .) (include "papertrail.port" .) | b64enc | quote }}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "papertrail.logspout.secretName" -}}
{{- $fullName := printf "%s-syslog" (include "papertrail.fullname" .) -}}
{{- default $fullName .Values.papertrail.logspout.syslogSecretName | quote -}}
{{- end -}}