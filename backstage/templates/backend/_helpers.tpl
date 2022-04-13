{{/*
Fullname
*/}}
{{- define "backstage.backendFullname" -}}
{{ include "backstage.fullname" . }}-backend
{{- end }}

{{/*
Common labels
*/}}
{{- define "backstage.backendLabels" -}}
{{ include "backstage.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backstage.backendSelectorLabels" -}}
{{ include "backstage.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "backstage.backendServiceAccountName" -}}
{{- if .Values.backend.serviceAccount.create }}
{{- default (printf "%s-backend" (include "backstage.fullname" .)) .Values.backend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.backend.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
The image to use
*/}}
{{- define "backstage.backendImage" -}}
{{- printf "%s:%s" .Values.backend.image.repository (default .Chart.AppVersion .Values.backend.image.tag) }}
{{- end }}

{{/*
Create config name.
*/}}
{{- define "backstage.backendConfigName" -}}
{{- template "backstage.backendFullname" . -}}-app-config
{{- end -}}


{{/*
Path to the CA certificate file in the backend
*/}}
{{- define "backstage.backend.postgresCaFilename" -}}
{{ include "backstage.backend.postgresCaDir" . }}/{{- required "The name for the CA certificate file for postgresql is required" .Values.global.postgresql.caFilename }}
{{- end -}}
{{/*

{{/*
Directory path to the CA certificate file in the backend
*/}}
{{- define "backstage.backend.postgresCaDir" -}}
{{- if .Values.appConfig.backend.database.connection.ssl.ca -}}
    {{ .Values.appConfig.backend.database.connection.ssl.ca }}
{{- else -}}
/etc/postgresql
{{- end -}}
{{- end -}}
{{/*

Path to the CA certificate file in lighthouse
*/}}
{{- define "backstage.lighthouse.postgresCaFilename" -}}
{{ include "backstage.lighthouse.postgresCaDir" . }}/{{- required "The name for the CA certificate file for postgresql is required" .Values.global.postgresql.caFilename }}
{{- end -}}

{{/*
Directory path to the CA certificate file in lighthouse
*/}}
{{- define "backstage.lighthouse.postgresCaDir" -}}
{{- if .Values.lighthouse.database.pathToDatabaseCa -}}
    {{ .Values.lighthouse.database.pathToDatabaseCa }}
{{- else -}}
/etc/postgresql
{{- end -}}
{{- end -}}