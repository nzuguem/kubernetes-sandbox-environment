#!/usr/bin/env bash
# One-shot environment setup (runs once, when the container is created).

set -euo pipefail

# The mise-data-volume is created root-owned
sudo chown -R vscode:vscode "$MISE_DATA_DIR"
mise trust --yes .
mise install --verbose
mise run env:setup
