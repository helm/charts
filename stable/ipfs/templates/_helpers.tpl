{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ipfs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ipfs.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a name for the service to use.

We allow overrides for name of service, since this service provides an API that could be directly
called by end-users. For example, you could call it 'ipfs' and then all users running in a namespace
could just connect to it by specifying 'ipfs'.
*/}}
{{- define "ipfs.servicename" -}}
{{- if .Values.service.nameOverride -}}
{{- .Values.service.nameOverride -}}
{{- else -}}
{{- template "ipfs.fullname" . }}
{{- end -}}
{{- end -}}
