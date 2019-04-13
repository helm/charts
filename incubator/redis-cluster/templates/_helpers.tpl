{{/*
Expand the name of the chart.
*/}}
{{- define "redis-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis-cluster.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Redis image name
*/}}
{{- define "redis.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Generate redis pod name suffix
*/}}
{{- define "redis-cluster.podHost" -}}
{{- $clusterFullname := include "redis-cluster.fullname" . -}}
{{- $namespace := printf "%s" .Release.Namespace -}}
{{- $port := .Values.service.clientPort | toString -}}
{{- printf "%s-headless.%s.svc.cluster.local:%s" $clusterFullname $namespace $port -}}
{{- end -}}