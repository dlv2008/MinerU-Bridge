#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

ensure_sync

LOG_FILE="${ROOT_DIR}/logs/mineru-api.log"

echo "Starting official mineru-api on ${MINERU_HOST}:${MINERU_PORT}"
echo "Config: ${MINERU_TOOLS_CONFIG_JSON}"
echo "Output root: ${MINERU_API_OUTPUT_ROOT}"
echo "Log file: ${LOG_FILE}"

cd "${ROOT_DIR}"
uv run mineru-api \
  --host "${MINERU_HOST}" \
  --port "${MINERU_PORT}" 2>&1 | tee -a "${LOG_FILE}"
