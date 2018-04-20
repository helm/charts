{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mongodb.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper image name
*/}}
{{- define "mongodb.image" -}}
{{- $registryName :=  default .Values.image.registry "docker.io" -}}
{{- $tag := .Values.image.tag | default "latest" -}}
{{- printf "%s/%s:%s" $registryName .Values.image.repository $tag -}}
{{- end -}}
