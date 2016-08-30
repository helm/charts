{{define "fullname"}}
{{- $name := default "grafana" .Values.nameOverride -}}
{{printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{end}}
{{define "proxyname"}}
{{- $name := default "grafana" .Values.nameOverride -}}
{{printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{end}}
