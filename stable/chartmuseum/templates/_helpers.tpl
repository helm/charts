{{- /*
name defines a template for the name of the chartmuseum chart.

The prevailing wisdom is that names should only contain a-z, 0-9 plus dot (.) and dash (-), and should
not exceed 63 characters.

Parameters:

- .Values.nameOverride: Replaces the computed name with this given name
- .Values.namePrefix: Prefix
- .Values.global.namePrefix: Global prefix
- .Values.nameSuffix: Suffix
- .Values.global.nameSuffix: Global suffix

The applied order is: "global prefix + prefix + name + suffix + global suffix"

Usage: 'name: "{{- template "chartmuseum.name" . -}}"'
*/ -}}
{{- define "chartmuseum.name"}}
{{- $global := default (dict) .Values.global -}}
{{- $base := default .Chart.Name .Values.nameOverride -}}
{{- $gpre := default "" $global.namePrefix -}}
{{- $pre := default "" .Values.namePrefix -}}
{{- $suf := default "" .Values.nameSuffix -}}
{{- $gsuf := default "" $global.nameSuffix -}}
{{- $name := print $gpre $pre $base $suf $gsuf -}}
{{- $name | lower | trunc 54 | trimSuffix "-" -}}
{{- end -}}

{{- /*
fullname defines a suitably unique name for a resource by combining
the release name and the chartmuseum chart name.

The prevailing wisdom is that names should only contain a-z, 0-9 plus dot (.) and dash (-), and should
not exceed 63 characters.

Parameters:

- .Values.fullnameOverride: Replaces the computed name with this given name
- .Values.fullnamePrefix: Prefix
- .Values.global.fullnamePrefix: Global prefix
- .Values.fullnameSuffix: Suffix
- .Values.global.fullnameSuffix: Global suffix

The applied order is: "global prefix + prefix + name + suffix + global suffix"

Usage: 'name: "{{- template "chartmuseum.fullname" . -}}"'
*/ -}}
{{- define "chartmuseum.fullname"}}
{{- $global := default (dict) .Values.global -}}
{{- $base := default (printf "%s-%s" .Release.Name .Chart.Name) .Values.fullnameOverride -}}
{{- $gpre := default "" $global.fullnamePrefix -}}
{{- $pre := default "" .Values.fullnamePrefix -}}
{{- $suf := default "" .Values.fullnameSuffix -}}
{{- $gsuf := default "" $global.fullnameSuffix -}}
{{- $name := print $gpre $pre $base $suf $gsuf -}}
{{- $name | lower | trunc 54 | trimSuffix "-" -}}
{{- end -}}


{{- /*
chartmuseum.labels.standard prints the standard chartmuseum Helm labels.

The standard labels are frequently used in metadata.
*/ -}}
{{- define "chartmuseum.labels.standard" -}}
app: {{ template "chartmuseum.name" . }}
chart: {{ template "chartmuseum.chartref" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- /*
chartmuseum.chartref prints a chart name and version.

It does minimal escaping for use in Kubernetes labels.

Example output:

chartmuseum-0.4.5
*/ -}}
{{- define "chartmuseum.chartref" -}}
{{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{/*
Return the proper image name to change the volume permissions
*/}}
{{- define "chartmuseum.volumePermissions.image" -}}
{{- $registryName := .Values.volumePermissions.image.registry -}}
{{- $repositoryName := .Values.volumePermissions.image.repository -}}
{{- $tag := .Values.volumePermissions.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "chartmuseum.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if or .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}