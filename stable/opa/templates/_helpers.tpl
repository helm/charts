{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "opa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opa.fullname" -}}
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

{{- define "opa.sarfullname" -}}
{{- $name := (include "opa.fullname" . | trunc 59 | trimSuffix "-") -}}
{{- printf "%s-sar" $name -}}
{{- end -}}

{{- define "opa.mgmtfullname" -}}
{{- $name := (include "opa.fullname" . | trunc 58 | trimSuffix "-") -}}
{{- printf "%s-mgmt" $name -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "opa.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define standard labels for frequently used metadata.
*/}}
{{- define "opa.labels.standard" -}}
app: {{ template "opa.fullname" . }}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
release: "{{ .Release.Name }}"
heritage: "{{ .Release.Service }}"
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "opa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "opa.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "opa.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "opa.fullname" .) }}
{{- end -}}

{{- define "opa.rootCAIssuer" -}}
{{ printf "%s-ca" (include "opa.fullname" .) }}
{{- end -}}

{{- define "opa.rootCACertificate" -}}
{{ printf "%s-ca" (include "opa.fullname" .) }}
{{- end -}}

{{- define "opa.servingCertificate" -}}
{{ printf "%s-webhook-tls" (include "opa.fullname" .) }}
{{- end -}}
