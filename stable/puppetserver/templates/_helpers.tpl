{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "puppetserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "puppetserver.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create unified labels for Puppetserver components
*/}}
{{- define "puppetserver.common.matchLabels" -}}
app: {{ template "puppetserver.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "puppetserver.common.metaLabels" -}}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "puppetserver.git_sync.labels" -}}
{{ include "puppetserver.git_sync.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.git_sync.matchLabels" -}}
component: {{ .Values.git_sync.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.hiera.labels" -}}
{{ include "puppetserver.hiera.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.hiera.matchLabels" -}}
component: {{ .Values.hiera.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.r10k.labels" -}}
{{ include "puppetserver.r10k.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.r10k.matchLabels" -}}
component: {{ .Values.r10k.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.postgres.labels" -}}
{{ include "puppetserver.postgres.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.postgres.matchLabels" -}}
component: {{ .Values.postgres.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetdb.labels" -}}
{{ include "puppetserver.puppetdb.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetdb.matchLabels" -}}
component: {{ .Values.puppetdb.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetboard.labels" -}}
{{ include "puppetserver.puppetboard.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetboard.matchLabels" -}}
component: {{ .Values.puppetboard.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver.labels" -}}
{{ include "puppetserver.puppetserver.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver.matchLabels" -}}
component: {{ .Values.puppetserver.name | quote }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}


{{/*
Create the name for the PuppetDB password secret.
*/}}
{{- define "puppetdb.secret" -}}
{{- if .Values.puppetdb.credentials.existingSecret -}}
  {{- .Values.puppetdb.credentials.existingSecret -}}
{{- else -}}
  puppetdb-secret
{{- end -}}
{{- end -}}

{{/*
Create the name for the PuppetDB password secret key.
*/}}
{{- define "puppetdb.passwordKey" -}}
{{- if .Values.puppetdb.credentials.existingSecretKey -}}
  {{- .Values.puppetdb.credentials.existingSecretKey -}}
{{- else -}}
  password
{{- end -}}
{{- end -}}

{{/*
Create the name for the PostgreSQL password secret.
*/}}
{{- define "postgres.secret" -}}
{{- if .Values.postgres.credentials.existingSecret -}}
  {{- .Values.postgres.credentials.existingSecret -}}
{{- else -}}
  postgres-secret
{{- end -}}
{{- end -}}

{{/*
Create the name for the PostgreSQL password secret key.
*/}}
{{- define "postgres.passwordKey" -}}
{{- if .Values.postgres.credentials.existingSecretKey -}}
  {{- .Values.postgres.credentials.existingSecretKey -}}
{{- else -}}
  password
{{- end -}}
{{- end -}}

{{/*
Create the name for the git-sync secret.
*/}}
{{- define "git_sync.secret" -}}
{{- if .Values.git_sync.viaSsh.credentials.existingSecret -}}
  {{- .Values.git_sync.viaSsh.credentials.existingSecret -}}
{{- else if .Values.git_sync.viaHttps.credentials.existingSecret -}}
  {{- .Values.git_sync.viaHttps.credentials.existingSecret -}}
{{- else -}}
  git-creds
{{- end -}}
{{- end -}}

{{/*
Create the name for the r10k secret.
*/}}
{{- define "r10k.secret" -}}
{{- if .Values.r10k.viaSsh.credentials.existingSecret -}}
  {{- .Values.r10k.viaSsh.credentials.existingSecret -}}
{{- else if .Values.r10k.viaHttps.credentials.existingSecret -}}
  {{- .Values.r10k.viaHttps.credentials.existingSecret -}}
{{- else -}}
  r10k-creds
{{- end -}}
{{- end -}}
