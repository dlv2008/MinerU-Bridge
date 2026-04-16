#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

ensure_sync

echo "Model source: ${MINERU_MODEL_SOURCE}"
echo "Config file: ${MINERU_TOOLS_CONFIG_JSON}"
echo "The official MinerU downloader may prompt for model selection."

run_uv mineru-models-download "$@"

echo
echo "Model download finished."
echo "If you downloaded local models successfully, set MINERU_MODEL_SOURCE=local in ${ROOT_DIR}/.env"
