{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "signalsciences.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "signalsciences.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "signalsciences.secretAccessKeySecretName" -}}
{{- $fullName := printf "%s-secretaccesskey" (include "signalsciences.fullname" .) -}}
{{- default $fullName .Values.signalsciences.secretAccessKeyExistingSecret | quote -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "signalsciences.accessKeyIdSecretName" -}}
{{- $fullName := printf "%s-accesskeyid" (include "signalsciences.fullname" .) -}}
{{- default $fullName .Values.signalsciences.accessKeyIdExistingSecret | quote -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "signalsciences.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
