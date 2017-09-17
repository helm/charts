{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mailhog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mailhog.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name for the auth secret.
*/}}
{{- define "mailhog.authFileSecret" -}}
    {{- if .Values.auth.existingKeySecret -}}
        {{- .Values.auth.existingKeySecret -}}
    {{- else -}}
        {{- template "mailhog.fullname" . -}}-auth
    {{- end -}}
{{- end -}}

{{/*
Create the name for the tls secret.
*/}}
{{- define "mailhog.tlsSecret" -}}
    {{- if .Values.ingress.tls.existingSecret -}}
        {{- .Values.ingress.tls.existingSecret -}}
    {{- else -}}
        {{- template "mailhog.fullname" . -}}-tls
    {{- end -}}
{{- end -}}
