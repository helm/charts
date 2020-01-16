{{- define "grafana.pod" -}}
{{- if .Values.schedulerName }}
schedulerName: "{{ .Values.schedulerName }}"
{{- end }}
serviceAccountName: {{ template "grafana.serviceAccountName" . }}
{{- if .Values.schedulerName }}
schedulerName: "{{ .Values.schedulerName }}"
{{- end }}
{{- if .Values.securityContext }}
securityContext:
{{ toYaml .Values.securityContext | indent 2 }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
{{- if ( or .Values.persistence.enabled .Values.dashboards .Values.sidecar.datasources.enabled .Values.extraInitContainers) }}
initContainers:
{{- end }}
{{- if ( and .Values.persistence.enabled .Values.initChownData.enabled ) }}
  - name: init-chown-data
    image: "{{ .Values.initChownData.image.repository }}:{{ .Values.initChownData.image.tag }}"
    imagePullPolicy: {{ .Values.initChownData.image.pullPolicy }}
    securityContext:
      runAsUser: 0
    command: ["chown", "-R", "{{ .Values.securityContext.runAsUser }}:{{ .Values.securityContext.runAsUser }}", "/var/lib/grafana"]
    resources:
{{ toYaml .Values.initChownData.resources | indent 6 }}
    volumeMounts:
      - name: storage
        mountPath: "/var/lib/grafana"
{{- if .Values.persistence.subPath }}
        subPath: {{ .Values.persistence.subPath }}
{{- end }}
{{- end }}
{{- if .Values.dashboards }}
  - name: download-dashboards
    image: "{{ .Values.downloadDashboardsImage.repository }}:{{ .Values.downloadDashboardsImage.tag }}"
    imagePullPolicy: {{ .Values.downloadDashboardsImage.pullPolicy }}
    command: ["/bin/sh"]
    args: [ "-c", "mkdir -p /var/lib/grafana/dashboards/default && /bin/sh /etc/grafana/download_dashboards.sh" ]
    env:
{{- range $key, $value := .Values.downloadDashboards.env }}
      - name: "{{ $key }}"
        value: "{{ $value }}"
{{- end }}
    volumeMounts:
      - name: config
        mountPath: "/etc/grafana/download_dashboards.sh"
        subPath: download_dashboards.sh
      - name: storage
        mountPath: "/var/lib/grafana"
{{- if .Values.persistence.subPath }}
        subPath: {{ .Values.persistence.subPath }}
{{- end }}
    {{- range .Values.extraSecretMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
        readOnly: {{ .readOnly }}
    {{- end }}
{{- end }}
{{- if .Values.sidecar.datasources.enabled }}
  - name: {{ template "grafana.name" . }}-sc-datasources
    image: "{{ .Values.sidecar.image }}"
    imagePullPolicy: {{ .Values.sidecar.imagePullPolicy }}
    env:
      - name: METHOD
        value: LIST
      - name: LABEL
        value: "{{ .Values.sidecar.datasources.label }}"
      - name: FOLDER
        value: "/etc/grafana/provisioning/datasources"
      - name: RESOURCE
        value: "both"
      {{- if .Values.sidecar.datasources.searchNamespace }}
      - name: NAMESPACE
        value: "{{ .Values.sidecar.datasources.searchNamespace }}"
      {{- end }}
      {{- if .Values.sidecar.skipTlsVerify }}
      - name: SKIP_TLS_VERIFY
        value: "{{ .Values.sidecar.skipTlsVerify }}"
      {{- end }}
    resources:
{{ toYaml .Values.sidecar.resources | indent 6 }}
    volumeMounts:
      - name: sc-datasources-volume
        mountPath: "/etc/grafana/provisioning/datasources"
{{- end}}
{{- if .Values.extraInitContainers }}
{{ toYaml .Values.extraInitContainers | indent 2 }}
{{- end }}
{{- if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end}}
{{- end }}
containers:
{{- if .Values.sidecar.dashboards.enabled }}
  - name: {{ template "grafana.name" . }}-sc-dashboard
    image: "{{ .Values.sidecar.image }}"
    imagePullPolicy: {{ .Values.sidecar.imagePullPolicy }}
    env:
      - name: LABEL
        value: "{{ .Values.sidecar.dashboards.label }}"
      - name: FOLDER
        value: "{{ .Values.sidecar.dashboards.folder }}{{- with .Values.sidecar.dashboards.defaultFolderName }}/{{ . }}{{- end }}"
      - name: RESOURCE
        value: "both"
      {{- if .Values.sidecar.dashboards.searchNamespace }}
      - name: NAMESPACE
        value: "{{ .Values.sidecar.dashboards.searchNamespace }}"
      {{- end }}
      {{- if .Values.sidecar.skipTlsVerify }}
      - name: SKIP_TLS_VERIFY
        value: "{{ .Values.sidecar.skipTlsVerify }}"
      {{- end }}
    resources:
{{ toYaml .Values.sidecar.resources | indent 6 }}
    volumeMounts:
      - name: sc-dashboard-volume
        mountPath: {{ .Values.sidecar.dashboards.folder | quote }}
{{- end}}
  - name: {{ .Chart.Name }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.command }}
    command:
    {{- range .Values.command }}
      - {{ . }}
    {{- end }}
  {{- end}}
    volumeMounts:
      - name: config
        mountPath: "/etc/grafana/grafana.ini"
        subPath: grafana.ini
      {{- if .Values.ldap.enabled }}
      - name: ldap
        mountPath: "/etc/grafana/ldap.toml"
        subPath: ldap.toml
      {{- end }}
      {{- range .Values.extraConfigmapMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
        subPath: {{ .subPath | default "" }}
        readOnly: {{ .readOnly }}
      {{- end }}
      - name: storage
        mountPath: "/var/lib/grafana"
{{- if .Values.persistence.subPath }}
        subPath: {{ .Values.persistence.subPath }}
{{- end }}
{{- if .Values.dashboards }}
{{- range $provider, $dashboards := .Values.dashboards }}
{{- range $key, $value := $dashboards }}
{{- if (or (hasKey $value "json") (hasKey $value "file")) }}
      - name: dashboards-{{ $provider }}
        mountPath: "/var/lib/grafana/dashboards/{{ $provider }}/{{ $key }}.json"
        subPath: "{{ $key }}.json"
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
{{- if .Values.dashboardsConfigMaps }}
{{- range keys .Values.dashboardsConfigMaps }}
      - name: dashboards-{{ . }}
        mountPath: "/var/lib/grafana/dashboards/{{ . }}"
{{- end }}
{{- end }}
{{- if .Values.datasources }}
      - name: config
        mountPath: "/etc/grafana/provisioning/datasources/datasources.yaml"
        subPath: datasources.yaml
{{- end }}
{{- if .Values.notifiers }}
      - name: config
        mountPath: "/etc/grafana/provisioning/notifiers/notifiers.yaml"
        subPath: notifiers.yaml
{{- end }}
{{- if .Values.dashboardProviders }}
      - name: config
        mountPath: "/etc/grafana/provisioning/dashboards/dashboardproviders.yaml"
        subPath: dashboardproviders.yaml
{{- end }}
{{- if .Values.sidecar.dashboards.enabled }}
      - name: sc-dashboard-volume
        mountPath: {{ .Values.sidecar.dashboards.folder | quote }}
{{ if .Values.sidecar.dashboards.SCProvider }}
      - name: sc-dashboard-provider
        mountPath: "/etc/grafana/provisioning/dashboards/sc-dashboardproviders.yaml"
        subPath: provider.yaml
{{- end}}
{{- end}}
{{- if .Values.sidecar.datasources.enabled }}
      - name: sc-datasources-volume
        mountPath: "/etc/grafana/provisioning/datasources"
{{- end}}
    {{- range .Values.extraSecretMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
        readOnly: {{ .readOnly }}
    {{- end }}
    {{- range .Values.extraVolumeMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
        subPath: {{ .subPath | default "" }}
        readOnly: {{ .readOnly }}
    {{- end }}
    {{- range .Values.extraEmptyDirMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
    {{- end }}
    ports:
      - name: {{ .Values.service.portName }}
        containerPort: {{ .Values.service.port }}
        protocol: TCP
      - name: {{ .Values.podPortName }}
        containerPort: 3000
        protocol: TCP
    env:
      {{- if not .Values.env.GF_SECURITY_ADMIN_USER }}
      - name: GF_SECURITY_ADMIN_USER
        valueFrom:
          secretKeyRef:
            name: {{ .Values.admin.existingSecret | default (include "grafana.fullname" .) }}
            key: {{ .Values.admin.userKey | default "admin-user" }}
      {{- end }}
      {{- if not .Values.env.GF_SECURITY_ADMIN_PASSWORD }}
      - name: GF_SECURITY_ADMIN_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ .Values.admin.existingSecret | default (include "grafana.fullname" .) }}
            key: {{ .Values.admin.passwordKey | default "admin-password" }}
      {{- end }}
      {{- if .Values.plugins }}
      - name: GF_INSTALL_PLUGINS
        valueFrom:
          configMapKeyRef:
            name: {{ template "grafana.fullname" . }}
            key: plugins
      {{- end }}
      {{- if .Values.smtp.existingSecret }}
      - name: GF_SMTP_USER
        valueFrom:
          secretKeyRef:
            name: {{ .Values.smtp.existingSecret }}
            key: {{ .Values.smtp.userKey | default "user" }}
      - name: GF_SMTP_PASSWORD
        valueFrom:
          secretKeyRef:
            name: {{ .Values.smtp.existingSecret }}
            key: {{ .Values.smtp.passwordKey | default "password" }}
      {{- end }}
    {{- range $key, $value := .Values.envValueFrom }}
      - name: {{ $key | quote }}
        valueFrom:
{{ toYaml $value | indent 10 }}
    {{- end }}
{{- range $key, $value := .Values.env }}
      - name: "{{ $key }}"
        value: "{{ $value }}"
{{- end }}
    {{- if .Values.envFromSecret }}
    envFrom:
      - secretRef:
          name: {{ .Values.envFromSecret }}
    {{- end }}
    {{- if .Values.envRenderSecret }}
    envFrom:
      - secretRef:
          name: {{ template "grafana.fullname" . }}-env
    {{- end }}
    livenessProbe:
{{ toYaml .Values.livenessProbe | indent 6 }}
    readinessProbe:
{{ toYaml .Values.readinessProbe | indent 6 }}
    resources:
{{ toYaml .Values.resources | indent 6 }}
{{- with .Values.extraContainers }}
{{ tpl . $ | indent 2 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
{{ toYaml . | indent 2 }}
{{- end }}
volumes:
  - name: config
    configMap:
      name: {{ template "grafana.fullname" . }}
{{- range .Values.extraConfigmapMounts }}
  - name: {{ .name }}
    configMap:
      name: {{ .configMap }}
{{- end }}
  {{- if .Values.dashboards }}
    {{- range keys .Values.dashboards }}
  - name: dashboards-{{ . }}
    configMap:
      name: {{ template "grafana.fullname" $ }}-dashboards-{{ . }}
    {{- end }}
  {{- end }}
  {{- if .Values.dashboardsConfigMaps }}
    {{ $root := . }}
    {{- range $provider, $name := .Values.dashboardsConfigMaps }}
  - name: dashboards-{{ $provider }}
    configMap:
      name: {{ tpl $name $root }}
    {{- end }}
  {{- end }}
  {{- if .Values.ldap.enabled }}
  - name: ldap
    secret:
      {{- if .Values.ldap.existingSecret }}
      secretName: {{ .Values.ldap.existingSecret }}
      {{- else }}
      secretName: {{ template "grafana.fullname" . }}
      {{- end }}
      items:
        - key: ldap-toml
          path: ldap.toml
  {{- end }}
{{- if and .Values.persistence.enabled (eq .Values.persistence.type "pvc") }}
  - name: storage
    persistentVolumeClaim:
      claimName: {{ .Values.persistence.existingClaim | default (include "grafana.fullname" .) }}
{{- else if and .Values.persistence.enabled (eq .Values.persistence.type "statefulset") }}
# nothing
{{- else }}
  - name: storage
    emptyDir: {}
{{- end -}}
{{- if .Values.sidecar.dashboards.enabled }}
  - name: sc-dashboard-volume
    emptyDir: {}
{{- if .Values.sidecar.dashboards.SCProvider }}
  - name: sc-dashboard-provider
    configMap:
      name: {{ template "grafana.fullname" . }}-config-dashboards
{{- end }}
{{- end }}
{{- if .Values.sidecar.datasources.enabled }}
  - name: sc-datasources-volume
    emptyDir: {}
{{- end -}}
{{- range .Values.extraSecretMounts }}
  - name: {{ .name }}
    secret:
      secretName: {{ .secretName }}
      defaultMode: {{ .defaultMode }}
{{- end }}
{{- range .Values.extraVolumeMounts }}
  - name: {{ .name }}
    persistentVolumeClaim:
      claimName: {{ .existingClaim }}
{{- end }}
{{- range .Values.extraEmptyDirMounts }}
  - name: {{ .name }}
    emptyDir: {}
{{- end -}}
{{- end }}
