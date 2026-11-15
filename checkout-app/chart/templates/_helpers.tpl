{{- define "checkout.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "checkout.labels" -}}
app.kubernetes.io/name: {{ include "checkout.name" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/* The analysis block the Rollout sends to the platform's shared templates.
     Every template gets the same three arguments: where to look, and which
     pods are the new version (their pod-template hash). */}}
{{- define "checkout.analysis" -}}
templates:
  {{- range .templates }}
  - templateName: {{ . }}
    clusterScope: true          # a ClusterAnalysisTemplate, owned by the platform team
  {{- end }}
args:
  - name: namespace
    value: {{ $.ns }}
  - name: app
    value: {{ $.name }}
  - name: new-hash
    valueFrom:
      podTemplateHashValue: Latest   # the pods of the version being released
{{- end -}}
