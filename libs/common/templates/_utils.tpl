{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "common.chart" . }}
{{ include "common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
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

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Encode values a
*/}}
{{ define "common.mapToYamlB64enc" -}}
{{ range $key, $val := . -}}
{{ $key }}: {{ $val | squote | b64enc }}
{{ end -}}
{{ end -}}

{{/*
Return dict as a template
*/}}
{{ define "common.mapToYaml" -}}
{{ range $key, $val := . -}}
{{ $key }}: {{ $val | squote }}
{{ end -}}
{{ end -}}

{{/*
Return an image pull secret template
*/}}
{{- define "common.imagePullSecret" }}
{{- with .Values.regcred }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}



{{/*
Expand the name of the chart.
*/}}
{{- define "common.nameWithPostfix" -}}
{{- $context := index . 0 }}
{{- $postfix := index . 1 }}
{{- default (printf "%s-%s" $context.Chart.Name $postfix) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "common.selectorLabelsWithPostfix" -}}
{{- $context := index . 0 -}}
{{- $postfix := index . 1 -}}
app.kubernetes.io/name: {{ include "common.nameWithPostfix" (list $context $postfix) }}
app.kubernetes.io/instance: {{ $context.Release.Name }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "common.labelsWithPostfix" -}}
{{- $context := index . 0 -}}
helm.sh/chart: {{ include "common.chart" $context }}
{{ include "common.selectorLabelsWithPostfix" . -}}
{{- if  $context.Chart.AppVersion }}
app.kubernetes.io/version: {{  $context.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{  $context.Release.Service }}
{{- end }}

