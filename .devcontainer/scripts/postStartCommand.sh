#!/usr/bin/env bash
# Runs on every container start: (re)create the Kind cluster and the GitOps platform.

set -euo pipefail

mise run cluster:create
mise run platform:gitops:install
mise run sandbox:socks-proxy:start
# mise run sandbox:code-server:start
