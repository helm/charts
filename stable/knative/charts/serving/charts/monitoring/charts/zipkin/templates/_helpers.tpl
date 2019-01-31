{{- define "labels" -}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
{{- end -}}
