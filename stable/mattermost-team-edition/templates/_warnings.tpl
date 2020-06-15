{{- /*
A template for handling warning messages.
*/}}

{{- /* Warn about not setting salt and keys explicitly */}}
{{- define "mattermost.warnings" }}
{{- with .Values.configJSON }}
{{- if not (and (.EmailSettings.InviteSalt) (and .FileSettings.PublicLinkSalt .SqlSettings.AtRestEncryptKey)) }}
WARNING:
--------

Every `helm upgrade` will generate a new set of keys unless it is set manually like this:

configJSON:
  {{- if not .EmailSettings.InviteSalt }}
  EmailSettings:
    InviteSalt: {{ randAlphaNum 32 }}
  {{- end }}
  {{- if not .FileSettings.PublicLinkSalt }}
  FileSettings:
    PublicLinkSalt: {{ randAlphaNum 32 }}
  {{- end }}
  {{- if not .SqlSettings.AtRestEncryptKey }}
  SqlSettings:
    AtRestEncryptKey: {{ randAlphaNum 32 }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
