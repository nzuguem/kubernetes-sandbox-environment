#!/bin/bash

set -ex

# Sourcing of fzf
echo "source <(fzf --bash)" >> /home/vscode/.bashrc

task pre-commit-install

task cluster-kind-deploy

task platform-install