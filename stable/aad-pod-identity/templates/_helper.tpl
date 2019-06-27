{{/* vim: set filetype=mustache: */}}
{{/*Expand the name of the chart. This is suffixed with -mic or -nmi, which means subtract 4 from longest 63 available*/}}
{{- define "aad-pod-identity.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 59 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "aad-pod-identity.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 59 | trimSuffix "-" -}}
{{- end -}}

{{- define "aad-pod-identity.mic.fullname" -}}
{{- printf "%s-mic" (include "aad-pod-identity.fullname" .) -}}
{{- end }}

{{- define "aad-pod-identity.nmi.fullname" -}}
{{- printf "%s-nmi" (include "aad-pod-identity.fullname" .) -}}
{{- end }}

{{- define "aad-pod-identity.mic.serviceaccountname" -}}
{{- printf "%s-mic" (include "aad-pod-identity.fullname" .) -}}
{{- end -}}

{{- define "aad-pod-identity.nmi.serviceaccountname" -}}
{{- printf "%s-nmi" (include "aad-pod-identity.fullname" .) -}}
{{- end -}}

{{- define "aad-pod-identity.mic.adminsecretname" -}}
{{- printf "%s-admin-secret" (include "aad-pod-identity.fullname" .) -}}
{{- end -}}

{{- define "aad-pod-identity.azureidentity.namespace" -}}
{{- if .Values.azureIdentity.namespace -}}
{{ .Values.azureIdentity.namespace }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}

{{- define "aad-pod-identity.azureidentitybinding.namespace" -}}
{{- if .Values.azureIdentity.namespace -}}
{{ .Values.azureIdentity.namespace }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}