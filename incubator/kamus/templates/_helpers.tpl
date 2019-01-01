{{/*
Expand the name of the chart.
*/}}
{{- define "kamus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "appsettings.secrets.json" }}
{{ printf "{" }}
{{ if .Values.keyManagement.azureKeyVault}}
{{ printf "\n\t\"ActiveDirectory\": { " }}
{{ printf "\t\t\"ClientSecret\": \"%s\" " .Values.keyManagement.azureKeyVault.clientSecret }}
{{ printf "} \n"}}
{{- end -}}
{{ if .Values.keyManagement.AES}}
{{ printf "\"KeyManagement\": { \n\t\t\"AES\": { \"Key\": \"%s\" } }" .Values.keyManagement.AES.key }}
{{- end -}}
{{ printf "}" }}
{{- end }}

{{- define "common.configurations" -}}
KeyManagement__Provider: {{ .Values.keyManagement.provider }}
{{ if .Values.keyManagement.azureKeyVault }}
KeyManagement__KeyVault__Name: {{ .Values.keyManagement.azureKeyVault.keyVaultName }}
KeyManagement__KeyVault__KeyType: {{ default "RSA-HSM" .Values.keyManagement.azureKeyVault.keyType }}
KeyManagement__KeyVault__KeyLength: {{ default "2048" .Values.keyManagement.azureKeyVault.keySize | quote }}
KeyManagement__KeyVault__MaximumDataLength: {{ default "214" .Values.keyManagement.azureKeyVault.maximumDataLength | quote }}
ActiveDirectory__ClientId: {{ .Values.keyManagement.azureKeyVault.clientId }}
{{ end }}
{{ if .Values.keyManagement.googleKms }}
KeyManagement__GoogleKms__Location: {{ .Values.keyManagement.googleKms.location }}
KeyManagement__GoogleKms__KeyRingName: {{ .Values.keyManagement.googleKms.keyRing }}
KeyManagement__GoogleKms__ProtectionLevel: {{ default "HSM" .Values.keyManagement.googleKms.protectionLevel }}
KeyManagement__GoogleKms__CredentialsPath:  "/home/dotnet/app/secrets/googlecloudcredentials.json"
{{ end }}
{{- end -}}}}
