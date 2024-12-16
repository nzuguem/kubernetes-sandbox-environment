#!/bin/bash

set -e

# Configure Bash
echo "source <(fzf --bash)" >> /home/vscode/.bashrc
echo "alias k=kubectl" >> /home/vscode/.bashrc
echo 'complete -o default -F __start_kubectl k' >> /home/vscode/.bashrc
sudo sh -c 'task --completion bash > /etc/bash_completion.d/task'

# Deploy and configure cluster
task cluster-kind-deploy
task platform-install-with-gitops-mode

# Install pre-commit
task pre-commit-install
