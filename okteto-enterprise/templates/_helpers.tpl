{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "okteto.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "okteto.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "okteto.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The default public URL of the web app
*/}}
{{- define "okteto.defaultpublic" -}}
{{- $subdomain := required "A valid .Values.subdomain is required" .Values.subdomain }}
{{- printf "%s.%s" "okteto" $subdomain }}
{{- end -}}

{{/*
Allow for overriding the public URL of the application, it defaults to okteto.SUBDOMAINS
*/}}
{{- define "okteto.public" -}}
{{- $name := include "okteto.defaultpublic" . }}
{{- default $name .Values.publicOverride -}}
{{- end -}}

{{/*
Returns the private IP of the service exposing okteto
*/}}
{{- define "okteto.ingressprivateip" -}}
{{- if (index .Values "ingress-nginx" "enabled") -}}
{{- if .Values.ingress.ip -}}
{{- .Values.ingress.ip -}}
{{- else -}}
{{- printf "$(%s_INGRESS_NGINX_CONTROLLER_SERVICE_HOST)" (regexReplaceAll "-" .Release.Name "_") | upper -}}
{{- end -}}
{{- else -}}
{{- required "If 'ingress-nginx' is not enabled you need to set the value of '.Values.ingress.ip'" .Values.ingress.ip -}}
{{- end -}}
{{- end -}}

{{- define "okteto.buildkitname" -}}
{{- $name :=  include "okteto.fullname" . }}
{{- printf "%s-buildkit" $name -}}
{{- end -}}

{{/*
Returns the private IP of the service exposing buildkit
*/}}
{{- define "okteto.buildkitprivateip" -}}
{{- $name :=  include "okteto.buildkitname" . }}
{{- printf "$(%s_SERVICE_HOST)" (regexReplaceAll "-" $name "_") | upper -}}
{{- end -}}

{{/*
Returns the wildcard domain form
*/}}
{{- define "okteto.wildcard" -}}
{{- printf "*.%s" .Values.subdomain -}}
{{- end -}}

{{/*
Returns the name of the mutation webhook
*/}}
{{- define "okteto.webhook" -}}
{{- $name := include "okteto.fullname" . }}
{{- printf "%s-mutation-webhook" $name -}}
{{- end -}}

{{/*
Returns the name of the dev cluster role
*/}}
{{- define "okteto.devclusterrole" -}}
{{- $name := include "okteto.fullname" . }}
{{- printf "%s-psp" $name -}}
{{- end -}}

{{- define "okteto.joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{- define "okteto.dockerconfigRoot" -}}
{{- printf "{ \"auths\": { " -}}
{{- $local := dict "first" true -}}
{{- range $name, $cred := . -}}
{{- if not $local.first -}}
{{- printf ", " -}}
{{- end -}}
{{- if $cred.token -}}
{{- printf "\"%s\": { \"auth\": \"%s\" }" $cred.url $cred.token -}}
{{- else -}}
{{- printf "\"%s\": { \"auth\": \"%s\" }" $cred.url (printf "%s:%s" $cred.user $cred.password | b64enc) -}}
{{- end -}}
{{- $_ := set $local "first" false -}}
{{- end -}}
{{- printf " } }" -}}
{{- end -}}

{{- define "okteto.hasEcrRegistry" -}}
{{- $local := dict "ecr" "false" -}}
{{- range $name, $cred := . -}}
{{- if hasSuffix ".amazonaws.com" $cred.url -}}
{{- $_ := set $local "ecr" "true" -}}
{{- end -}}
{{- end -}}
{{- printf "%s" $local.ecr -}}
{{- end -}}

{{- define "okteto.ecrURL" -}}
{{- range $name, $cred := . -}}
{{- if hasSuffix ".amazonaws.com" $cred.url -}}
{{- printf "%s" $cred.url -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "okteto.ecrRegion" -}}
{{- range $name, $cred := . -}}
{{- if hasSuffix ".amazonaws.com" $cred.url -}}
{{- $parts := split "." $cred.url -}}
{{- printf "%s" $parts._3 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "okteto.ecrAccessKey" -}}
{{- range $name, $cred := . -}}
{{- if hasSuffix ".amazonaws.com" $cred.url -}}
{{- printf "%s" $cred.user -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "okteto.ecrSecretKey" -}}
{{- range $name, $cred := . -}}
{{- if hasSuffix ".amazonaws.com" $cred.url -}}
{{- printf "%s" $cred.password -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for MutatingWebhookConfiguration.
*/}}
{{- define "okteto.mutatingWebhookConfiguration.apiVersion" -}}
{{- if semverCompare "<1.19-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "admissionregistration.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "admissionregistration.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkPolicies.
*/}}
{{- define "okteto.networkPolicies.apiVersion" -}}
{{- if semverCompare "<1.16-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
The default public URL of buildkit
*/}}
{{- define "okteto.buildkit" -}}
{{- if and .Values.buildkit.ingress.enabled .Values.ingress.tlsSecret -}}
{{- printf "%s.%s" "okteto" .Values.subdomain }}
{{- else -}}
{{- printf "%s.%s" "buildkit" .Values.subdomain }}
{{- end -}}
{{- end -}}

{{- define "okteto.registry" -}}
{{- printf "%s.%s" "registry" .Values.subdomain }}
{{- end -}}

{{- define "okteto.privateEndpoints" -}}
{{- printf "%s.%s" "private-endpoints" .Values.subdomain }}
{{- end -}}

{{/*
  Returns true if a solver is configured
*/}}
{{- define "okteto.solverAvailable" -}}
{{- if not .Values.cloud.enabled }}
{{- print false }}
{{- else if .Values.cloud.provider.azure.enabled }}
{{- print true }}
{{- else if .Values.cloud.provider.aws.enabled }}
{{- print true }}
{{- else if .Values.cloud.provider.gcp.enabled }}
{{- print true }}
{{- else if .Values.cloud.provider.digitalocean.enabled }}
{{- print true }}
{{- else if .Values.cloud.provider.civo.enabled }}
{{- print true }}
{{- else if .Values.cloud.provider.byo.enabled }}
{{- print true }}
{{- else }}
{{- print false }}
{{- end -}}
{{- end -}}

{{- define "okteto.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "okteto.fullname" .) }}
{{- end -}}

{{- define "okteto.rootCAIssuer" -}}
{{ printf "%s-ca" (include "okteto.fullname" .) }}
{{- end -}}

{{- define "okteto.rootCACertificate" -}}
{{ printf "%s-ca" (include "okteto.fullname" .) }}
{{- end -}}

{{- define "okteto.internalCertificate" -}}
{{ printf "%s-internal-tls" (include "okteto.fullname" .) }}
{{- end -}}

{{- define "okteto.installDaemonset" -}}
{{- if .Values.prepullImages.enabled }}
{{- print true }}
{{- else if .Values.overrideRegistryResolution.enabled }}
{{- print true }}
{{- else if .Values.overrideFileWatchers.enabled }}
{{- print true }}
{{- else if .Values.injectDevelopmentBinaries.enabled }}
{{- print true }}
{{- else if .Values.privateRegistry }}
{{- print true }}
{{- else }}
{{- print false }}
{{- end -}}
{{- end -}}

{{- define "okteto.ingress.tlsSecret" -}}
{{- if .Values.ingress.tlsSecret }}
{{- print .Values.ingress.tlsSecret }}
{{- else }}
{{- print .Values.wildcardCertificate.name }}
{{- end -}}
{{- end -}}

{{- define "okteto.registry.tlsSecret" -}}
{{- if .Values.registry.ingress.tlsSecret }}
{{- print .Values.registry.ingress.tlsSecret }}
{{- else }}
{{- print .Values.wildcardCertificate.name }}
{{- end -}}
{{- end -}}

{{/*
  Returns the name of the cloud provider
*/}}
{{- define "okteto.cloudProvider" -}}
{{- if not .Values.cloud.enabled }}
{{- print "n/a" }}
{{- else if .Values.cloud.provider.azure.enabled }}
{{- print "azure" }}
{{- else if .Values.cloud.provider.aws.enabled }}
{{- print "aws" }}
{{- else if .Values.cloud.provider.gcp.enabled }}
{{- print "gcp" }}
{{- else if .Values.cloud.provider.digitalocean.enabled }}
{{- print "digitalocean" }}
{{- else if .Values.cloud.provider.civo.enabled }}
{{- print "civo" }}
{{- else if .Values.cloud.provider.byo.enabled }}
{{- print "byo" }}
{{- else }}
{{- print "n/a" }}
{{- end -}}
{{- end -}}

{{/*
  Returns the name of the auth provider
*/}}
{{- define "okteto.authProvider" -}}
{{- if .Values.auth.google.enabled }}
{{- print "google" }}
{{- else if .Values.auth.github.enabled }}
{{- print "github" }}
{{- else if .Values.auth.bitbucket.enabled }}
{{- print "bitbucket" }}
{{- else if .Values.auth.openid.enabled }}
{{- print "openid" }}
{{- else if .Values.auth.token.enabled }}
{{- print "token" }}
{{- else }}
{{- print "n/a" }}
{{- end -}}
{{- end -}}

{{- define "okteto.tlsSecretsToReload" -}}
{{- if .Values.wildcardCertificate.privateCA.enabled }}
{{- printf "%s,%s" .Values.wildcardCertificate.name .Values.wildcardCertificate.privateCA.secret.name }}
{{- else }}
{{- print .Values.wildcardCertificate.name}}
{{- end -}}
{{- end -}}
