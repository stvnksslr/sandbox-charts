# Backstage

![Version: 0.6.0](https://img.shields.io/badge/Version-0.6.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: main](https://img.shields.io/badge/AppVersion-main-informational?style=flat-square)

Helm chart for Backstage. Backstage is an open platform for building developer portals.

## Installing the Chart

Before you can install the chart you will need to add the `mcwarman` repo to [Helm](https://helm.sh/).

```shell
helm repo add mcwarman https://mcwarman.github.io/helm-charts/
```

After you've installed the repo you can install the chart.

```shell
helm upgrade --install --namespace default --values ./my-values.yaml my-release mcwarman/backstage
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami/ | postgresql | 11.0.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override the name of the chart. |
| fullnameOverride | string | `""` | Override the fullname of the chart. |
| app.image.repository | string | `"ghcr.io/mcwarman/backstage-sample-app/app"` | App image repository. |
| app.image.tag | string | `""` |  |
| app.image.pullPolicy | string | `"IfNotPresent"` | App image pull policy. |
| app.image.pullSecrets | list | `[]` | App image pull secrets. |
| app.serviceAccount.create | bool | `true` | App if `true`, create a new service account. |
| app.serviceAccount.annotations | object | `{}` | App annotations to add to the service account |
| app.serviceAccount.name | string | `""` | App service account to be used. If not set and serviceAccount.create is true, a name is generated using the full name template. |
| app.autoscaling.enabled | bool | `false` | App if `true`, create a HPA for the deployment. |
| app.autoscaling.minReplicas | int | `1` | App minimum number of pod replicas. |
| app.autoscaling.maxReplicas | int | `3` | App maximum number of pod replicas. |
| app.autoscaling.targetCPUUtilizationPercentage | int | `60` | App target CPU utilisation for the pod. |
| app.autoscaling.targetMemoryUtilizationPercentage | string | `nil` | App target memory utilisation for the pod. |
| app.podDisruptionBudget.enabled | bool | `false` | App if `true`, create a PDB for the deployment. |
| app.podDisruptionBudget.minAvailable | int | `nil` | App set the PDB minimum available pods. |
| app.podDisruptionBudget.maxUnavailable | int | `nil` | App set the PDB maximum unavailable pods. |
| app.podAnnotations | object | `{}` | App annotations to add to the pod. |
| app.podLabels | object | `{}` | App labels to add to the pod. |
| app.securityContext | object | `{}` | App security context for the container. |
| app.podSecurityContext | object | `{}` | App security context for the pod. |
| app.priorityClassName | string | `""` | App priority class name to use. |
| app.livenessProbe | object | see values.yaml | The liveness probe. |
| app.readinessProbe | object | see values.yaml | App the readiness probe. |
| app.service.type | string | `"ClusterIP"` | App service type. |
| app.service.annotations | object | `{}` | App annotations to add to the service. |
| app.service.port | int | `80` | Service port. |
| app.ingress.enabled | bool | `false` | App if `true`, create an ingress object. |
| app.ingress.annotations | object | `{}` | App ingress annotations. |
| app.ingress.ingressClassName | string | `""` | App ingress class to use. |
| app.ingress.hosts | list | `[]` | App ingress hosts. |
| app.ingress.tls | list | `[]` | App ingress TLS configuration |
| app.resources | object | `{}` | App resource requests and limits for the clamav container. |
| app.replicaCount | int | `1` | App number of replicas to create. |
| app.nodeSelector | object | `{}` | App node labels for pod assignment. |
| app.tolerations | list | `[]` | App tolerations for pod assignment. |
| app.affinity | object | `{}` | App affinity for pod assignment. |
| app.env | list | `[]` | Frontend environment variables for the container. |
| backend.image.repository | string | `"ghcr.io/mcwarman/backstage-sample-app/backend"` | Backend image repository. |
| backend.image.tag | string | `""` |  |
| backend.image.pullPolicy | string | `"IfNotPresent"` | Backend image pull policy. |
| backend.image.pullSecrets | list | `[]` | Backend image pull secrets. |
| backend.serviceAccount.create | bool | `true` | Backend if `true`, create a new service account. |
| backend.serviceAccount.annotations | object | `{}` | Backend annotations to add to the service account |
| backend.serviceAccount.name | string | `""` | Backend service account to be used. If not set and serviceAccount.create is true, a name is generated using the full name template. |
| backend.autoscaling.enabled | bool | `false` | Backend if `true`, create a HPA for the deployment. |
| backend.autoscaling.minReplicas | int | `1` | Backend minimum number of pod replicas. |
| backend.autoscaling.maxReplicas | int | `3` | Backend maximum number of pod replicas. |
| backend.autoscaling.targetCPUUtilizationPercentage | int | `60` | Backend target CPU utilisation for the pod. |
| backend.autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Backend target memory utilisation for the pod. |
| backend.podDisruptionBudget.enabled | bool | `false` | Backend if `true`, create a PDB for the deployment. |
| backend.podDisruptionBudget.minAvailable | int | `nil` | Backend set the PDB minimum available pods. |
| backend.podDisruptionBudget.maxUnavailable | int | `nil` | Backend set the PDB maximum unavailable pods. |
| backend.podAnnotations | object | `{}` | Backend annotations to add to the pod. |
| backend.podLabels | object | `{}` | Backend labels to add to the pod. |
| backend.securityContext | object | `{}` | Backend security context for the container. |
| backend.podSecurityContext | object | `{}` | Backend security context for the pod. |
| backend.priorityClassName | string | `""` | Backend priority class name to use. |
| backend.livenessProbe | object | see values.yaml | The liveness probe. |
| backend.readinessProbe | object | see values.yaml | Backend the readiness probe. |
| backend.service.type | string | `"ClusterIP"` | Backend service type. |
| backend.service.annotations | object | `{}` | Backend annotations to add to the service. |
| backend.service.port | int | `80` | Service port. |
| backend.ingress.enabled | bool | `false` | Backend if `true`, create an ingress object. |
| backend.ingress.annotations | object | `{}` | Backend ingress annotations. |
| backend.ingress.ingressClassName | string | `""` | Backend ingress class to use. |
| backend.ingress.hosts | list | `[]` | Backend ingress hosts. |
| backend.ingress.tls | list | `[]` | Backend ingress TLS configuration |
| backend.resources | object | `{}` | Backend resource requests and limits for the clamav container. |
| backend.replicaCount | int | `1` | Backend number of replicas to create. |
| backend.nodeSelector | object | `{}` | Backend node labels for pod assignment. |
| backend.tolerations | list | `[]` | Backend tolerations for pod assignment. |
| backend.affinity | object | `{}` | Backend affinity for pod assignment. |
| backend.env | list | `[]` | Backend environment variables for the container. |
| psql | string | `nil` | Settings are only required if you wish to use an existing postgresql instance |
| postgresql.enabled | bool | `false` | If `true`, executes subchart PostgreSQL from Bitnami, [reference](https://artifacthub.io/packages/helm/bitnami/postgresql). |
| appConfig | object | see values.yaml | Backstage application config, [reference](https://backstage.io/docs/conf/writing). |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
