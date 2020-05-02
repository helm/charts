{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "oauth2-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oauth2-proxy.fullname" -}}
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
{{- define "oauth2-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the secret name.
*/}}
{{- define "oauth2-proxy.secretName" -}}
{{- if .Values.config.existingSecret -}}
{{- printf "%s" .Values.config.existingSecret -}}
{{- else -}}
{{- printf "%s" (include "oauth2-proxy.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "oauth2-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled -}}
    {{ default (include "oauth2-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Secret name to use for clientID
*/}}
{{- define "oauth2-proxy.clientIDSecretName" -}}
{{- if .Values.config.secretConfig.clientID.secretName -}}
{{- printf "%s" .Values.config.secretConfig.clientID.secretName -}}
{{- else -}}
{{- printf "%s" (include "oauth2-proxy.fullname" . ) }}
{{- end }}
{{- end }}

{{/*
Secret name to use for clientSecret
*/}}
{{- define "oauth2-proxy.clientSecretSecretName" -}}
{{- if .Values.config.secretConfig.clientSecret.secretName -}}
{{- printf "%s" .Values.config.secretConfig.clientSecret.secretName -}}
{{- else -}}
{{- printf "%s" (include "oauth2-proxy.fullname" . ) }}
{{- end }}
{{- end }}

{{/*
Secret name to use for clientID
*/}}
{{- define "oauth2-proxy.cookieSecretSecretName" -}}
{{- if .Values.config.secretConfig.cookieSecret.secretName -}}
{{- printf "%s" .Values.config.secretConfig.cookieSecret.secretName -}}
{{- else -}}
{{- printf "%s" (include "oauth2-proxy.fullname" . ) }}
{{- end }}
{{- end }}

{{/*
Check to see if any entries in secret.
Expects an array with:
index 0 as the secret name
index 1 as .
*/}}
{{- define "oauth2-proxy.entriesInSecret" -}}
{{- $name := (index . 0) }}
{{- with (index . 1) }}
{{- if and .Values.config.secretConfig.cookieSecret.write (eq $name (include "oauth2-proxy.cookieSecretSecretName" .)) }}
t
{{- else if and .Values.config.secretConfig.clientSecret.write (eq $name (include "oauth2-proxy.clientSecretSecretName" .)) }}
t
{{- else if and .Values.config.secretConfig.clientID.write (eq $name (include "oauth2-proxy.clientIDSecretName" .)) }}
t
{{- end }}
{{- end }}
{{- end }}
