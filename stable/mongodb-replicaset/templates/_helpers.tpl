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
  {{- printf "%s/?%s" $string (include "mongodb-replicaset.client-tls-flags-uri-options" .) | quote -}}
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


{{/*
Common tls flags
*/}}
{{- define "mongodb-replicaset.tls-flags" -}}
{{- $prefix := ternary "ssl" "tls" (semverCompare "<4.2.0" (toString .Values.image.tag)) -}}

{{- /*
This is always needed
*/ -}}
--{{ $prefix }}CAFile=/data/configdb/tls.crt

{{- if eq $prefix "ssl" }} --sslPEMKeyFile=/work-dir/mongo.pem
{{- else }} --tlsCertificateKeyFile=/work-dir/mongo.pem
{{- end }}

{{- end -}}


{{/*
Server-specific flags
*/}}

{{- define "mongodb-replicaset.server-tls-flags" -}}
{{- $prefix := ternary "ssl" "tls" (semverCompare "<4.2.0" (toString .Values.image.tag)) }}

{{- if .Values.tls.enabled -}}
--{{ $prefix }}Mode={{ .Values.tls.mode }}{{ ternary "" ($prefix | upper) (eq .Values.tls.mode "disabled") }}
{{- if .Values.tls.allowConnectionsWithoutCertificates }} --{{ $prefix }}AllowConnectionsWithoutCertificates
{{- end -}}

{{/* Include common flags */}}
{{- cat " " (include "mongodb-replicaset.tls-flags" .) }}

{{- end }}

{{- end -}}


{{/*
Client-specific flags
*/}}
{{- define "mongodb-replicaset.client-tls-flags" -}}
{{- $prefix := ternary "ssl" "tls" (semverCompare "<4.2.0" (toString .Values.image.tag)) }}

{{- if .Values.tls.enabled -}}
--{{ $prefix }}
{{- cat " " (include "mongodb-replicaset.tls-flags" .) }}
{{- end }}

{{- end -}}


{{/*
Server-specific flags as yaml list
*/}}
{{- define "mongodb-replicaset.server-tls-flags-list" }}
{{ regexSplit " +" (include "mongodb-replicaset.server-tls-flags" .) -1 | toYaml | trim }}
{{- end -}}


{{/*
Client-specific flags as yaml list
*/}}
{{- define "mongodb-replicaset.client-tls-flags-list" }}
{{ regexSplit " +" (include "mongodb-replicaset.client-tls-flags" .) -1 | toYaml | trim }}
{{- end -}}


{{/*
Client-specific flags as connection URI options
*/}}
{{- define "mongodb-replicaset.client-tls-flags-uri-options" }}
{{- regexReplaceAll "(tls|ssl)&" (regexSplit " +" (include "mongodb-replicaset.client-tls-flags" . | replace "--" "") -1 | join "&" | trim) "${1}=true&" }}
{{- end -}}
