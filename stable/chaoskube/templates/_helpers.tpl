{{- define "serviceName" -}}
{{- printf "%s-%s" .Release.Name .Values.name }}
{{- end -}}
