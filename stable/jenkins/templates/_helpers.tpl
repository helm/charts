{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "jenkins.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "jenkins.master.slaveKubernetesNamespace" -}}
  {{- if .Values.master.slaveKubernetesNamespace -}}
    {{- tpl .Values.master.slaveKubernetesNamespace . -}}
  {{- else -}}
    {{- if .Values.namespaceOverride -}}
      {{- .Values.namespaceOverride -}}
    {{- else -}}
      {{- .Release.Namespace -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins.fullname" -}}
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
Returns the Jenkins URL
*/}}
{{- define "jenkins.url" -}}
{{- if .Values.master.jenkinsUrl }}
  {{- .Values.master.jenkinsUrl }}
{{- else }}
  {{- if .Values.master.ingress.hostName }}
    {{- if .Values.master.ingress.tls }}
      {{- default "https" .Values.master.jenkinsUrlProtocol }}://{{ .Values.master.ingress.hostName }}{{ default "" .Values.master.jenkinsUriPrefix }}
    {{- else }}
      {{- default "http" .Values.master.jenkinsUrlProtocol }}://{{ .Values.master.ingress.hostName }}{{ default "" .Values.master.jenkinsUriPrefix }}
    {{- end }}
  {{- else }}
      {{- default "http" .Values.master.jenkinsUrlProtocol }}://{{ template "jenkins.fullname" . }}:{{.Values.master.servicePort}}{{ default "" .Values.master.jenkinsUriPrefix }}
  {{- end}}
{{- end}}
{{- end -}}

{{/*
Returns configuration as code default config
*/}}
{{- define "jenkins.casc.defaults" -}}
jenkins:
{{- if eq .Values.master.enableXmlConfig false }}
  {{- $configScripts := toYaml .Values.master.JCasC.configScripts }}
  {{- if and (.Values.master.JCasC.authorizationStrategy) (not (contains "authorizationStrategy:" $configScripts)) }}
  authorizationStrategy:
    {{- tpl .Values.master.JCasC.authorizationStrategy . | nindent 4 }}
  {{- end }}
  {{- if and (.Values.master.JCasC.securityRealm) (not (contains "securityRealm:" $configScripts)) }}
  securityRealm:
    {{- tpl .Values.master.JCasC.securityRealm . | nindent 4 }}
  {{- end }}
{{- end }}
  disableRememberMe: {{ .Values.master.disableRememberMe }}
  remotingSecurity:
    enabled: true
  mode: {{ .Values.master.executorMode }}
  numExecutors: {{ .Values.master.numExecutors }}
  projectNamingStrategy: "standard"
  markupFormatter:
    {{- if .Values.master.enableRawHtmlMarkupFormatter }}
    rawHtml:
      disableSyntaxHighlighting: true
    {{- else }}
    {{- toYaml .Values.master.markupFormatter | nindent 4 }}
    {{- end }}
  clouds:
  - kubernetes:
      containerCapStr: "{{ .Values.agent.containerCap }}"
      defaultsProviderTemplate: "{{ .Values.master.slaveDefaultsProviderTemplate }}"
      connectTimeout: "{{ .Values.master.slaveConnectTimeout }}"
      readTimeout: "{{ .Values.master.slaveReadTimeout }}"
      {{- if .Values.master.slaveJenkinsUrl }}
      jenkinsUrl: "{{ tpl .Values.master.slaveJenkinsUrl . }}"
      {{- else if .Values.master.slaveKubernetesNamespace }}
      jenkinsUrl: "http://{{ template "jenkins.fullname" . }}.{{ template "jenkins.namespace" . }}:{{.Values.master.servicePort}}{{ default "" .Values.master.jenkinsUriPrefix }}"
      {{- else }}
      jenkinsUrl: "http://{{ template "jenkins.fullname" . }}:{{.Values.master.servicePort}}{{ default "" .Values.master.jenkinsUriPrefix }}"
      {{- end }}

      {{- if .Values.master.slaveJenkinsTunnel }}
      jenkinsTunnel: "{{ tpl .Values.master.slaveJenkinsTunnel . }}"
      {{- else if .Values.master.slaveKubernetesNamespace }}
      jenkinsTunnel: "{{ template "jenkins.fullname" . }}-agent.{{ template "jenkins.namespace" . }}:{{ .Values.master.slaveListenerPort }}"
      {{- else }}
      jenkinsTunnel: "{{ template "jenkins.fullname" . }}-agent:{{ .Values.master.slaveListenerPort }}"
      {{- end }}
      maxRequestsPerHostStr: "32"
      name: "kubernetes"
      namespace: "{{ template "jenkins.master.slaveKubernetesNamespace" . }}"
      serverUrl: "https://kubernetes.default"
      {{- if .Values.agent.enabled }}
      podLabels:
      - key: "jenkins/{{ .Release.Name }}-{{ .Values.agent.componentName }}"
        value: "true"
      templates:
      {{- include "jenkins.casc.podTemplate" . | nindent 8 }}
    {{- if .Values.additionalAgents }}
      {{- /* save .Values.agent */}}
      {{- $agent := .Values.agent }}
      {{- range $name, $additionalAgent := .Values.additionalAgents }}
        {{- /* merge original .Values.agent into additional agent to ensure it at least has the default values */}}
        {{- $additionalAgent := merge $additionalAgent $agent }}
        {{- /* set .Values.agent to $additionalAgent */}}
        {{- $_ := set $.Values "agent" $additionalAgent }}
        {{- include "jenkins.casc.podTemplate" $ | nindent 8 }}
      {{- end }}
      {{- /* restore .Values.agent */}}
      {{- $_ := set .Values "agent" $agent }}
    {{- end }}
      {{- if .Values.agent.podTemplates }}
        {{- range $key, $val := .Values.agent.podTemplates }}
          {{- tpl $val $ | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- end }}
  {{- if .Values.master.csrf.defaultCrumbIssuer.enabled }}
  crumbIssuer:
    standard:
      excludeClientIPFromCrumb: {{ if .Values.master.csrf.defaultCrumbIssuer.proxyCompatability }}true{{ else }}false{{- end }}
  {{- end }}
security:
  apiToken:
    creationOfLegacyTokenEnabled: false
    tokenGenerationOnCreationEnabled: false
    usageStatisticsEnabled: true
unclassified:
  location:
    adminAddress: {{ default "" .Values.master.jenkinsAdminEmail }}
    url: {{ template "jenkins.url" . }}
{{- end -}}

{{/*
Returns kubernetes pod template configuration as code
*/}}
{{- define "jenkins.casc.podTemplate" -}}
- name: "{{ .Values.agent.podName }}"
  containers:
  - name: "{{ .Values.agent.sideContainerName }}"
    alwaysPullImage: {{ .Values.agent.alwaysPullImage }}
    args: "{{ .Values.agent.args | replace "$" "^$" }}"
    {{- if .Values.agent.command }}
    command: {{ .Values.agent.command }}
    {{- end }}
    envVars:
    - containerEnvVar:
        key: "JENKINS_URL"
    {{- if .Values.master.slaveJenkinsUrl }}
        value: {{ tpl .Values.master.slaveJenkinsUrl . }}
    {{- else }}
        value: "http://{{ template "jenkins.fullname" . }}.{{ template "jenkins.namespace" . }}.svc.{{.Values.clusterZone}}:{{.Values.master.servicePort}}{{ default "" .Values.master.jenkinsUriPrefix }}"
    {{- end }}
    {{- if .Values.agent.imageTag }}
    image: "{{ .Values.agent.image }}:{{ .Values.agent.imageTag }}"
    {{- else }}
    image: "{{ .Values.agent.image }}:{{ .Values.agent.tag }}"
    {{- end }}
    privileged: "{{- if .Values.agent.privileged }}true{{- else }}false{{- end }}"
    resourceLimitCpu: {{.Values.agent.resources.limits.cpu}}
    resourceLimitMemory: {{.Values.agent.resources.limits.memory}}
    resourceRequestCpu: {{.Values.agent.resources.requests.cpu}}
    resourceRequestMemory: {{.Values.agent.resources.requests.memory}}
    runAsUser: {{ .Values.agent.runAsUser }}
    runAsGroup: {{ .Values.agent.runAsGroup }}
    ttyEnabled: {{ .Values.agent.TTYEnabled }}
    workingDir: {{ .Values.agent.workingDir }}
{{- if .Values.agent.envVars }}
  envVars:
  {{- range $index, $var := .Values.agent.envVars }}
    - envVar:
        key: {{ $var.name }}
        value: {{ tpl $var.value $ }}
  {{- end }}
{{- end }}
  idleMinutes: {{ .Values.agent.idleMinutes }}
  instanceCap: 2147483647
  {{- if .Values.agent.imagePullSecretName }}
  imagePullSecrets:
  - name: {{ .Values.agent.imagePullSecretName }}
  {{- end }}
  label: "{{ .Release.Name }}-{{ .Values.agent.componentName }} {{ .Values.agent.customJenkinsLabels  | join " " }}"
{{- if .Values.agent.nodeSelector }}
  nodeSelector:
  {{- $local := dict "first" true }}
  {{- range $key, $value := .Values.agent.nodeSelector }}
    {{- if $local.first }} {{ else }},{{ end }}
    {{- $key }}={{ tpl $value $ }}
    {{- $_ := set $local "first" false }}
  {{- end }}
{{- end }}
  nodeUsageMode: "NORMAL"
  podRetention: {{ .Values.agent.podRetention }}
  showRawYaml: true
  serviceAccount: "{{ include "jenkins.serviceAccountAgentName" . }}"
  slaveConnectTimeoutStr: "{{ .Values.agent.slaveConnectTimeout }}"
{{- if .Values.agent.volumes }}
  volumes:
  {{- range $index, $volume := .Values.agent.volumes }}
    -{{- if (eq $volume.type "ConfigMap") }} configMapVolume:
     {{- else if (eq $volume.type "EmptyDir") }} emptyDirVolume:
     {{- else if (eq $volume.type "HostPath") }} hostPathVolume:
     {{- else if (eq $volume.type "Nfs") }} nfsVolume:
     {{- else if (eq $volume.type "PVC") }} persistentVolumeClaim:
     {{- else if (eq $volume.type "Secret") }} secretVolume:
     {{- else }} {{ $volume.type }}:
     {{- end }}
    {{- range $key, $value := $volume }}
      {{- if not (eq $key "type") }}
        {{ $key }}: {{ if kindIs "string" $value }}{{ tpl $value $ | quote }}{{ else }}{{ $value }}{{ end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- if .Values.agent.yamlTemplate }}
  yaml: |-
    {{- tpl (trim .Values.agent.yamlTemplate) . | nindent 4 }}
{{- end }}
  yamlMergeStrategy: {{ .Values.agent.yamlMergeStrategy }}
{{- end -}}

{{/*
Returns kubernetes pod template xml configuration
*/}}
{{- define "jenkins.xml.podTemplate" -}}
<org.csanchez.jenkins.plugins.kubernetes.PodTemplate>
  <inheritFrom></inheritFrom>
  <name>{{ .Values.agent.podName }}</name>
  <instanceCap>2147483647</instanceCap>
  <idleMinutes>{{ .Values.agent.idleMinutes }}</idleMinutes>
  {{- $tmp := join " " .Values.agent.customJenkinsLabels }}
  {{- $labels := printf "%s-%s %s" .Release.Name .Values.agent.componentName $tmp }}
  <label>{{ $labels | trim  }}</label>
  <serviceAccount>{{ include "jenkins.serviceAccountAgentName" . }}</serviceAccount>
  <nodeSelector>
    {{- $local := dict "first" true }}
    {{- range $key, $value := .Values.agent.nodeSelector }}
      {{- if not $local.first }},{{- end }}
      {{- $key }}={{ $value }}
      {{- $_ := set $local "first" false }}
    {{- end }}</nodeSelector>
    <nodeUsageMode>NORMAL</nodeUsageMode>
  <volumes>
{{- range $index, $volume := .Values.agent.volumes }}
  {{- if (eq $volume.type "PVC") }}
    <org.csanchez.jenkins.plugins.kubernetes.volumes.PersistentVolumeClaim>
  {{- else }}
    <org.csanchez.jenkins.plugins.kubernetes.volumes.{{ $volume.type }}Volume>
  {{- end }}
  {{- range $key, $value := $volume }}{{- if not (eq $key "type") }}
      <{{ $key }}>{{ if kindIs "string" $value }}{{ tpl $value $ }}{{ else }}{{ $value }}{{ end }}</{{ $key }}>
  {{- end }}{{- end }}
  {{- if (eq $volume.type "PVC") }}
    </org.csanchez.jenkins.plugins.kubernetes.volumes.PersistentVolumeClaim>
  {{- else }}
    </org.csanchez.jenkins.plugins.kubernetes.volumes.{{ $volume.type }}Volume>
  {{- end }}
{{- end }}
  </volumes>
  <containers>
    <org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate>
      <name>{{ .Values.agent.sideContainerName }}</name>
{{- if .Values.agent.imageTag }}
      <image>{{ .Values.agent.image }}:{{ .Values.agent.imageTag }}</image>
{{- else }}
      <image>{{ .Values.agent.image }}:{{ .Values.agent.tag }}</image>
{{- end }}
{{- if .Values.agent.privileged }}
      <privileged>true</privileged>
{{- else }}
      <privileged>false</privileged>
{{- end }}
      <alwaysPullImage>{{ .Values.agent.alwaysPullImage }}</alwaysPullImage>
      <workingDir>{{ .Values.agent.workingDir }}</workingDir>
      <command>{{ .Values.agent.command }}</command>
      <args>{{ .Values.agent.args }}</args>
      <ttyEnabled>{{ .Values.agent.TTYEnabled }}</ttyEnabled>
      # Resources configuration is a little hacky. This was to prevent breaking
      # changes, and should be cleanned up in the future once everybody had
      # enough time to migrate.
      <resourceRequestCpu>{{.Values.agent.resources.requests.cpu}}</resourceRequestCpu>
      <resourceRequestMemory>{{.Values.agent.resources.requests.memory}}</resourceRequestMemory>
      <resourceLimitCpu>{{.Values.agent.resources.limits.cpu}}</resourceLimitCpu>
      <resourceLimitMemory>{{.Values.agent.resources.limits.memory}}</resourceLimitMemory>
      <envVars>
        <org.csanchez.jenkins.plugins.kubernetes.ContainerEnvVar>
          <key>JENKINS_URL</key>
{{- if .Values.master.slaveJenkinsUrl }}
          <value>{{ tpl .Values.master.slaveJenkinsUrl . }}</value>
{{- else }}
          <value>http://{{ template "jenkins.fullname" . }}.{{ template "jenkins.namespace" . }}.svc.{{.Values.clusterZone}}:{{.Values.master.servicePort}}{{ default "" .Values.master.jenkinsUriPrefix }}</value>
{{- end }}
        </org.csanchez.jenkins.plugins.kubernetes.ContainerEnvVar>
      </envVars>
    </org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate>
  </containers>
  <envVars>
{{- range $index, $var := .Values.agent.envVars }}
    <org.csanchez.jenkins.plugins.kubernetes.PodEnvVar>
      <key>{{ $var.name }}</key>
      <value>{{ $var.value }}</value>
    </org.csanchez.jenkins.plugins.kubernetes.PodEnvVar>
{{- end }}
  </envVars>
  <annotations/>
{{- if .Values.agent.imagePullSecretName }}
  <imagePullSecrets>
    <org.csanchez.jenkins.plugins.kubernetes.PodImagePullSecret>
      <name>{{ .Values.agent.imagePullSecretName }}</name>
    </org.csanchez.jenkins.plugins.kubernetes.PodImagePullSecret>
  </imagePullSecrets>
{{- else }}
  <imagePullSecrets/>
{{- end }}
  <nodeProperties/>
{{- if .Values.agent.yamlTemplate }}
  <yaml>
    {{- tpl (trim .Values.agent.yamlTemplate) . | html | nindent 4 }}
  </yaml>
{{- end }}
  <podRetention class="org.csanchez.jenkins.plugins.kubernetes.pod.retention.Default"/>
</org.csanchez.jenkins.plugins.kubernetes.PodTemplate>
{{- end -}}

{{- define "jenkins.kubernetes-version" -}}
  {{- if .Values.master.installPlugins -}}
    {{- range .Values.master.installPlugins -}}
      {{ if hasPrefix "kubernetes:" . }}
        {{- $split := splitList ":" . }}
        {{- printf "%s" (index $split 1 ) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "jenkins.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account for Jenkins agents to use
*/}}
{{- define "jenkins.serviceAccountAgentName" -}}
{{- if .Values.serviceAccountAgent.create -}}
    {{ default (printf "%s-%s" (include "jenkins.fullname" .) "agent") .Values.serviceAccountAgent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccountAgent.name }}
{{- end -}}
{{- end -}}
