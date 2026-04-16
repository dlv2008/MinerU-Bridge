#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

ensure_uv

EXTRA_ARGS=()
for extra in "$@"; do
  EXTRA_ARGS+=("$extra")
done

echo "Installing official MinerU runtime into ${ROOT_DIR}/.venv ..."
(cd "${ROOT_DIR}" && uv sync --python 3.12 "${EXTRA_ARGS[@]}")

echo "Checking installed commands ..."
run_uv mineru-api --help >/dev/null
run_uv mineru --help >/dev/null
run_uv mineru-models-download --help >/dev/null

echo "Install completed."
echo "Next step: ./scripts/download_models.sh"
