{{- define "crate.clusterName" }}
  {{- if $n := .Values.crate.clusterName }}
    {{- $n }}
  {{- else }}
    {{- .Values.app }}
  {{- end }}
{{- end }}

{{- define "crate.initialMasterNodes" }}
  {{- range $i := until (int .Values.crate.numberOfNodes) -}}
    {{- if $i }},{{ end }}crate-{{ $i -}}
  {{- end }}
{{- end }}

{{- define "crate.recoverAfterNodes" }}
  {{- if $r := .Values.crate.recoverAfterNodes }}
    {{- $r }}
  {{- else }}
    {{- div .Values.crate.numberOfNodes 2 | floor | add 1 }}
  {{- end }}
{{- end }}
