{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "atlantis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "atlantis.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "atlantis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "atlantis.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "atlantis.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Defines the scheme (http or https) of the Atlantis service
*/}}
{{- define "atlantis.url.scheme" -}}
{{- if .Values.tlsSecretName -}}
https
{{- else -}}
http
{{- end -}}
{{- end -}}

{{/*
Defines the internal kubernetes address to Atlantis
*/}}
{{- define "atlantis.url" -}}
{{ template "atlantis.url.scheme" . }}://{{ template "atlantis.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.service.port }}
{{- end -}}

{{/*
Generates secret-webhook name
*/}}
{{- define "atlantis.vcsSecretsName" -}}
{{- if .Values.vcsSecretsName -}}
    {{ .Values.vcsSecretsName }}
{{- else -}}
    {{ template "atlantis.fullname" . }}-webhook
{{- end -}}
{{- end -}}

{{/*
Generates AWS Secret name
*/}}
{{- define "atlantis.awsSecretName" -}}
{{- if .Values.awsSecretName -}}
    {{ .Values.awsSecretName }}
{{- else -}}
    {{ template "atlantis.fullname" . }}-aws
{{- end -}}
{{- end -}}
