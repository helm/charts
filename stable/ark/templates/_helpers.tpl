{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ark.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ark.fullname" -}}
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
{{- define "ark.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use for creating or deleting the ark server
*/}}
{{- define "ark.serverServiceAccount" -}}
{{- if .Values.serviceAccount.server.create -}}
    {{ default (printf "%s-%s" (include "ark.fullname" .) "server") .Values.serviceAccount.server.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.server.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name for the credentials secret.
*/}}
{{- define "ark.secretName" -}}
{{- if .Values.credentials.existingSecret -}}
  {{- .Values.credentials.existingSecret -}}
{{- else -}}
  {{- template "ark.fullname" . -}}
{{- end -}}
{{- end -}}
