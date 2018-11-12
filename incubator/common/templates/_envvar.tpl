{{- define "common.envvar.value" -}}
{{- $name := index . 0 -}}
{{- $value := index . 1 -}}

name: {{ $name }}
value: {{ default "" $value | quote }}
{{- end -}}

{{- define "common.envvar.configmap" -}}
{{- $name := index . 0 -}}
{{- $configMapName := index . 1 -}}
{{- $configMapKey := index . 2 -}}

name: {{ $name }}
valueFrom:
  configMapKeyRef:
    name: {{ $configMapName }}
    key: {{ $configMapKey }}
{{- end -}}

{{- define "common.envvar.secret" -}}
{{- $name := index . 0 -}}
{{- $secretName := index . 1 -}}
{{- $secretKey := index . 2 -}}

name: {{ $name }}
valueFrom:
  secretKeyRef:
    name: {{ $secretName }}
    key: {{ $secretKey }}
{{- end -}}

{{- define "common.envvar.from_yaml" -}}
{{- $root := index . 0 -}}
{{- $prefix := index . 1 -}}
{{- $itemTemplateName := index . 2 -}}

{{- range $name, $value := $root -}}
{{- $name := printf "%s_%s" $prefix  (regexReplaceAll "([a-z0-9])([A-Z])" $name "${1}_${2}") | upper -}}
{{- if kindIs "map" $value }}
{{- include "common.envvar.from_yaml" (list $value $name $itemTemplateName) -}}
{{- else if kindIs "slice" $value }}
{{ include $itemTemplateName (list $name (join "," $value | quote)) }}
{{- else }}
{{ include $itemTemplateName (list $name ($value | quote)) }}
{{- end }}
{{- end -}}
{{- end -}}
