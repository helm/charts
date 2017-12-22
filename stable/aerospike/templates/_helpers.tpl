{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "aerospike.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "aerospike.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create aerospike mesh setup
*/}}
{{- define "aerospike.mesh" -}}
    {{- $fullname := include "aerospike.fullname" . -}}
    {{- range $i, $e := until (.Values.replicaCount|int) }}
    {{ printf "mesh-seed-address-port %s-%d.%s-mesh 3002" $fullname $i $fullname }}
    {{- end -}}
{{- end -}}
