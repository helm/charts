{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "redis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redis.fullname" -}}
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
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name
*/}}
{{- define "redis.image" -}}
{{- $registryName := "docker.io" -}}
{{- if .Values.imageCredentials -}} 
{{- $registryName :=  default .Values.imageCredentials.registry $registryName -}}
{{- end -}}
{{- $tag := default .Values.imageTag "latest" -}}
{{- printf "%s/%s:%s" $registryName .Values.image $tag -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "metrics.image" -}}
{{- $registryName := "docker.io" -}}
{{- if .Values.metrics.imageCredentials -}}
{{- $registryName :=  default .Values.metrics.imageCredentials.registry $registryName -}}
{{- end -}}
{{- $tag := default .Values.metrics.imageTag "latest" -}}
{{- printf "%s/%s:%s" $registryName .Values.metrics.image $tag -}}
{{- end -}}

{{/* 
Return slave readiness probe
*/}}
{{- define "redis.slave.readinessProbe" -}}
{{- $readinessProbe := .Values.slave.readinessProbe | default .Values.readinessProbe -}}
{{- if $readinessProbe }}
{{- if $readinessProbe.enabled }}
readinessProbe:
  initialDelaySeconds: {{ $readinessProbe.initialDelaySeconds | default .Values.readinessProbe.initialDelaySeconds }}
  periodSeconds: {{ $readinessProbe.periodSeconds | default .Values.readinessProbe.periodSeconds }}
  timeoutSeconds: {{ $readinessProbe.timeoutSeconds | default .Values.readinessProbe.timeoutSeconds }}
  successThreshold: {{ $readinessProbe.successThreshold | default .Values.readinessProbe.successThreshold }}
  failureThreshold: {{ $readinessProbe.failureThreshold | default .Values.readinessProbe.failureThreshold }}
  exec:
    command:
    - redis-cli
    - ping
{{- end }}
{{- end -}}
{{- end -}}

{{/* 
Return slave liveness probe
*/}}
{{- define "redis.slave.livenessProbe" -}}
{{- $livenessProbe := .Values.slave.readinessProbe | default .Values.livenessProbe -}}
{{- if $livenessProbe }}
{{- if $livenessProbe.enabled }}
livenessProbe:
  initialDelaySeconds: {{ $livenessProbe.initialDelaySeconds | default .Values.livenessProbe.initialDelaySeconds }}
  periodSeconds: {{ $livenessProbe.periodSeconds | default .Values.livenessProbe.periodSeconds }}
  timeoutSeconds: {{ $livenessProbe.timeoutSeconds | default .Values.livenessProbe.timeoutSeconds }}
  successThreshold: {{ $livenessProbe.successThreshold | default .Values.livenessProbe.successThreshold }}
  failureThreshold: {{ $livenessProbe.failureThreshold | default .Values.livenessProbe.failureThreshold}}
  exec:
    command:
    - redis-cli
    - ping
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return slave security context
*/}}
{{- define "redis.slave.securityContext" -}}
{{- $securityContext := .Values.slave.securityContext | default .Values.securityContext -}}
{{- if $securityContext }}
{{- if $securityContext.enabled }}
securityContext:
  fsGroup: {{ $securityContext.fsGroup | default .Values.securityContext.fsGroup }}
  runAsUser: {{ $securityContext.runAsUser | default .Values.securityContext.runAsUser }}
{{- end }}
{{- end }}
{{- end -}}
{{/*
Return the pull secrets for the redis image
*/}}
{{- define "redis.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}


{{/*
Return the pull secrets for the metrics image
*/}}
{{- define "metrics.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.metrics.imageCredentials.registry (printf "%s:%s" .Values.metrics.imageCredentials.username .Values.metrics.imageCredentials.password | b64enc) | b64enc }}
{{- end }}
