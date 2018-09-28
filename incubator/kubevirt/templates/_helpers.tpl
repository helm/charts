{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kubevirt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubevirt.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/ -}}
{{- define "labels.standard" -}}
app: {{ template "kubevirt.name" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- /*
selectors.standard prints the standard Helm selectors.
The standard selectors are frequently used in metadata.
*/ -}}
{{- define "selectors.standard" -}}
app: {{ template "kubevirt.name" . }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{/*
Create the name of the apiserver service account to use
*/}}
{{- define "kubevirt.serviceAccountName.apiserver" -}}
  {{- if .Values.serviceAccount.apiserver.create -}}
      {{ default (printf "%s-%s" (include "kubevirt.fullname" .) "apiserver") .Values.serviceAccount.apiserver.name }}
  {{- else -}}
      {{ default "default" .Values.serviceAccount.apiserver.name }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "kubevirt.serviceAccountName.controller" -}}
  {{- if .Values.serviceAccount.controller.create -}}
      {{ default (printf "%s-%s" (include "kubevirt.fullname" .) "controller") .Values.serviceAccount.controller.name }}
  {{- else -}}
      {{ default "default" .Values.serviceAccount.controller.name }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the privileged service account to use
*/}}
{{- define "kubevirt.serviceAccountName.privileged" -}}
  {{- if .Values.serviceAccount.privileged.create -}}
      {{ default (printf "%s-%s" (include "kubevirt.fullname" .) "privileged") .Values.serviceAccount.privileged.name }}
  {{- else -}}
      {{ default "default" .Values.serviceAccount.privileged.name }}
  {{- end -}}
{{- end -}}
