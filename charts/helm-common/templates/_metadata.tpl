{{/* vim: set filetype=mustache: */}}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- with .Chart.AppVersion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}

{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "common.componentLabels" -}}
{{- $component := . -}}
app.kubernetes.io/component: {{ $component.appComponent }}
{{- end }}

{{- define "common.metadata.tpl" -}}
{{- $top := first . -}}
{{- $component := last . -}}
{{- if $component.appComponent }}
name: {{ include "common.fullname" $top }}-{{ $component.appComponent }}
{{- else }}
name: {{ include "common.fullname" $top }}
{{- end }}
namespace: {{ include "common.namespace" $top }}
labels:
  {{- include "common.labels" $top  | nindent 2 }}
  {{- include "common.componentLabels"  $component  | nindent 2 }}
{{- end }}

{{/*
Create a standard metadata header
*/}}
{{- define "common.metadata" -}}
{{- include "common.utils.merge" (append . "common.metadata.tpl") }}
{{- end }}


{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "common.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

