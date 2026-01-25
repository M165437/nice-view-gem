#!/usr/bin/env bash
set -euo pipefail

echo "Devcontainer ready. Verifying key tools..."
west --version
cmake --version | head -n 1
ninja --version

echo ""
echo "Next steps inside the container:"
echo "1. Bootstrap ZMK (requires network): bash scripts/bootstrap-zmk.sh"
echo "2. Build with your config: bash scripts/build-local.sh -b <board> -s \"<shields>\" -c <zmk-config-dir>"
