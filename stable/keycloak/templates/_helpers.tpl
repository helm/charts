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
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 20 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 20 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 20 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "keycloak.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "keycloak.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ template "postgresql.fullname" $postgresContext }}
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
{{- define "keycloak.dbEnvVars" -}}
{{- if .Values.keycloak.persistence.deployPostgres }}
{{- if not (eq "postgres" .Values.keycloak.persistence.dbVendor) }}
{{ fail (printf "ERROR: 'Setting keycloak.persistence.deployPostgres' to 'true' requires setting 'keycloak.persistence.dbVendor' to 'postgres' (is: '%s')!" .Values.keycloak.persistence.dbVendor) }}
{{- end }}
- name: DB_VENDOR
  value: postgres
- name: DB_ADDR
  value: {{ template "keycloak.postgresql.fullname" . }}
- name: DB_PORT
  value: "5432"
- name: DB_DATABASE
  value: {{ .Values.postgresql.postgresDatabase | quote }}
- name: DB_USER
  value: {{ .Values.postgresql.postgresUser | quote }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "keycloak.postgresql.fullname" . }}
      key: postgres-password
{{- else }}
- name: DB_VENDOR
  value: {{ .Values.keycloak.persistence.dbVendor | quote }}
{{- if not (eq "h2" .Values.keycloak.persistence.dbVendor) }}
- name: DB_ADDR
  value: {{ .Values.keycloak.persistence.dbHost | quote }}
- name: DB_PORT
  value: {{ .Values.keycloak.persistence.dbPort | quote }}
- name: DB_DATABASE
  value: {{ .Values.keycloak.persistence.dbName | quote }}
- name: DB_USER
  value: {{ .Values.keycloak.persistence.dbUser | quote }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "keycloak.externalDbSecret" . }}
      key: {{ include "keycloak.dbPasswordKey" . | quote }}
{{- end }}
{{- end }}
{{- end -}}
