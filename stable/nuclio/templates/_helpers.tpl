{{/* vim: set filetype=mustache: */}}

{{- define "nuclio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nuclio.controllerName" -}}
{{- $name := default .Chart.Name .Values.Controller.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nuclio.controllerImage" -}}
{{- printf "%s:%s-%s" .Values.Controller.Image .Values.Nuclio.Version .Values.Nuclio.Arch -}}
{{- end -}}

{{- define "nuclio.playgroundName" -}}
{{- $name := default .Chart.Name .Values.Playground.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nuclio.playgroundImage" -}}
{{- printf "%s:%s-%s" .Values.Playground.Image .Values.Nuclio.Version .Values.Nuclio.Arch -}}
{{- end -}}