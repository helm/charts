{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "lamp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "lamp.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the domain name of the chart - used for ingress rules
*/}}
{{- define "lamp.domain" -}}
{{- if .Values.wordpress.develop.enabled -}}
{{- required "Please specify a develop domain at .Values.wordpress.develop.devDomain" .Values.wordpress.develop.devDomain | printf "%s.%s" ( include "lamp.fullname" .) -}}
{{- else -}}
{{- if not .Values.ingress.enabled -}}
no_domain_specified
{{- else -}}
{{- required "Please specify an ingress domain at .Values.ingress.domain" .Values.ingress.domain -}}
{{- end -}}
{{- end -}}
{{- end -}}
