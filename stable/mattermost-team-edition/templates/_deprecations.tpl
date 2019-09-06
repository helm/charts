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
{{- $depHeader := print "\n\nFAILURE DUE TO DEPRECATIONS:\n----------------------------" }}
{{- $depMessage := "" }}

{{- /*
deprecations in order to transition to a passthrough configuration in configJSON
*/}}
{{- $passthroughs := list }}
{{- $passthroughs := append $passthroughs (include "mattermost.deprecate.auth.gitlab" .) }}
{{- $passthroughs := append $passthroughs (include "mattermost.deprecate.config.siteUrl" .) }}
{{- $passthroughs := append $passthroughs (include "mattermost.deprecate.config.siteName" .) }}
{{- $passthroughs := append $passthroughs (include "mattermost.deprecate.config.fileSettings" .) }}
{{- $passthroughs := append $passthroughs (include "mattermost.deprecate.config.emailSettings" .) }}
{{- $passthroughs := without $passthroughs "" }}
{{- if $passthroughs }}
{{- $passthroughsHeader := print "\n\nconfigJSON:" }}
{{- $passthroughsMessage := print $passthroughsHeader (join "\n" $passthroughs) }}
{{- $depMessage := print $depMessage $passthroughsMessage }}}
{{- end }}

{{- if typeIs "string" .Values.extraInitContainers }}
{{- $stringToListMessage := print "\n\nPlease make extraInitContainers a list instead of a string.\nGot a '|' symbol after extraInitContainers? Remove it." }}
{{- $depMessage := print $depMessage $stringToListMessage }}
{{- end }}

{{- /* print output */}}
{{- if $depMessage }}
{{- printf $depMessage | fail }}
{{- end }}
{{- end }}



{{- /* Deprecate auth.gitlab */}}
{{- define "mattermost.deprecate.auth.gitlab" }}
{{- if typeIs "map[string]interface {}" .Values.auth }}
{{- if typeIs "map[string]interface {}" .Values.auth.gitlab }}
  # auth.gitlab is deprecated, instead use:
  GitLabSettings:
    {{- .Values.auth.gitlab | toYaml | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}

{{- /* Deprecate config.siteUrl */}}
{{- define "mattermost.deprecate.config.siteUrl" }}
{{- if typeIs "map[string]interface {}" .Values.config }}
{{- if .Values.config.siteUrl }}
  # config.siteUrl is deprecated, instead use:
  ServiceSettings:
    SiteURL: {{ .Values.config.siteUrl | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- /* Deprecate config.siteName */}}
{{- define "mattermost.deprecate.config.siteName" }}
{{- if typeIs "map[string]interface {}" .Values.config }}
{{- if .Values.config.siteName }}
  # config.siteName is deprecated, instead use:
  TeamSettings:
    SiteName: {{ .Values.config.siteName | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- /* Deprecate config.fileSettings */}}
{{- define "mattermost.deprecate.config.fileSettings" }}
{{- if typeIs "map[string]interface {}" .Values.config }}
{{- $FileSettings := dict }}
{{- if or .Values.config.filesAccessKey (or .Values.config.filesSecretKey .Values.config.fileBucketName) }}
{{- $_ := set $FileSettings "DriverName" "amazons3" }}
{{- $_ := set $FileSettings "AmazonS3AccessKeyId" (.Values.config.filesAccessKey | default "") }}
{{- $_ := set $FileSettings "AmazonS3SecretAccessKey" (.Values.config.filesSecretKey | default "") }}
{{- $_ := set $FileSettings "AmazonS3Bucket" (.Values.config.fileBucketName | default "") }}
  # config.fileSecretKey,
  # config.fileAccessKey,
  # config.fileBucketName,
  # are all deprecated, instead use:
  FileSettings:
    {{- $FileSettings | toYaml | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}

{{- /* Deprecate config.emailSettings */}}
{{- define "mattermost.deprecate.config.emailSettings" }}
{{- if typeIs "map[string]interface {}" .Values.config }}
{{- if or .Values.config.smtpServer (or (hasKey .Values.config "enableSignUpWithEmail") (or .Values.config.feedbackName .Values.config.feedbackEmail)) }}
{{- $EmailSettings := dict }}
{{- if .Values.config.smtpServer }}
{{- $_ := set $EmailSettings "SendEmailNotifications" true }}
{{- else }}
{{- $_ := set $EmailSettings "SendEmailNotifications" false }}
{{- end }}
{{- $_ := set $EmailSettings "EnableSignUpWithEmail" (.Values.config.enableSignUpWithEmail | default true) }}
{{- $_ := set $EmailSettings "FeedbackName" (.Values.config.feedbackName | default "") }}
{{- $_ := set $EmailSettings "FeedbackEmail" (.Values.config.feedbackEmail | default "") }}
{{- $_ := set $EmailSettings "SMTPUsername" (.Values.config.smtpUsername | default "") }}
{{- $_ := set $EmailSettings "SMTPPassword" (.Values.config.smtpPassword | default "") }}
{{- if and .Values.config.smtpUsername .Values.config.smtpPassword }}
{{- $_ := set $EmailSettings "EnableSMTPAuth" true }}
{{- else }}
{{- $_ := set $EmailSettings "EnableSMTPAuth" false }}
{{- end }}
{{- $_ := set $EmailSettings "SMTPServer" (.Values.config.smtpServer | default "") }}
{{- $_ := set $EmailSettings "SMTPPort" (.Values.config.smtpPort | default "") }}
{{- $_ := set $EmailSettings "ConnectionSecurity" (.Values.config.smtpConnection | default "") }}
  # config.enableSignUpWithEmail,
  # config.feedbackName,
  # config.feedbackEmail,
  # config.smtpUsername,
  # config.smtpPassword,
  # config.smtpUsername,
  # config.smtpPassword,
  # config.smtpServer,
  # config.smtpPort,
  # config.smtpConnection,
  # are all deprecated, instead use:
  EmailSettings:
    {{- $EmailSettings | toYaml | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}
