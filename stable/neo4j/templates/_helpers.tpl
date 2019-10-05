{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "neo4j.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "neo4j.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for core servers.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "neo4j.core.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-core" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "neo4j.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for read replica servers.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "neo4j.replica.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-replica" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for secrets.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "neo4j.secrets.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-secrets" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create connector advertised addresses environment variables
*/}}
{{- define "neo4j.connector.advertised.addresses" -}}
{{- if .Values.ingress.enabled -}}
{{- $port := empty .Values.ingress.tls | ternary "80" "443" -}}
export NEO4J_dbms_connector_bolt_advertised__address=${NEO4J_dbms_connector_bolt_advertised__address:-{{ index (index .Values.ingress.bolt.hosts 0) "name" }}:{{ $port }}}
export NEO4J_dbms_connector_http_advertised__address=${NEO4J_dbms_connector_http_advertised__address:-{{ index (index .Values.ingress.http.hosts 0) "name" }}:{{ $port }}}
export NEO4J_dbms_connector_https_advertised__address=${NEO4J_dbms_connector_https_advertised__address:-{{ index (index .Values.ingress.http.hosts 0) "name" }}:{{ $port }}}
{{- else -}}
export NEO4J_dbms_connectors_default__advertised__address=$(hostname -f)
{{- end -}}
{{- end -}}
