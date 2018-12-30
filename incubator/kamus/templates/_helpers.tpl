{{/*
Expand the name of the chart.
*/}}
{{- define "kamus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "appsettings.secrets.json" }}
{{ printf "{" }}
{{ if .Values.keyManagment.azureKeyVault}}
{{ printf "\n\t\"ActiveDirectory\": { " }}
{{ printf "\t\t\"ClientSecret\": \"%s\" " .Values.keyManagment.azureKeyVault.clientSecret }}
{{ printf "} \n"}}
{{- end -}}
{{ if .Values.keyManagment.AES}}
{{ printf "\"KeyManagement\": { \n\t\t\"AES\": { \"Key\": \"%s\" } }" .Values.keyManagment.AES.key }}
{{- end -}}
{{ printf "}" }}
{{- end }}

{{- define "common.configurations" -}}
KeyManagement__Provider: {{ .Values.keyManagment.provider }}
{{ if .Values.keyManagment.azureKeyVault }}
KeyManagement__KeyVault__Name: {{ .Values.keyManagment.azureKeyVault.keyVaultName }}
KeyManagement__KeyVault__KeyType: {{ default "RSA-HSM" .Values.keyManagment.azureKeyVault.keyType }}
KeyManagement__KeyVault__KeyLength: {{ default "2048" .Values.keyManagment.azureKeyVault.keySize | quote }}
KeyManagement__KeyVault__MaximumDataLength: {{ default "214" .Values.keyManagment.azureKeyVault.maximumDataLength | quote }}
ActiveDirectory__ClientId: {{ .Values.keyManagment.azureKeyVault.clientId }}
{{ end }}
{{- end -}}}}
