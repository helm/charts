{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "airflow.fullname" .) }}
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name or use the `postgresqlHost` value if defined.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.postgresql.fullname" -}}
{{- if .Values.postgresql.postgresqlHost }}
    {{- .Values.postgresql.postgresqlHost -}}
{{- else }}
    {{- $name :=  .Values.postgresql.nameOverride | default "postgresql" -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
NOTE: This is copied from the redis sub-chart and modified slightly:
*/}}
{{- define "airflow.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride -}}
  {{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- $name := default "redis" .Values.redis.nameOverride -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified redis cluster name or use the `redisHost` value if defined
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.redis.host" -}}
{{- if .Values.redis.redisHost }}
    {{- .Values.redis.redisHost -}}
{{- else }}
  {{- $name := default "redis" .Values.redis.nameOverride -}}
  {{- printf "%s-%s-master" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a random string if the supplied key does not exist
*/}}
{{- define "airflow.defaultsecret" -}}
{{- if . -}}
{{- . | b64enc | quote -}}
{{- else -}}
{{- randAlphaNum 10 | b64enc | quote -}}
{{- end -}}
{{- end -}}

{{/*
Create a set of environment variables to be mounted in web, scheduler, and woker pods.
For the database passwords, we actually use the secretes created by the postgres and redis sub-charts.
Note that the environment variables themselves are determined by the puckel/docker-airflow image.
See script/entrypoint.sh in that repo for more info.
The key names for postgres and redis are fixed, which is consistent with the subcharts.
*/}}
{{- define "airflow.mapenvsecrets" }}
  - name: POSTGRES_USER
    value: {{ .Values.postgresql.postgresqlUsername | default "postgres" | quote }}
  {{- if or .Values.postgresql.existingSecret .Values.postgresql.enabled }}
  - name: POSTGRES_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ .Values.postgresql.existingSecret | default (include "airflow.postgresql.fullname" .) }}
        key: {{ .Values.postgresql.existingSecretKey }}
  {{- end }}
  {{- if or .Values.redis.existingSecret .Values.redis.enabled }}
  - name: REDIS_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ .Values.redis.existingSecret | default (include "airflow.redis.fullname" .) }}
        key: {{ .Values.redis.existingSecretKey }}
  {{- end }}
  {{- if .Values.airflow.extraEnv }}
{{ toYaml .Values.airflow.extraEnv | indent 2 }}
  {{- end }}
{{- end }}
