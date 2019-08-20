{{- define "partials.debug" -}}
image: {{.Image.Name}}:{{.Image.Version}}
imagePullPolicy: {{.Image.PullPolicy}}
name: linkerd-debug
terminationMessagePolicy: FallbackToLogsOnError
{{- end -}}
