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
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels }}
{{- end }}
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
region = {{ .Values.aws.region }}
source_profile = default
{{ end }}

{{- define "external-dns.azure-credentials" -}}
{
  {{- if .Values.azure.cloud }}
  "cloud": "{{ .Values.azure.cloud }}",
  {{- end}}
  "tenantId": "{{ .Values.azure.tenantId }}",
  "subscriptionId": "{{ .Values.azure.subscriptionId }}",
  "resourceGroup": "{{ .Values.azure.resourceGroup }}",
  {{- if not .Values.azure.useManagedIdentityExtension }}
  "aadClientId": "{{ .Values.azure.aadClientId }}",
  "aadClientSecret": "{{ .Values.azure.aadClientSecret }}"
  {{- end }}
  {{- if .Values.azure.useManagedIdentityExtension }}
  "useManagedIdentityExtension": true
  {{- end }}
}
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
{{- $messages := append $messages (include "external-dns.validateValues.pdns.apiUrl" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.pdns.apiKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.resourceGroup" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.tenantId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.subscriptionId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.aadClientId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.aadClientSecret" .) -}}
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

{{/*
Return the appropriate apiVersion for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the PowerDNS API URL when provider is "pdns"
*/}}
{{- define "external-dns.validateValues.pdns.apiUrl" -}}
{{- if and (eq .Values.provider "pdns") (not .Values.pdns.apiUrl) -}}
external-dns: pdns.apiUrl
    You must provide the the PowerDNS API URL when provider="pdns".
    Please set the apiUrl parameter (--set pdns.apiUrl="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the PowerDNS API key when provider is "pdns"
*/}}
{{- define "external-dns.validateValues.pdns.apiKey" -}}
{{- if and (eq .Values.provider "pdns") (not .Values.pdns.apiKey) -}}
external-dns: pdns.apiKey
    You must provide the the PowerDNS API key when provider="pdns".
    Please set the apiKey parameter (--set pdns.apiKey="xxxx")
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "external-dns.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Resource Group when provider is "azure"
*/}}
{{- define "external-dns.validateValues.azure.resourceGroup" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.resourceGroup) -}}
external-dns: azure.resourceGroup
    You must provide the Azure Resource Group when provider="azure".
    Please set the resourceGroup parameter (--set azure.resourceGroup="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Tenant ID when provider is "azure" and secretName is not set
*/}}
{{- define "external-dns.validateValues.azure.tenantId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.tenantId) (not .Values.azure.secretName) -}}
external-dns: azure.tenantId
    You must provide the Azure Tenant ID when provider="azure".
    Please set the tenantId parameter (--set azure.tenantId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Subscription ID when provider is "azure" and secretName is not set
*/}}
{{- define "external-dns.validateValues.azure.subscriptionId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.subscriptionId) (not .Values.azure.secretName) -}}
external-dns: azure.subscriptionId
    You must provide the Azure Subscription ID when provider="azure".
    Please set the subscriptionId parameter (--set azure.subscriptionId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must not provide the Azure AAD Client ID when provider is "azure", secretName is not set and MSI is enabled
*/}}
{{- define "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) .Values.azure.aadClientId .Values.azure.useManagedIdentityExtension -}}
external-dns: azure.seManagedIdentityExtension
    You must not provide the Azure AAD Client ID when provider="azure" and useManagedIdentityExtension is "true".
    Please unset the aadClientId parameter (--set azure.aadClientId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must not provide the Azure AAD Client Secret when provider is "azure", secretName is not set and MSI is enabled
*/}}
{{- define "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientSecret" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) .Values.azure.aadClientSecret .Values.azure.useManagedIdentityExtension -}}
external-dns: azure.seManagedIdentityExtension
    You must not provide the Azure AAD Client Secret when provider="azure" and useManagedIdentityExtension is "true".
    Please unset set the aadClientSecret parameter (--set azure.aadClientSecret="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure AAD Client ID when provider is "azure", secretName is not set and MSI is disabled
*/}}
{{- define "external-dns.validateValues.azure.aadClientId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) (not .Values.azure.aadClientId) (not .Values.azure.useManagedIdentityExtension) -}}
external-dns: azure.seManagedIdentityExtension
    You must provide the Azure AAD Client ID when provider="azure" and useManagedIdentityExtension is not set.
    Please set the aadClientId parameter (--set azure.aadClientId="xxxx").
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure AAD Client Secret when provider is "azure", secretName is not set and MSI is disabled
*/}}
{{- define "external-dns.validateValues.azure.aadClientSecret" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) (not .Values.azure.aadClientSecret) (not .Values.azure.useManagedIdentityExtension) -}}
external-dns: azure.seManagedIdentityExtension
    You must provide the Azure AAD Client Secret when provider="azure" and useManagedIdentityExtension is not set.
    Please set set the aadClientSecret parameter (--set azure.aadClientSecret="xxxx")
{{- end -}}
{{- end -}}
