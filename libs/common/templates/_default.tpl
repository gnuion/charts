{{/*
Default
*/}}
{{- define "common.templates" }}
{{- include "common.deployment" . }}
---
{{- include "common.services" . }}
---
{{- include "common.ingresses" . }}
{{- end }}
