#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="${ZMK_WORKSPACE:-${REPO_ROOT}/.zmk-workspace}"
ZMK_DIR="${ZMK_DIR:-${WORKSPACE_DIR}/zmk}"
ZMK_REPO="${ZMK_REPO:-https://github.com/zmkfirmware/zmk.git}"
ZMK_REF="${ZMK_REF:-main}"
ZMK_MANIFEST_FILE="${ZMK_MANIFEST_FILE:-app/west.yml}"
ZMK_VENV_DIR="${ZMK_VENV_DIR:-${WORKSPACE_DIR}/.venv}"

echo "Using workspace: ${WORKSPACE_DIR}"
mkdir -p "${WORKSPACE_DIR}"

if [ ! -d "${ZMK_DIR}/.git" ]; then
  echo "Cloning ZMK into ${ZMK_DIR} (ref: ${ZMK_REF})..."
  git clone --branch "${ZMK_REF}" --single-branch "${ZMK_REPO}" "${ZMK_DIR}"
else
  echo "ZMK repo already present at ${ZMK_DIR}; skipping clone."
fi

if [ ! -f "${ZMK_VENV_DIR}/bin/activate" ]; then
  echo "Creating Python virtual environment at ${ZMK_VENV_DIR}..."
  python3 -m venv "${ZMK_VENV_DIR}"
fi

# shellcheck disable=SC1090
source "${ZMK_VENV_DIR}/bin/activate"
pip install --upgrade pip
pip install --upgrade west

cd "${WORKSPACE_DIR}"

if [ ! -d ".west" ]; then
  if [ ! -f "${ZMK_DIR}/${ZMK_MANIFEST_FILE}" ]; then
    echo "Manifest file not found: ${ZMK_DIR}/${ZMK_MANIFEST_FILE}"
    exit 1
  fi
  echo "Initializing west workspace from ${ZMK_DIR}/${ZMK_MANIFEST_FILE}..."
  west init -l "${ZMK_DIR}" --mf "${ZMK_MANIFEST_FILE}"
else
  echo "West workspace already initialized; skipping init."
fi

echo "Updating west modules..."
west update

echo "Exporting Zephyr CMake package..."
west zephyr-export

echo "Installing Python dependencies via west..."
west packages pip --install

echo "Bootstrap complete."
echo "If you have a zmk-config repo, point builds at it with -c <path>."
