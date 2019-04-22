{{/*
The version of the RBAC API to use.
*/}}
{{- define "instana-agent.rbacApiVersion" -}}
"rbac.authorization.k8s.io/v1"
{{- end -}}

{{/*
The baseName used by resources for the name attribute.
*/}}
{{- define "instana-agent.baseName" -}}
{{ default "instana-agent" .Values.baseName -}}
{{- end -}}

{{/*
The name of the ServiceAccount used.
*/}}
{{- define "instana-agent.serviceAccount" -}}
{{ default "instana-agent" .Values.rbac.serviceAccount.name -}}
{{- end -}}

{{/*
Add Helm metadata to resource labels.
*/}}
{{- define "instana-agent.helmChartLabels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
helm.sh/release: {{ .Release.Name }}
helm.sh/managed-by: {{ .Release.Service }}
{{- end -}}
