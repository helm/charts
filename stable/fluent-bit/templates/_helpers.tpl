{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fluent-bit.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fluent-bit.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for RBAC APIs.
*/}}
{{- define "rbac.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "v1" -}}
rbac.authorization.k8s.io/v1
{{- else if .Capabilities.APIVersions.Has "v1beta1" -}}
rbac.authorization.k8s.io/v1beta1
{{- else -}}
rbac.authorization.k8s.io/v1alpha1
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluent-bit.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "fluent-bit.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

