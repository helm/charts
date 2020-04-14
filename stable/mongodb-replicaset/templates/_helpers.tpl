{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb-replicaset.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb-replicaset.fullname" -}}
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
{{- define "mongodb-replicaset.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name for the admin secret.
*/}}
{{- define "mongodb-replicaset.adminSecret" -}}
    {{- if .Values.auth.existingAdminSecret -}}
        {{- .Values.auth.existingAdminSecret -}}
    {{- else -}}
        {{- template "mongodb-replicaset.fullname" . -}}-admin
    {{- end -}}
{{- end -}}

{{- define "mongodb-replicaset.metricsSecret" -}}
    {{- if .Values.auth.existingMetricsSecret -}}
        {{- .Values.auth.existingMetricsSecret -}}
    {{- else -}}
        {{- template "mongodb-replicaset.fullname" . -}}-metrics
    {{- end -}}
{{- end -}}


{{/*
Create the name for the key secret.
*/}}
{{- define "mongodb-replicaset.keySecret" -}}
    {{- if .Values.auth.existingKeySecret -}}
        {{- .Values.auth.existingKeySecret -}}
    {{- else -}}
        {{- template "mongodb-replicaset.fullname" . -}}-keyfile
    {{- end -}}
{{- end -}}

{{- define "mongodb-replicaset.connection-string" -}}
  {{- $string := "" -}}
  {{- if .Values.auth.enabled }}
   {{- $string = printf "mongodb://$METRICS_USER:$METRICS_PASSWORD@localhost:%s" (.Values.port|toString) -}}
  {{- else -}}
   {{- $string = printf "mongodb://localhost:%s" (.Values.port|toString) -}}
  {{- end -}}

  {{- if .Values.tls.enabled }}
  {{- printf "%s/?ssl=true&tlsCertificateKeyFile=/work-dir/mongo.pem&tlsCAFile=/ca/tls.crt" $string | quote -}}
  {{- else -}}
  {{- printf $string | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "mongodb-replicaset.namespace" -}}
  {{- if .Values.global -}}
    {{- if .Values.global.namespaceOverride -}}
      {{- .Values.global.namespaceOverride -}}
    {{- else -}}
      {{- .Release.Namespace -}}
    {{- end -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}    
{{- end -}}
