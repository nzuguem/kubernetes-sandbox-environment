#!/bin/bash

set -e

task env:configure:shell
task pre-commit-install
task start-code-server
task cluster-kind-deploy
task platform-install-with-gitops-mode
