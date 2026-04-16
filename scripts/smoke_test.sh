#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /absolute/path/to/sample.pdf" >&2
  exit 1
fi

PDF_PATH="$1"
if [[ ! -f "${PDF_PATH}" ]]; then
  echo "PDF not found: ${PDF_PATH}" >&2
  exit 1
fi

WORK_DIR="$(mktemp -d "${ROOT_DIR}/tmp/smoke.XXXXXX")"
ZIP_PATH="${WORK_DIR}/result.zip"
UNZIP_DIR="${WORK_DIR}/unzipped"
mkdir -p "${UNZIP_DIR}"

echo "Submitting PDF to MinerU: ${PDF_PATH}"
curl --fail --silent --show-error \
  -F "files=@${PDF_PATH};type=application/pdf" \
  -F "backend=pipeline" \
  -F "parse_method=auto" \
  -F "formula_enable=true" \
  -F "table_enable=true" \
  -F "return_md=true" \
  -F "return_middle_json=true" \
  -F "return_model_output=true" \
  -F "return_content_list=true" \
  -F "return_images=true" \
  -F "response_format_zip=true" \
  "http://${MINERU_CHECK_HOST}:${MINERU_PORT}/file_parse" \
  -o "${ZIP_PATH}"

unzip -q "${ZIP_PATH}" -d "${UNZIP_DIR}"

CONTENT_JSON="$(find "${UNZIP_DIR}" -type f -name '*_content_list.json' | head -n 1)"
if [[ -z "${CONTENT_JSON}" ]]; then
  echo "Smoke test failed: content_list.json was not found in the returned ZIP." >&2
  exit 1
fi

echo "Found content list: ${CONTENT_JSON}"

TABLE_COUNT="$(grep -c '"type"[[:space:]]*:[[:space:]]*"table"' "${CONTENT_JSON}" || true)"
TABLE_BODY_COUNT="$(grep -c '"table_body"[[:space:]]*:' "${CONTENT_JSON}" || true)"

echo "table blocks: ${TABLE_COUNT}"
echo "table_body fields: ${TABLE_BODY_COUNT}"
echo "Smoke test artifacts: ${WORK_DIR}"
