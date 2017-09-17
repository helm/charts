{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ghost.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ghost.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ghost.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "ghost.serviceIP" -}}
{{- if eq .Values.serviceType "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- index .Values (printf "%sLoadBalancerIP" .Chart.Name) | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
*/}}
{{- define "ghost.host" -}}
{{- $host := index .Values (printf "%sHost" .Chart.Name) | default "" -}}
{{- default (include "ghost.serviceIP" .) $host -}}
{{- end -}}
