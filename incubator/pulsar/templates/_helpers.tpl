{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pulsar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pulsar.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pulsar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create list of zookeeper servers based off replica count
*/}}
{{- define "pulsar.zkServersService" -}}
    {{- $prefix := printf "%s-zk" ( include "pulsar.name" . ) -}}
    {{- $service := printf "%s-zookeeper" ( include "pulsar.name" . ) -}}

    {{- $zk := dict "servers" (list) -}}
    {{- range $i, $e := until ( int .Values.zookeeper.replicas ) -}}
        {{- $noop := printf "%s-%d.%s" $prefix $i $service | append $zk.servers | set $zk "servers" -}}
    {{- end -}}
    {{- join "," $zk.servers -}}
{{- end -}}

{{/*
Create list of zookeeper servers based off replica count
*/}}
{{- define "pulsar.zkServersNoService" -}}
    {{- $prefix := printf "%s-zk" ( include "pulsar.name" . ) -}}

    {{- $zk := dict "servers" (list) -}}
    {{- range $i, $e := until ( int .Values.zookeeper.replicas ) -}}
        {{- $noop := printf "%s-%d" $prefix $i | append $zk.servers | set $zk "servers" -}}
    {{- end -}}
    {{- join "," $zk.servers -}}
{{- end -}}
