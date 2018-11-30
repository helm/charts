{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | b64enc -}}
{{- end -}}

{{- define "airflow.sql_alchemy_conn.secret" }}
{{- $pgname := default "postgresql" .Values.postgresql.nameOverride -}}
{{- $username := default "airflow" .Values.postgresql.postgresUser -}}
{{- $password := default "airflow" .Values.postgresql.postgresPassword -}}
{{- $db := default "airflow" .Values.postgresql.postgresDatabase -}}
{{- $postgresql_conn := printf "postgresql+psycopg2://%s:%s@%s-%s:5432/%s" $username $password .Release.Name $pgname $db -}}
{{- default $postgresql_conn .Values.sqlAlchemyConn | b64enc -}}
{{- end -}}