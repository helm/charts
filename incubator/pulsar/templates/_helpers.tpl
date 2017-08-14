{{/* vim: set filetype=mustache: */}}
{{- define "zkServers" -}}
{{- $numZkServers := . | int -}}
{{- range $index, $element := until $numZkServers -}}
{{ if $index }},{{ end }}zk-{{ $index }}
{{- end -}}
{{- end -}}