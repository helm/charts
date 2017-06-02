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
Create the name for the auth secret.
*/}}
{{- define "authFileSecret" -}}
    {{- if .Values.auth.existingKeySecret -}}
        {{- .Values.auth.existingKeySecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-auth
    {{- end -}}
{{- end -}}

{{/*
Create the name for the tls secret.
*/}}
{{- define "tlsSecret" -}}
    {{- if .Values.ingress.tls.existingSecret -}}
        {{- .Values.ingress.tls.existingSecret -}}
    {{- else -}}
        {{- template "fullname" . -}}-tls
    {{- end -}}
{{- end -}}
