#!/bin/bash
# SPDX-SnippetBegin
# SPDX-License-Identifier: Apache License 2.0
# SPDX-SnippetCopyrightText: 2024 © Argo Project, argoproj/argo-helm
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd
## Reference: https://github.com/norwoodj/helm-docs
set -eux
HELM_DOCS_VERSION="1.14.2"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "Repo root: $REPO_ROOT"

echo "Running helm-docs"
# Each chart's README.md is generated from its charts/<chart>/README.md.gotmpl
# template, which lets us keep hand-written sections (e.g. the custom callbacks
# guide in charts/litellm/README.md.gotmpl) alongside the auto-generated values
# table. Passing --template-files makes that template an explicit input rather
# than relying on helm-docs' implicit default.
docker run --rm \
    -v "$REPO_ROOT:/helm-docs" \
    -u $(id -u) \
    jnorwood/helm-docs:v$HELM_DOCS_VERSION \
    --template-files=README.md.gotmpl