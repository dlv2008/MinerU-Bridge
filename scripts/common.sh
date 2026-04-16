#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

mkdir -p "${ROOT_DIR}/config" "${ROOT_DIR}/logs" "${ROOT_DIR}/output" "${ROOT_DIR}/tmp"

if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
fi

export MINERU_HOST="${MINERU_HOST:-0.0.0.0}"
export MINERU_PORT="${MINERU_PORT:-8886}"
export MINERU_MODEL_SOURCE="${MINERU_MODEL_SOURCE:-modelscope}"
export MINERU_API_MAX_CONCURRENT_REQUESTS="${MINERU_API_MAX_CONCURRENT_REQUESTS:-1}"
export MINERU_API_TASK_RETENTION_SECONDS="${MINERU_API_TASK_RETENTION_SECONDS:-86400}"
export MINERU_API_TASK_CLEANUP_INTERVAL_SECONDS="${MINERU_API_TASK_CLEANUP_INTERVAL_SECONDS:-300}"
export MINERU_API_ENABLE_FASTAPI_DOCS="${MINERU_API_ENABLE_FASTAPI_DOCS:-true}"
export MINERU_FORMULA_ENABLE="${MINERU_FORMULA_ENABLE:-true}"
export MINERU_TABLE_ENABLE="${MINERU_TABLE_ENABLE:-true}"
export MINERU_ENABLE_VLM_PRELOAD="${MINERU_ENABLE_VLM_PRELOAD:-false}"
export MINERU_TOOLS_CONFIG_JSON="${MINERU_TOOLS_CONFIG_JSON:-${ROOT_DIR}/config/mineru.json}"
export MINERU_API_OUTPUT_ROOT="${MINERU_API_OUTPUT_ROOT:-${ROOT_DIR}/output}"
export MINERU_CHECK_HOST="${MINERU_CHECK_HOST:-${MINERU_HOST}}"

if [[ "${MINERU_CHECK_HOST}" == "0.0.0.0" ]]; then
  export MINERU_CHECK_HOST="127.0.0.1"
fi

VENV_BIN="${ROOT_DIR}/.venv/bin"

ensure_uv() {
  if ! command -v uv >/dev/null 2>&1; then
    echo "uv is required but was not found in PATH." >&2
    echo "Install uv first, then rerun this script." >&2
    exit 1
  fi
}

ensure_sync() {
  if [[ ! -x "${VENV_BIN}/python" ]]; then
    echo "Virtual environment is missing. Run ./scripts/install.sh first." >&2
    exit 1
  fi
}

run_uv() {
  ensure_uv
  (cd "${ROOT_DIR}" && uv run "$@")
}
