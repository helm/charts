{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 24 -}}
{{- end -}}

{{- define "toYaml" -}}
  {{- range $key, $value := . -}}
    {{- $map := kindIs "map" $value -}}
    {{- if $map }}
{{ $key }}:
  {{- include "toYaml" $value | indent 2 }}
    {{- else }}
{{ $key }}: {{ $value }}
    {{- end }}
  {{- end -}}
{{- end -}}
