{{- define "commonLabels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "labels" -}}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{ include "commonLabels" . }}
{{- end -}}

{{- define "noVersionlabels" -}}
chart: {{ .Chart.Name }}
{{ include "commonLabels" . }}
{{- end -}}