{{/* vim: set filetype=mustache: */}}

{{- define "controllerName" -}}
{{- $name := default .Chart.Name .Values.Controller.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "controllerImage" -}}
{{- printf "%s/%s-%s" .Values.Controller.Image .Values.Nuclio.Version .Values.Nuclio.Arch -}}
{{- end -}}

{{- define "playgroundName" -}}
{{- $name := default .Chart.Name .Values.Playground.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "playgroundImage" -}}
{{- printf "%s/%s-%s" .Values.Playground.Image .Values.Nuclio.Version .Values.Nuclio.Arch -}}
{{- end -}}