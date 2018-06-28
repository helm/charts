{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "clickhouse.name" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a proper ingress name.
*/}}
{{- define "clickhouse.ingress_host" -}}
{{- printf "%s.%s" .Release.Name .Values.ingress.host_postfix -}}
{{- end -}}
