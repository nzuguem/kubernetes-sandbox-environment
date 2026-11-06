#!/usr/bin/env bash
# One-shot environment setup (runs once, when the container is created).

set -euo pipefail

mise trust --yes .
mise install
mise run env:setup
