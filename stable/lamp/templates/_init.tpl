{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "init-def" -}}
name: "dry"
httpd: "test"
test:
  var: "test"
{{- end -}}
{{- define "init-j" -}}
{
  "name": "dry",
  "httpd": "test",
  "test": {
    "var": "test"
  }
}
{{- end -}}
{{ include "init-def" . | fromYaml}}
{{ include "init-j" . | fromJson}}
{{ include "init-def" . | fromJson | toJson}}
{{ include "init-j" . | fromJson | toJson}}

map[test:map[var:test] name:dry httpd:test]
map[name:dry httpd:test test:map[var:test]]

{"httpd":"test","name":"dry","test":{"var":"test"}}
