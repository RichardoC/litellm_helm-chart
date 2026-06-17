{{/*
Expand the name of the chart.
*/}}
{{- define "litellm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "litellm.fullname" -}}
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
{{- define "litellm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "litellm.labels" -}}
helm.sh/chart: {{ include "litellm.chart" . }}
{{ include "litellm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "litellm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "litellm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "litellm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "litellm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the config configmap with hash suffix
*/}}
{{- define "litellm.configConfigMapName" -}}
{{- $configContent := .Values.proxy_config | toYaml | sha256sum | trunc 8 | trimSuffix "-" }}
{{- printf "%s-config-%s" (include "litellm.fullname" .) $configContent }}
{{- end }}

{{/*
Checksum of the extra config-dir ConfigMap sources, used as a pod annotation so
the Deployment rolls out when the projected ConfigMaps change.

It folds in both the referenced set (names/items from values) and the live
contents of those ConfigMaps. Contents are read via `lookup`, which only
resolves against a live cluster (helm install/upgrade). Under `helm template`,
`--dry-run`, or tooling that disables lookups (e.g. some GitOps dry-runs) the
content portion is empty, so there a content-only change will not be detected.
*/}}
{{- define "litellm.configDirExtraChecksum" -}}
{{- $parts := list (.Values.configDirExtraConfigMaps | toYaml) -}}
{{- range .Values.configDirExtraConfigMaps -}}
{{- $cm := lookup "v1" "ConfigMap" $.Release.Namespace .name -}}
{{- if $cm -}}
{{- $parts = append $parts (printf "%s/%s=%s" $.Release.Namespace .name (toYaml ($cm.data | default dict))) -}}
{{- end -}}
{{- end -}}
{{- $parts | join "\n" | sha256sum -}}
{{- end }}

{{/*
Calculate the sleep duration for preStop hook
*/}}
{{- define "litellm.sleepDuration" -}}
{{- .Values.proxy_config.litellm_settings.request_timeout | default 60 | mul 1.1 | int }}
{{- end }}

{{/*
Calculate the termination grace period (1.2 times the sleep duration)
*/}}
{{- define "litellm.terminationGracePeriod" -}}
{{- include "litellm.sleepDuration" . | mul 1.2 | int }}
{{- end }}
