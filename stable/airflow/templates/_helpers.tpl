{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
    {{ default (include "airflow.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name or use the `postgresHost` value if defined.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.postgresql.fullname" -}}
{{- if .Values.postgresql.postgresHost }}
    {{- .Values.postgresql.postgresHost -}}
{{- else }}
    {{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified redis cluster name or use the `redisHost` value if defined
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow.redis.fullname" -}}
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
Create the name for the airflow secret.
*/}}
{{- define "airflow.secret" -}}
    {{- if .Values.existingAirflowSecret -}}
        {{- .Values.existingAirflowSecret -}}
    {{- else -}}
        {{ template "airflow.fullname" . }}
    {{- end -}}
{{- end -}}

{{/*
Map environment vars to secrets
*/}}
{{- define "airflow.mapenvsecrets" -}}
    {{- $secretName := printf "%s-env" (include "airflow.fullname" .) }}
    {{- $mapping := .Values.airflow.defaultSecretsMapping }}
    {{- if .Values.existingAirflowSecret }}
      {{- $secretName := .Values.existingAirflowSecret }}
      {{- if .Values.airflow.secretsMapping }}
        {{- $mapping := .Values.airflow.secretsMapping }}
      {{- end }}
    {{- end }}
    {{- range $val := $mapping }}
      {{- if $val }}
  - name: {{ $val.envVar }}
    valueFrom:
      secretKeyRef:
        {{- if $val.secretName }}
        name: {{ $val.secretName }}
        {{- else }}
        name: {{ $secretName }}
        {{- end }}
        key: {{ $val.secretKey }}
      {{- end }}
    {{- end }}
{{- end }}
