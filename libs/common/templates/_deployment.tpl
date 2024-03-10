{{/*
Deployment
*/}}
{{- define "common.deployment" }}
{{- $context := index . 0 }}
{{- $postfix := index . 1 }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.nameWithPostfix" . }}
  labels: {{ include "common.labelsWithPostfix" . | nindent 4}}
spec:
  replicas: 1
  selector:
    matchLabels: {{ include "common.selectorLabelsWithPostfix" . | nindent 6 }}
  template:
    metadata:
      labels: {{ include "common.selectorLabelsWithPostfix" . | nindent 8 }}
    spec:
      containers:
      - name: {{ $context.Chart.Name }}
        image: {{ index $context.Values $postfix "image" "repository" }}:{{ index $context.Values $postfix "image" "tag" }}
        {{- if index $context.Values $postfix "debug" }}
        command: ["/bin/sh", "-c", "--"]
        args: ["while true;do sleep 5;done"]
        {{- end }}
        ports:
        {{- range $key, $value := index $context.Values $postfix "ports" }}
        - containerPort: {{ $value.containerPort }}
          protocol: {{ $value.protocol }}
          name: {{ $key }}
        {{- end }}
        {{- if index $context.Values $postfix "capabilities" }}
        securityContext:
          capabilities:
            add:
            {{- range index $context.Values $postfix "capabilities" }}
            - {{. }}
            {{- end }}
        {{- end }}
        {{- if index $context.Values $postfix "env" }}
        envFrom:
        - secretRef:
            name: {{ include "common.nameWithPostfix" . }}
        {{- end }}
      {{- if index $context.Values $postfix "volumes" }}
        volumeMounts:
        {{- range index $context.Values $postfix "volumes" }}
        - mountPath: {{ .mountPath }}
          name: {{ .name }}
        {{- end }}
      volumes:
        {{- range index $context.Values $postfix "volumes" }}
        - hostPath:
            path: {{ .hostPath }}
            type: Directory
          name: {{ .name }}
        {{- end }}  
      {{- end }}
{{- end }}
