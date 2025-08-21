# Litellm Helm Chart

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Artifact Hub](https://artifacthub.io/packages/helm/litellm-helm/litellm)

This contains a helm chart for litellm based on <https://github.com/Unique-AG/helm-charts> with various improvements - like rollouts for new configuration and pod disruption budgets

The chart is available both as Helm Repository as well as OCI artefact.

```sh
helm repo add litellm-helm https://RichardoC.github.io/litellm_helm-chart/
helm install my-litellm litellm-helm/litellm --version <version>

# or
helm install litellm-helm oci://ghcr.io/richardoc/litellm_helm-chart/litellm --version <version>
```

You can find comprehensive documentation for each chart in the `charts` directory or on [ArtifactHub](https://artifacthub.io/packages/helm/litellm-helm/litellm).

## Contributing

We'd love to have you contribute! Please refer to our [contribution guidelines](https://github.com/RichardoC/litellm_helm-chart/blob/main/CONTRIBUTING.md) for details.

### Changelog

Releases are managed independently for each helm chart, and changelogs are tracked on each release. Read more about this process [here](https://github.com/RichardoC/litellm_helm-chart/blob/main/CONTRIBUTING.md#changelog).

## License Notice

While being licensed under the Apache 2.0 license, the work in this repository is strongly inspired by others. Matching identifiers are provided in the source code where applicable. The original work is licensed under the Apache 2.0 license as well.

- [`argo-helm`](https://github.com/argoproj/argo-helm/tree/main)
- [`zitadel-charts`](https://github.com/zitadel/zitadel-charts)
- [`bitnami/charts`](https://github.com/bitnami/charts)
- [`Unique-AG/helm-charts`](https://github.com/Unique-AG/helm-charts)

> [!TIP]
> More often than not, the original work is modified to fit the needs of the project. The modifications are licensed under the Apache 2.0 license as well and are denoted in the file header as `SPDX-SnippetCopyrightText`.
