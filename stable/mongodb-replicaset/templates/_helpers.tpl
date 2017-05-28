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
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name for the admin secret.
*/}}
{{- define "adminSecret" -}}
    {{- if .Values.auth.existingAdminSecret -}}
        {{- .Values.auth.existingAdminSecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-admin
    {{- end -}}
{{- end -}}

{{/*
Create the name for the key secret.
*/}}
{{- define "keySecret" -}}
    {{- if .Values.auth.existingKeySecret -}}
        {{- .Values.auth.existingKeySecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-keyfile
    {{- end -}}
{{- end -}}
