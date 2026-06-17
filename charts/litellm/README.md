# litellm

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.75.5-stable](https://img.shields.io/badge/AppVersion-v1.75.5--stable-informational?style=flat-square)

The 'litellm' chart provides a solution for deploying LiteLLM proxy with helm.

It is a refined version of the original [litellm](https://github.com/BerriAI/litellm/tree/main/deploy/charts/litellm-helm) chart.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Richardo-C |  | <https://github.com/RichardoC> |

## Custom callbacks / extra files in the config directory

LiteLLM resolves callback modules referenced in `litellm_settings.callbacks` relative to the directory containing `config.yaml` (i.e. `/etc/litellm`). This chart mounts `/etc/litellm` as a projected volume, so you can merge extra ConfigMap sources into the same directory without adding extra `volumeMounts`.

Create a ConfigMap with your callback file(s), then reference it via `configDirExtraConfigMaps`:

```yaml
configDirExtraConfigMaps:
  - name: litellm-callbacks
    items:
      - key: my_handler.py
        path: my_handler.py
```

**Notes:**

- The `path` values must not collide with `config.yaml` or with each other. If two sources target the same path, the pod will fail to be created.
- These ConfigMaps are created and managed separately from this chart. Their contents are folded into a `checksum/config-dir-extra` pod annotation (read via `lookup`), so `helm upgrade` rolls out the Deployment when they change. Where `lookup` is unavailable (e.g. `helm template`/`--dry-run`, or GitOps tooling that disables it) a content-only change is not detected — use a reloader or roll out the Deployment manually in that case.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| configDirExtraConfigMaps | list | `[]` | Additional ConfigMap sources merged into the proxy config directory (/etc/litellm) alongside config.yaml. Use this to ship custom callback/hook .py files referenced from litellm_settings.callbacks — LiteLLM resolves those modules relative to the config file's directory. Mounted via a projected volume, so no extra mount paths are needed. Each entry references an existing ConfigMap by name; create that ConfigMap separately. Avoid path collisions: the projected `path` values must not collide with `config.yaml` or each other, or the pod will fail to start. Changes to these ConfigMaps are folded into a `checksum/config-dir-extra` pod annotation (their contents are read via `lookup`), so `helm upgrade` rolls out the Deployment when they change — except where `lookup` is unavailable (e.g. `helm template`/`--dry-run` or GitOps tools that disable it), in which case use a reloader or roll out manually. |
| env.LITELLM_LOG | string | `"ERROR"` |  |
| env.LITELLM_MODE | string | `"PRODUCTION"` |  |
| envFromSecretRefs | list | `[]` | List of secrets to be used as environment variables for the proxy |
| extraObjects | list | `[]` | List of extra objects to be created, will be templated |
| fullnameOverride | string | `""` |  |
| hooks.migration.command | string | `"python litellm/proxy/prisma_migration.py\n"` |  |
| hooks.migration.enabled | bool | `true` |  |
| hooks.migration.resources | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/berriai/litellm-database"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/health/liveliness"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| nameOverride | string | `"litellm"` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.create | bool | `false` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| proxy_config.general_settings.alerting | list | `[]` |  |
| proxy_config.general_settings.database_connection_pool_limit | int | `10` |  |
| proxy_config.general_settings.disable_error_logs | bool | `false` |  |
| proxy_config.general_settings.disable_spend_logs | bool | `false` |  |
| proxy_config.general_settings.master_key | string | `"os.environ/PROXY_MASTER_KEY"` |  |
| proxy_config.general_settings.proxy_batch_write_at | int | `60` |  |
| proxy_config.litellm_settings.json_logs | bool | `true` |  |
| proxy_config.litellm_settings.request_timeout | int | `600` |  |
| proxy_config.litellm_settings.set_verbose | bool | `false` |  |
| proxy_config.model_list[0].litellm_params.api_base | string | `"https://exampleopenaiendpoint-production.up.railway.app/"` |  |
| proxy_config.model_list[0].litellm_params.api_key | string | `"fake-key"` |  |
| proxy_config.model_list[0].litellm_params.model | string | `"openai/fake"` |  |
| proxy_config.model_list[0].model_name | string | `"fake-openai-endpoint"` |  |
| readinessProbe.httpGet.path | string | `"/health/readiness"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| secretFrom | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `4000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.create | bool | `false` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
