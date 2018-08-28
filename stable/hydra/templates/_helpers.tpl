{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hydra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate to 20 characters because this is used to set the node identifier in WildFly which is limited to
23 characters. This allows for a replica suffix for up to 99 replicas.
*/}}
{{- define "hydra.fullname" -}}
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
{{- define "hydra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "hydra.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ template "postgresql.fullname" $postgresContext }}
{{- end -}}

{{/*
Create environment variable for database connection.
*/}}
{{- define "hydra.dbConnectStr" -}}
 {{- if .Values.hydra.persistence.deployPostgres -}}
  {{- if not .Values.postgresql.postgresPassword -}}
   {{- fail "ERROR: 'Please specify a .Values.postgresql.postgresPassword" -}}
  {{- else if not (eq "postgres" .Values.hydra.persistence.dbVendor) -}}
   {{- fail (printf "ERROR: 'Setting hydra.persistence.deployPostgres' to 'true' requires setting 'hydra.persistence.dbVendor' to 'postgres' (is: '%s')!" .Values.hydra.persistence.dbVendor) -}}
  {{- end -}}
postgres://{{ .Values.postgresql.postgresUser }}:{{ .Values.postgresql.postgresPassword }}@{{ template "hydra.postgresql.fullname" . }}:5432/{{ .Values.postgresql.postgresDatabase }}?sslmode=disable
 {{- else -}}
  {{- if eq .Values.hydra.persistence.dbVendor "postgres" -}}
postgres://{{ .Values.hydra.persistence.dbUser }}:{{ .Values.hydra.persistence.dbPassword }}@{{ .Values.hydra.persistence.dbHost }}:{{ .Values.hydra.persistence.dbPort }}/{{ .Values.hydra.persistence.dbName }}?sslmode=disable
  {{- else if eq .Values.hydra.persistence.dbVendor "mysql" -}}
mysql://{{ .Values.hydra.persistence.dbUser }}:{{ .Values.hydra.persistence.dbPassword }}@tcp({{ .Values.hydra.persistence.dbHost }}:{{ .Values.hydra.persistence.dbPort }}/{{ .Values.hydra.persistence.dbName }}?parseTime=true
  {{- else if eq .Values.hydra.persistence.dbVendor "memory" -}}
memory
  {{- end -}}
 {{- end -}}
{{- end -}}
