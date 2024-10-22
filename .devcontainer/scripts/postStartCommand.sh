#!/bin/bash

set -e

# Sourcing of fzf
echo "source <(fzf --bash)" >> /home/vscode/.bashrc
echo "alias k=kubectl" >> /home/vscode/.bashrc

task cluster-kind-deploy

task platform-install

task pre-commit-install
