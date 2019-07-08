{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "external-dns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "external-dns.fullname" -}}
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
{{- define "external-dns.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "external-dns.labels" -}}
app.kubernetes.io/name: {{ template "external-dns.name" . }}
helm.sh/chart: {{ template "external-dns.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* matchLabels */}}
{{- define "external-dns.matchLabels" -}}
app.kubernetes.io/name: {{ template "external-dns.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* podAnnotations */}}
{{- define "external-dns.podAnnotations" -}}
{{- if .Values.podAnnotations }}
{{- toYaml .Values.podAnnotations }}
{{- end }}
{{- if .Values.metrics.podAnnotations }}
{{- toYaml .Values.metrics.podAnnotations }}
{{- end }}
{{- end -}}

{{/*
Return the proper External DNS image name
*/}}
{{- define "external-dns.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "external-dns.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "external-dns.aws-credentials" }}
[default]
aws_access_key_id = {{ .Values.aws.credentials.accessKey }}
aws_secret_access_key = {{ .Values.aws.credentials.secretKey }}
{{ end }}

{{- define "external-dns.aws-config" }}
[profile default]
role_arn = {{ .Values.aws.assumeRoleArn }}
region = {{ .Values.aws.region }}
source_profile = default
{{ end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "external-dns.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "external-dns.validateValues.provider" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.sources" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.aws" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.infoblox.gridHost" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.infoblox.wapiPassword" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must set a provider
*/}}
{{- define "external-dns.validateValues.provider" -}}
{{- if not .Values.provider -}}
external-dns: provider
    You must set a provider (options: aws, google, azure, cloudflare, ...)
    Please set the provider parameter (--set provider="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide sources to be observed for new DNS entries by ExternalDNS
*/}}
{{- define "external-dns.validateValues.sources" -}}
{{- if empty .Values.sources -}}
external-dns: sources
    You must provide sources to be observed for new DNS entries by ExternalDNS
    Please set the sources parameter (--set sources="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- The AWS Role to assume must follow ARN format when provider is "aws"
*/}}
{{- define "external-dns.validateValues.aws" -}}
{{- if and (eq .Values.provider "aws") .Values.aws.assumeRoleArn -}}
{{- if not (regexMatch "^arn:aws:iam::.*$" .Values.aws.assumeRoleArn) -}}
external-dns: aws.assumeRoleArn
    The AWS Role to assume must follow ARN format: `arn:aws:iam::123455567:role/external-dns`
    Ref: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
    Please set a valid ARN (--set aws.assumeRoleARN="xxxx")
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Grid Manager host when provider is "infoblox"
*/}}
{{- define "external-dns.validateValues.infoblox.gridHost" -}}
{{- if and (eq .Values.provider "infoblox") (not .Values.infoblox.gridHost) -}}
external-dns: infoblox.gridHost
    You must provide the the Grid Manager host when provider="infoblox".
    Please set the gridHost parameter (--set infoblox.gridHost="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide a WAPI password when provider is "infoblox"
*/}}
{{- define "external-dns.validateValues.infoblox.wapiPassword" -}}
{{- if and (eq .Values.provider "infoblox") (not .Values.infoblox.wapiPassword) -}}
external-dns: infoblox.wapiPassword
    You must provide a WAPI password when provider="infoblox".
    Please set the wapiPassword parameter (--set infoblox.wapiPassword="xxxx")
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "external-dns.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}
