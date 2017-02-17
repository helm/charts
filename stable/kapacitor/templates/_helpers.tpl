{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generic TOML config block renderer - handles most scenarios, but excludes the
influx key because it needs special handling, and the kapacitor key which is a
peseduo block for the top-level config items.
*/}}
{{- define "config" -}}
{{- range $key, $value := . -}}
{{- if and (ne $key "influx") (ne $key "kapacitor") }}
{{- $tp := typeOf $value }}
{{- if eq $tp "string"}}
    {{ $key }} = {{ $value | quote }}
{{- end }}
{{- if eq $tp "float64"}}
    {{ $key }} = {{ $value | int64 }}
{{- end }}
{{- if eq $tp "int"}}
    {{ $key }} = {{ $value | int64 }}
{{- end }}
{{- if eq $tp "bool"}}
    {{ $key }} = {{ $value }}
{{- end }}
{{- if eq $tp "map[string]interface {}" }}

    [{{ $key }}]
    {{- template "config" $value }}
{{- end }}
{{- if eq $tp "[]interface {}" }}
{{- $tp_item := typeOf (index $value 0) }}
{{- if eq $tp_item "string" }}
    {{ $key }} = [
    {{- range $i, $item := $value}}
      {{ $item | quote -}},{{ end }}
    ]
{{- else }}
{{- range $i, $item := $value }}

    [[{{ $key }}]]
    {{- template "config" $item }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Influx specific TOML renderer, handles the multiple influx blocks and their
special influx.subscriptions and influx.excluded-subscriptions keys (making sure
they appear at the end too).
*/}}
{{- define "influx" -}}
{{- range $i, $item := . }}

    [[influx]]
    {{- range $key, $value := $item -}}
    {{- if and (ne $key "subscriptions") (ne $key "excluded-subscriptions") }}
    {{- $tp := typeOf $value }}
    {{- if eq $tp "string"}}
    {{ $key }} = {{ $value | quote }}
    {{- end }}
    {{- if eq $tp "float64"}}
    {{ $key }} = {{ $value | int64 }}
    {{- end }}
    {{- if eq $tp "int"}}
    {{ $key }} = {{ $value | int64 }}
    {{- end }}
    {{- if eq $tp "bool"}}
    {{ $key }} = {{ $value }}
    {{- end }}
    {{- end }}
    {{- end }}

    [influx.subscriptions]
    {{- template "config" (index $item "subscriptions") }}

    [influx.excluded-subscriptions]
    {{- template "config" (index $item "excluded-subscriptions") }}
{{- end }}
{{- end -}}
