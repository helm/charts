{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "kong.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.cassandra.fullname" -}}
{{- $name := default "cassandra" .Values.cassandra.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kong.serviceAccountName" -}}
{{- if .Values.ingressController.serviceAccount.create -}}
    {{ default (include "kong.fullname" .) .Values.ingressController.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the KONG_PROXY_LISTEN value string
*/}}
{{- define "kong.kongProxyListenValue" -}}

{{- if and .Values.proxy.http.enabled .Values.proxy.tls.enabled -}}
   0.0.0.0:{{ .Values.proxy.http.containerPort }},0.0.0.0:{{ .Values.proxy.tls.containerPort }} ssl
{{- else -}}
{{- if .Values.proxy.http.enabled -}}
   0.0.0.0:{{ .Values.proxy.http.containerPort }}
{{- end -}}
{{- if .Values.proxy.tls.enabled -}}
   0.0.0.0:{{ .Values.proxy.tls.containerPort }} ssl
{{- end -}}
{{- end -}}

{{- end }}

{{/*
Create the ingress servicePort value string
*/}}
{{- define "kong.ingress.servicePort" -}}
{{- if .Values.proxy.tls.enabled -}}
   {{ .Values.proxy.tls.servicePort }}
{{- else -}}
   {{ .Values.proxy.http.servicePort }}
{{- end -}}
{{- end -}}


{{/*
Create dbHost
This can be used to simplify certain aspects of the chart which
normally have to choose between Postgres values and Cassandra values.
For instance, in the initContainers command.
*/}}
{{- define "kong.dbHost" -}}
{{- if .Values.cassandra.enabled -}}
    {{ template "kong.cassandra.fullname" . }}
{{- else if .Values.postgresql.enabled -}}
    {{ template "kong.postgresql.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Create dbPort
This can be used to simplify certain aspects of the chart which
normally have to choose between Postgres values and Cassandra values.
For instance, in the initContainers command.
*/}}
{{- define "kong.dbPort" -}}
{{- if .Values.cassandra.enabled -}}
    {{ .Values.cassandra.config.ports.cql }}
{{- else if .Values.postgresql.enabled -}}
    {{ .Values.postgresql.service.port }}
{{- end -}}
{{- end -}}
