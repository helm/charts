{{- define "crate.clusterName" }}
  {{- if $n := .Values.crate.clusterName }}
    {{- $n }}
  {{- else }}
    {{- .Values.app }}
  {{- end }}
{{- end }}
