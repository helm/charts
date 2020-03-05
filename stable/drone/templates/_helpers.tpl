{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{ define "drone.name" }}{{ default "drone" .Values.nameOverride | trunc 63 }}{{ end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{ define "drone.fullname" }}
{{- $name := default "drone" .Values.nameOverride -}}
{{ printf "%s-%s" .Release.Name $name | trunc 63 -}}
{{ end }}

{{/*
Allow overwrite of rpc server.
*/}}
{{ define "drone.rpcServer" }}
{{- if .Values.agent.rpcServerOverride -}}
  {{ .Values.agent.rpcServerOverride }}
{{- else -}}
  {{ printf "http://%s" (include "drone.fullname" .) }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "drone.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "drone.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the secret for source control
*/}}
{{- define "drone.sourceControlSecret" -}}
{{- if .Values.sourceControl.secret -}}
    {{ printf "%s" .Values.sourceControl.secret }}
{{- else -}}
    {{ printf "%s-%s" (include "drone.fullname" .) "source-control" | trunc 63 -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for kubernetes pipelines
*/}}
{{- define "drone.pipelineServiceAccount" -}}
{{- if .Values.serviceAccount.create -}}
  {{- $psa := printf "%s-%s" (include "drone.serviceAccountName" .) "pipeline" | trunc 63 -}}
  {{ default $psa .Values.server.kubernetes.pipelineServiceAccount }}
{{- else -}}
  {{ default "default" .Values.server.kubernetes.pipelineServiceAccount }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the secret for an enterprise license key
*/}}
{{- define "drone.licenseKeySecret" -}}
{{- if .Values.licenseKeySecret -}}
  {{ printf "%s" .Values.licenseKeySecret }}
{{- else -}}
  {{ printf "%s-%s" (include "drone.fullname" .) "license-key" | trunc 63 }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "drone.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}
