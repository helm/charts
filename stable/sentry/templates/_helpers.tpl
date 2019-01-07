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
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
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
Create the name for the sentry secret.
*/}}
{{- define "sentry.secretSecret" -}}
    {{- if .Values.existingSentrySecret -}}
        {{- .Values.existingSentrySecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-secret
    {{- end -}}
{{- end -}}

{{/*
Create the name for the sentry email secret.
*/}}
{{- define "sentry.emailSecret" -}}
    {{- if .Values.email.existingEmailSecret -}}
        {{- .Values.email.existingEmailSecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-email
    {{- end -}}
{{- end -}}

{{/*
Create the name for the sentry user secret.
*/}}
{{- define "sentry.userSecret" -}}
    {{- if .Values.user.existingUserSecret -}}
        {{- .Values.user.existingUserSecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-user
    {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "smtp.fullname" -}}
{{- printf "%s-%s" .Release.Name "smtp" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
