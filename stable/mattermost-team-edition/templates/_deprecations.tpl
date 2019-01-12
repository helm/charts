{{- /*
A template for handling deprecation messages. The messages templated here will
be combined into a single `fail` call. This creates a means for the user to
receive all messages at one time, in place a frustrating iterative approach.

To add a deprecation:

1. Define a new template prefixed `mattermost.deprecate.`
2. Check for deprecated values / patterns, and directly output messages (see
   message format below)
3. Add a line to `mattermost.deprecations` to include the new template.

Message format:

```
deprecatedHelmConfig.option is deprecated, please use the following configuration instead...

newHelmConfig:
  option:
    {{- .Values.deprecatedHelmConfig.option | toYaml | nindent 4 }}
```
*/}}

{{- /*
Compile all deprecations into a single message, and call fail.
*/}}

{{- define "mattermost.deprecations" }}
{{- /* add templates here */}}
{{- $deprecated := list }}
{{- $deprecated := append $deprecated (include "mattermost.deprecate.auth.gitlab" .) }}

{{- /* prepare output */}}
{{- $deprecated := without $deprecated "" }}
{{- $message := join "\n---\n" $deprecated }}

{{- /* print output */}}
{{- if $message }}
{{- printf "\n\nFAILURE DUE TO THE FOLLOWING DEPRECATIONS:\n------------------------------------------\n%s" $message | fail }}
{{- end }}
{{- end }}


{{- /* Deprecate auth.gitlab */}}
{{- define "mattermost.deprecate.auth.gitlab" }}
{{- if typeIs "map[string]interface {}" .Values.auth }}
{{- if typeIs "map[string]interface {}" .Values.auth.gitlab }}
'auth.gitlab' is deprecated, instead use 'defaultConfig.GitLabSettings' like this:

defaultConfig:
  GitLabSettings:
    {{- .Values.auth.gitlab | toYaml | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}
