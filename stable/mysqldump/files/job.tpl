spec:
  containers:
  - name: mysql-backup
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy | quote }}
    command: ["/bin/bash", "/scripts/backup.sh"]
    envFrom:
    - configMapRef:
        name: "{{ template "mysqldump.fullname" . }}"
    - secretRef:
        name: "{{ template "mysqldump.fullname" . }}"
    volumeMounts:
    - name: backups
      mountPath: /backup
{{- if .Values.persistence.subPath }}
      subPath: {{ .Values.persistence.subPath }}
{{- end }}
    - name: mysql-backup-script
      mountPath: /scripts
{{- if .Values.upload.ssh.enabled }}
    - name: ssh-privatekey
      mountPath: /root/.ssh
{{- end }}
{{- if .Values.upload.googlestoragebucket.enabled }}
    - name: gcloud-keyfile
      mountPath: /root/gcloud
{{- end }}
    resources:
{{ toYaml .Values.resources | indent 12 }}
{{- with .Values.nodeSelector }}
  nodeSelector:
{{ toYaml . | indent 8 }}
{{- end }}
{{- with .Values.affinity }}
  affinity:
{{ toYaml . | indent 8 }}
{{- end }}
{{- with .Values.tolerations }}
  tolerations:
{{ toYaml . | indent 8 }}
{{- end }}
  restartPolicy: Never
  volumes:
  - name: backups
{{- if .Values.persistentVolumeClaim }}
    persistentVolumeClaim:
      claimName: {{ .Values.persistentVolumeClaim }}
{{- else -}}
{{- if .Values.persistence.enabled }}
    persistentVolumeClaim:
      claimName: {{ template "mysqldump.fullname" . }}
{{- else }}
    emptyDir: {}
{{- end }}
{{- end }}
  - name: mysql-backup-script
    configMap:
      name: {{ template "mysqldump.fullname" . }}-script
{{- if .Values.upload.ssh.enabled }}
  - name: ssh-privatekey
    secret:
      secretName: {{ template "mysqldump.fullname" . }}-ssh-privatekey
      defaultMode: 256
{{- end }}
{{- if .Values.upload.googlestoragebucket.enabled }}
  - name: gcloud-keyfile
    secret:
      secretName: {{ template "mysqldump.gcpsecretName" . }}
      defaultMode: 256
{{ end }}
