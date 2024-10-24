#!/bin/bash

set -e

# Sourcing of fzf
echo "source <(fzf --bash)" >> /home/vscode/.bashrc
echo "alias k=kubectl" >> /home/vscode/.bashrc

task cluster-kind-deploy

# task platform-install
task platform-install-with-gitops-mode

task pre-commit-install
