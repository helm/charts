{{/* vim: set filetype=mustache: */}}

{{/* Expand the name of the chart. */}}
{{- define "taiga.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create a default fully qualified app name. We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec). If release name contains chart name it will be used as a full name. */}}
{{- define "taiga.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "taiga.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define the docker image name */}}
{{- define "taiga.image" -}}
{{- if regexMatch "^@" .Values.image.tag -}}
{{ .Values.image.repository }}{{ .Values.image.tag }}
{{- else -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end -}}
{{- end -}}

{{/* Labels to attach to every auth-proxy object. */}}
{{- define "taiga.labels" -}}
app: {{ template "taiga.name" . }}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ include "taiga.chart" . }}
{{ if .Values.extraLabels -}}
{{ .Values.extraLabels | toYaml }}
{{- end -}}
{{- end -}}

{{/* Environment variables for configuring the containers */}}
{{- define "taiga.envfrom" -}}
- secretRef:
    name: {{ include "taiga.fullname" . }}
    optional: false
- configMapRef:
    name: {{ include "taiga.fullname" . }}
    optional: false
{{- end -}}
