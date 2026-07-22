# litellm

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.75.5-stable](https://img.shields.io/badge/AppVersion-v1.75.5--stable-informational?style=flat-square)

The 'litellm' chart provides a solution for deploying LiteLLM proxy with helm.

It is a refined version of the original [litellm](https://github.com/BerriAI/litellm/tree/main/deploy/charts/litellm-helm) chart.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Richardo-C |  | <https://github.com/RichardoC> |

## Custom callbacks / extra files in the config directory

LiteLLM resolves callback modules referenced in `litellm_settings.callbacks` relative to the directory containing `config.yaml` (i.e. `/etc/litellm`). To ship custom hook/handler `.py` files, set `configDirExtraFiles` (keyed by filename). The chart renders them into a ConfigMap (with a content-hashed name) and projects it into `/etc/litellm` alongside `config.yaml`, so no extra `volumeMounts` are needed, and any change rolls out the Deployment automatically.

You almost certainly don't want Python source inlined in your YAML. Keep each handler as a real `.py` file and load it at install time with Helm's `--set-file`, which reads the file's contents into the value:

```console
$ helm upgrade --install litellm oci://ghcr.io/richardoc/litellm_helm-chart/litellm \
    --values values.yaml \
    --set-file 'configDirExtraFiles.my_handler\.py=./hooks/my_handler.py'
```

Then reference the module from your config:

```yaml
proxy_config:
  litellm_settings:
    callbacks: ["my_handler.proxy_handler_instance"]
```

`--set-file` also works through orchestrators that pass Helm flags — e.g. Tilt's [`helm_resource`](https://github.com/tilt-dev/tilt-extensions/tree/master/helm_resource) via `flags=['--set-file', 'configDirExtraFiles.my_handler\\.py=./hooks/my_handler.py']`. (Inlining the contents directly under `configDirExtraFiles` in a values file is also supported, e.g. for tooling that can't pass `--set-file`.)

**Notes:**

- Filenames must not collide with `config.yaml`.
- The rendered files are folded into a `checksum/config-dir-extra` pod annotation (and the ConfigMap name is content-hashed), so changing them rolls out the Deployment automatically.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| configDirExtraFiles | object | `{}` | Custom files to drop into the proxy config directory (/etc/litellm) alongside config.yaml — e.g. callback/hook .py modules referenced from litellm_settings.callbacks. LiteLLM resolves those modules relative to the config file's directory, so they must live next to config.yaml. Keys are filenames, values are the file contents. The chart renders these into a ConfigMap (content-hashed name) and projects it into /etc/litellm (no extra mount paths needed), and folds their contents into a `checksum/config-dir-extra` pod annotation, so changes roll out the Deployment automatically. Filenames must not collide with `config.yaml`. Rather than inlining source here, prefer keeping each handler as a real file and loading it at install time with `helm --set-file 'configDirExtraFiles.my_handler\.py=./hooks/my_handler.py'`. |
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
| startupProbe.failureThreshold | int | `18` |  |
| startupProbe.httpGet.path | string | `"/health/readiness"` |  |
| startupProbe.httpGet.port | string | `"http"` |  |
| startupProbe.periodSeconds | int | `10` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
