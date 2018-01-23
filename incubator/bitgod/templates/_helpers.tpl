{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bitgod.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expands image name.
*/}}
{{- define "bitgod.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end -}}

{{/*
Expands bitgod service name
*/}}
{{- define "bitgod.service" -}}
{{ .Release.Name }}-bitgod
{{- end -}}

{{/*
Expands environment variables
*/}}
{{- define "bitgod.env" -}}
- name: PORT
  value: {{ .Values.service.port | quote }}
{{- end -}}

{{/*
Expands configuration file for bitcoind
*/}}
{{- define "bitgod.config.bitcoind" -}}
{{ template "bitgod.fullname" . }}-bitcoind-config
{{- end -}}

{{/*
Expands configuration file for bitgod
*/}}
{{- define "bitgod.config.bitgod" -}}
{{- template "bitgod.fullname" . }}-bitgod-config
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "bitgod.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Credit: @technosophos
https://github.com/technosophos/common-chart/
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/}}
{{- define "bitgod.labels.standard" -}}
app: {{ template "bitgod.name" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: {{ template "bitgod.chartref" . }}
{{- end -}}

{{/*
Credit: @technosophos
https://github.com/technosophos/common-chart/
chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
Example output:
  zookeeper-1.2.3
  wordpress-3.2.1_20170219
*/}}
{{- define "bitgod.chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}S