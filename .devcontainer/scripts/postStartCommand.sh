#!/bin/bash

set -e

task env:configure:shell
task lazyvim:install
task mise:global:install
task pre-commit-install
task cluster-kind-deploy
task platform-install-with-gitops-mode
# task start:firefox
# task start-code-server
