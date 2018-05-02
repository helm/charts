{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate to 20 characters because this is used to set the node identifier in WildFly which is limited to
23 characters. This allows for a replica suffix for up to 99 replicas.
*/}}
{{- define "keycloak.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $fullname := printf "%s-%s" $name .Release.Name -}}
{{- default $fullname .Values.fullnameOverride | trunc 20 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keycloak.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name for the tls secret.
*/}}
{{- define "keycloak.tlsSecret" -}}
{{- if .Values.keycloak.ingress.tls.existingSecret -}}
  {{- .Values.keycloak.ingress.tls.existingSecret -}}
{{- else -}}
  {{- template "keycloak.fullname" . -}}-tls
{{- end -}}
{{- end -}}

{{/*
Create the name for the database secret.
*/}}
{{- define "keycloak.externalDbSecret" -}}
{{- if .Values.keycloak.persistence.existingSecret -}}
  {{- .Values.keycloak.persistence.existingSecret -}}
{{- else -}}
  {{- template "keycloak.fullname" . -}}-db
{{- end -}}
{{- end -}}

{{/*
Create the name for the password secret key.
*/}}
{{- define "keycloak.dbPasswordKey" -}}
{{- if .Values.keycloak.persistence.existingSecret -}}
  {{- .Values.keycloak.persistence.existingSecretKey -}}
{{- else -}}
  password
{{- end -}}
{{- end -}}

{{/*
Create environment variables for database configuration.
*/}}
{{- define "keycloak.externalDbConfig" -}}
- name: DB_VENDOR
  value: {{ .Values.keycloak.persistence.dbVendor | quote }}
{{- if eq .Values.keycloak.persistence.dbVendor "POSTGRES" }}
- name: POSTGRES_PORT_5432_TCP_ADDR
  value: {{ .Values.keycloak.persistence.dbHost | quote }}
- name: POSTGRES_PORT_5432_TCP_PORT
  value: {{ .Values.keycloak.persistence.dbPort | quote }}
- name: POSTGRES_USER
  value: {{ .Values.keycloak.persistence.dbUser | quote }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "keycloak.externalDbSecret" . }}
      key: {{ include "keycloak.dbPasswordKey" . | quote }}
- name: POSTGRES_DATABASE
  value: {{ .Values.keycloak.persistence.dbName | quote }}
{{- else if eq .Values.keycloak.persistence.dbVendor "MYSQL" }}
- name: MYSQL_PORT_3306_TCP_ADDR
  value: {{ .Values.keycloak.persistence.dbHost | quote }}
- name: MYSQL_PORT_3306_TCP_PORT
  value: {{ .Values.keycloak.persistence.dbPort | quote }}
- name: MYSQL_USER
  value: {{ .Values.keycloak.persistence.dbUser | quote }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "keycloak.externalDbSecret" . }}
      key: {{ include "keycloak.dbPasswordKey" . | quote }}
- name: MYSQL_DATABASE
  value: {{ .Values.keycloak.persistence.dbName | quote }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "keycloak.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create -}}
      {{ default (include "keycloak.fullname" .) .Values.serviceAccount.name }}
  {{- else -}}
      {{ default "default" .Values.serviceAccount.name }}
  {{- end -}}
{{- end -}}
