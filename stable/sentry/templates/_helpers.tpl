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
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
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
Create a default fully qualified postgresql subchart name.
*/}}
{{- define "postgresql-fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.postgresql.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified redis subchart name.
*/}}
{{- define "redis-fullname" -}}
{{- if .Values.redis.fullnameOverride -}}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.redis.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a smtp fullname
*/}}
{{- define "smtp.fullname" -}}
{{- printf "%s-%s" .Release.Name "smtp" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate standard environment configuration.
*/}}
{{- define "sentry.standardEnv" }}
env:
- name: SENTRY_SECRET_KEY
  valueFrom:
    secretKeyRef:
    {{- if .Values.existingSecret }}
      name: {{ .Values.existingSecret }}
    {{- else }}
      name: {{ template "fullname" . }}
    {{- end }}
      key: sentry-secret
- name: SENTRY_DB_USER
  value: {{ default "sentry" .Values.postgresql.postgresqlUsername | quote }}
- name: SENTRY_DB_NAME
  value: {{ default "sentry" .Values.postgresql.postgresqlDatabase | quote }}
- name: SENTRY_DB_PASSWORD
  valueFrom:
    secretKeyRef:
    {{- if .Values.postgresql.existingSecret }}
      name: {{ .Values.postgresql.existingSecret }}
    {{- else }}
      name: {{ template "postgresql-fullname" . }}
    {{- end }}
      key: postgresql-password
- name: SENTRY_POSTGRES_HOST
  value: {{ template "postgresql-fullname" . }}
- name: SENTRY_POSTGRES_PORT
  value: "5432"
- name: SENTRY_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
    {{- if .Values.redis.existingSecret }}
      name: {{ .Values.redis.existingSecret }}
    {{- else }}
      name: {{ template "redis-fullname" . }}
    {{- end }}
      key: redis-password
- name: SENTRY_REDIS_HOST
  value: {{ template "redis-fullname" . }}-master
- name: SENTRY_REDIS_PORT
  value: {{ default "6379" .Values.redis.master.port | quote }}
- name: SENTRY_EMAIL_HOST
  value: {{ default "" .Values.smtpHost | quote }}
- name: SENTRY_EMAIL_PORT
  value: {{ default "" .Values.smtpPort | quote }}
- name: SENTRY_EMAIL_USER
  value: {{ default "" .Values.smtpUser | quote }}
- name: SENTRY_EMAIL_PASSWORD
  valueFrom:
    secretKeyRef:
    {{- if .Values.existingSecret }}
      name: {{ .Values.existingSecret }}
    {{- else }}
      name: {{ template "fullname" . }}
    {{- end }}
      key: smtp-password
      optional: true
- name: SENTRY_EMAIL_USE_TLS
  value: {{ .Values.email.use_tls | quote }}
- name: SENTRY_SERVER_EMAIL
  value: {{ .Values.email.from_address | quote }}
{{- end -}}

