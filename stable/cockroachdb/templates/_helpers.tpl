{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "cockroachdb.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <=1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cockroachdb.serviceAccountName" -}}
{{- if .Values.Secure.ServiceAccount.Create -}}
    {{ default (printf "%s-%s" .Release.Name .Values.Name | trunc 56) .Values.Secure.ServiceAccount.Name }}
{{- else -}}
    {{ default "default" .Values.Secure.ServiceAccount.Name }}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
Max length of 63 chars, but trimmed down to 56 chars so adding -public will still only be 63 total.
*/}}
{{- define "cockroachdb.fullName" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 56 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.Name | trunc 56 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified public app name.

Max length of 63 chars, but trimmed down to 56 chars by previous function,
so adding -public will still only be 63 total.
*/}}
{{- define "cockroachdb.fullNamePublic" -}}
{{- print (include "cockroachdb.fullName" .) "-public" -}}
{{- end -}}


{{/*
Default metadata
*/}}
{{- define "cockroachdb.heritageName" -}}{{- .Release.Service | quote -}}{{- end -}}
{{- define "cockroachdb.releaseName" -}}{{- .Release.Name | quote -}}{{- end -}}
{{- define "cockroachdb.chartName" -}}{{- print .Chart.Name "-" .Chart.Version | quote -}}{{- end -}}
{{- define "cockroachdb.componentName" -}}{{- print .Release.Name "-" .Values.Component | quote -}}{{- end -}}

{{- define "cockroachdb.statefulsetFqdn" -}}
{{- print (include "cockroachdb.fullName" .) "." .Release.Namespace  ".svc." .Values.ClusterDomain | quote -}}
{{- end -}}

{{- define "cockroachdb.clientServiceName" -}}{{- print (include "cockroachdb.fullName" .) "-client" | quote -}}{{- end -}}
{{- define "cockroachdb.initServiceName" -}}{{- print (include "cockroachdb.fullName" .) "-init" | quote -}}{{- end -}}
{{- define "cockroachdb.podDisruptionBudgetServiceName" -}}{{- print (include "cockroachdb.fullName" .) "-budget" | quote -}}{{- end -}}
{{- define "cockroachdb.initPodHostname" -}}
{{- print (include "cockroachdb.fullName" .) "-0." (include "cockroachdb.fullName" .) -}}
{{- end -}}


{{- define "cockroachdb.connectionScheme" -}}
{{- if .Values.Secure.Enabled -}}
{{- print "HTTPS" -}}
{{- else -}}
{{- print "HTTP" -}}
{{- end -}}
{{- end -}}
