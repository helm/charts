{{- define "kube-registry-proxy.fullname" -}}
{{- $name := default "kube-registry-proxy" .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
