#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="${ZMK_WORKSPACE:-${REPO_ROOT}/.zmk-workspace}"
ZMK_DIR="${ZMK_DIR:-${WORKSPACE_DIR}/zmk}"
BUILD_ROOT="${BUILD_ROOT:-${WORKSPACE_DIR}/build}"
EXTRA_MODULES="${ZMK_EXTRA_MODULES:-${REPO_ROOT}}"
ZMK_VENV_DIR="${ZMK_VENV_DIR:-${WORKSPACE_DIR}/.venv}"

usage() {
  echo "Usage: $0 -b <board> -s \"<shield list>\" -c <zmk-config-dir> [-d <build-dir>]"
  echo "Example: $0 -b nice_nano_v2 -s \"kyria_left nice_view_adapter nice_view_gem\" -c /workspaces/zmk-config/config"
}

DEFAULT_CONFIG_DIR="${ZMK_CONFIG_DIR:-}"
if [ -z "${DEFAULT_CONFIG_DIR}" ]; then
  for candidate in /workspaces/zmk-config/config /home/carlos/code/zmk_config/zmk-config/config; do
    if [ -d "${candidate}" ]; then
      DEFAULT_CONFIG_DIR="${candidate}"
      break
    fi
  done
fi

BOARD=""
SHIELD=""
CONFIG_DIR=""
OUT_DIR=""

while getopts ":b:s:c:d:h" opt; do
  case "${opt}" in
    b) BOARD="${OPTARG}" ;;
    s) SHIELD="${OPTARG}" ;;
    c) CONFIG_DIR="${OPTARG}" ;;
    d) OUT_DIR="${OPTARG}" ;;
    h) usage; exit 0 ;;
    :) echo "Option -${OPTARG} requires an argument."; usage; exit 1 ;;
    \?) echo "Unknown option: -${OPTARG}"; usage; exit 1 ;;
  esac
done

if [ -z "${CONFIG_DIR}" ] && [ -n "${DEFAULT_CONFIG_DIR}" ]; then
  CONFIG_DIR="${DEFAULT_CONFIG_DIR}"
fi

if [ -z "${BOARD}" ] || [ -z "${SHIELD}" ] || [ -z "${CONFIG_DIR}" ]; then
  usage
  exit 1
fi

if [ ! -d "${ZMK_DIR}/app" ]; then
  echo "ZMK app not found at ${ZMK_DIR}/app. Run: bash scripts/bootstrap-zmk.sh"
  exit 1
fi

if [ ! -d "${WORKSPACE_DIR}/.west" ]; then
  echo "West workspace not found at ${WORKSPACE_DIR}/.west. Run: bash scripts/bootstrap-zmk.sh"
  exit 1
fi

if [ ! -f "${ZMK_VENV_DIR}/bin/activate" ]; then
  echo "Python virtual environment not found at ${ZMK_VENV_DIR}. Run: bash scripts/bootstrap-zmk.sh"
  exit 1
fi

if [ ! -d "${CONFIG_DIR}" ]; then
  echo "ZMK config directory not found: ${CONFIG_DIR}"
  exit 1
fi

mkdir -p "${BUILD_ROOT}"

if [ -z "${OUT_DIR}" ]; then
  SAFE_BOARD="${BOARD//@/_}"
  OUT_DIR="${BUILD_ROOT}/${SAFE_BOARD}"
fi

echo "Building ZMK firmware..."
echo "- Board: ${BOARD}"
echo "- Shield(s): ${SHIELD}"
echo "- Config: ${CONFIG_DIR}"
echo "- Extra modules: ${EXTRA_MODULES}"
echo "- Output dir: ${OUT_DIR}"

# shellcheck disable=SC1090
source "${ZMK_VENV_DIR}/bin/activate"
export ZEPHYR_PYTHON="${ZMK_VENV_DIR}/bin/python"

cd "${WORKSPACE_DIR}"

west build -p auto \
  -s "${ZMK_DIR}/app" \
  -d "${OUT_DIR}" \
  -b "${BOARD}" \
  -- \
  -DSHIELD="${SHIELD}" \
  -DZMK_CONFIG="${CONFIG_DIR}" \
  -DZMK_EXTRA_MODULES="${EXTRA_MODULES}"

echo "Build complete: ${OUT_DIR}"
