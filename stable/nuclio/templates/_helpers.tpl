{{/* vim: set filetype=mustache: */}}

{{- define "nuclio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nuclio.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nuclio.controller.image" -}}
{{- printf "%s:%s-%s" .Values.controller.image .Values.nuclio.version .Values.nuclio.arch -}}
{{- end -}}

{{- define "nuclio.playground.image" -}}
{{- printf "%s:%s-%s" .Values.Playground.image .Values.nuclio.version .Values.nuclio.arch -}}
{{- end -}}