#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

URL="http://${MINERU_CHECK_HOST}:${MINERU_PORT}/openapi.json"

echo "Checking ${URL}"
curl --fail --silent --show-error "${URL}" >/dev/null
echo "MinerU API is reachable."
