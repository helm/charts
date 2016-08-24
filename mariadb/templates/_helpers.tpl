{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{/*
Get the imagePullPolicy.
*/}}
{{- define "imagePullPolicy" -}}
  {{- if .Values.imagePullPolicy -}}
    {{- .Values.imagePullPolicy -}}
  {{- else -}}
    {{- if eq .Values.imageTag "latest" -}}
      {{- "Always" -}}
    {{- else -}}
      {{- "IfNotPresent" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Get the data volumeType.
*/}}
{{- define "volumeType" -}}
  {{- if .Values.dataVolume -}}
    {{- printf "%s:" .Values.dataVolume.type -}}
  {{- else -}}
    {{- "emptyDir: {}" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the data volumeIdentifier.
*/}}
{{- define "volumeIdentifier" -}}
  {{- if .Values.dataVolume -}}
    {{- printf "pdName: %s" .Values.dataVolume.id -}}
  {{- else -}}
    {{- "" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the data volumeFsType.
*/}}
{{- define "volumeFsType" -}}
  {{- if .Values.dataVolume -}}
    {{- printf "fsType: %s" .Values.dataVolume.fsType -}}
  {{- else -}}
    {{- "" -}}
  {{- end -}}
{{- end -}}
