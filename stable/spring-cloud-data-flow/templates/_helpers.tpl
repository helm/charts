{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scdf.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default short app name to use for resource naming.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "scdf.fullname" -}}
{{- $name := default "data-flow" .Values.appNameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create an uppercase app name to use for environment variables.
*/}}
{{- define "scdf.envname" -}}
{{- $name := default "data-flow" .Values.appNameOverride -}}
{{- printf "%s_%s" .Release.Name $name | upper | replace "-" "_" | trimSuffix "_" -}}
{{- end -}}

{{/*
Create an uppercase release prefix to use for environment variables.
*/}}
{{- define "scdf.envrelease" -}}
{{- printf "%s" .Release.Name | upper | replace "-" "_" | trimSuffix "_" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "scdf.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "scdf.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
