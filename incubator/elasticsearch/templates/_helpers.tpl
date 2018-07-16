{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified client name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.client.fullname" -}}
{{ template "elasticsearch.fullname" . }}-{{ .Values.client.name }}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.data.fullname" -}}
{{ template "elasticsearch.fullname" . }}-{{ .Values.data.name }}
{{- end -}}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.master.fullname" -}}
{{ template "elasticsearch.fullname" . }}-{{ .Values.master.name }}
{{- end -}}

{{/*
Create the default client node java opts
We can add custom overrides here.

`opts_equals` are applied with `-` prefix and `=` option. Ex. `foo: bar` -> `-foo=bar`
`opts` are applied with `-` prefix and without a `=`. Ex. `foo: bar` -> `-foobar`
*/}}
{{- define "elasticsearch.client.java_opts" -}}
-Djava.net.preferIPv4Stack=true {{ if .Values.client.heapSize }}-Xms{{ .Values.client.heapSize }} -Xmx{{ .Values.client.heapSize }}{{ end }}{{- range $opt, $val := .Values.client.java.opts_equals }}-{{ $opt }}={{ $val }} {{- end}} {{- range $opt, $val := .Values.client.java.opts }}-{{ $opt }}{{ $val }} {{- end}}
{{- end -}}

{{/*
Create the default master node java opts
We can add custom overrides here.

`opts_equals` are applied with `-` prefix and `=` option. Ex. `foo: bar` -> `-foo=bar`
`opts` are applied with `-` prefix and without a `=`. Ex. `foo: bar` -> `-foobar`
*/}}
{{- define "elasticsearch.master.java_opts" -}}
-Djava.net.preferIPv4Stack=true {{ if .Values.master.heapSize }}-Xms{{ .Values.master.heapSize }} -Xmx{{ .Values.master.heapSize }}{{ end }}{{- range $opt, $val := .Values.master.java.opts_equals }}-{{ $opt }}={{ $val }} {{- end}} {{- range $opt, $val := .Values.master.java.opts }}-{{ $opt }}{{ $val }} {{- end}}
{{- end -}}

{{/*
Create the default data node java opts
We can add custom overrides here.

`opts_equals` are applied with `-` prefix and `=` option. Ex. `foo: bar` -> `-foo=bar`
`opts` are applied with `-` prefix and without a `=`. Ex. `foo: bar` -> `-foobar`
*/}}
{{- define "elasticsearch.data.java_opts" -}}
-Djava.net.preferIPv4Stack=true {{ if .Values.data.heapSize }}-Xms{{ .Values.data.heapSize }} -Xmx{{ .Values.data.heapSize }}{{ end }}{{- range $opt, $val := .Values.data.java.opts_equals }}-{{ $opt }}={{ $val }} {{- end}} {{- range $opt, $val := .Values.data.java.opts }}-{{ $opt }}{{ $val }} {{- end}}
{{- end -}}