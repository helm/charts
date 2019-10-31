{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mssql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mssql.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the SA password secret.
*/}}
{{- define "mssql.secret" -}}
{{- if .Values.existingSecret -}}
  {{- .Values.existingSecret -}}
{{- else -}}
  {{- include "mssql.fullname" . -}}-secret
{{- end -}}
{{- end -}}

{{/*
Create the name for the SA password secret key.
*/}}
{{- define "mssql.passwordKey" -}}
{{- if .Values.existingSecret -}}
  {{- .Values.existingSecretKey -}}
{{- else -}}
  sapassword
{{- end -}}
{{- end -}}


{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}
