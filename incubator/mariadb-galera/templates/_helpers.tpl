{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 61 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 61 -}}
{{- end -}}

{{/*
Create a default fully qualified service name.
We truncate at 61 chars because some Kubernetes name fields are limited to 63
chars (by RFC 1035, see https://github.com/kubernetes/kubernetes/pull/29523)
and the pods in the StatefulSet append a dash and a digit (e.g. -0). We also
replace "." with "-" do avoid issues with invalid DNS names.
*/}}
{{- define "servicename" -}}
{{- $name := default "mdb-ga" .Values.servicenameOverride -}}
{{- printf "%s-%s" .Release.Name $name | replace "." "-" | lower | trunc 61 -}}
{{- end -}}
