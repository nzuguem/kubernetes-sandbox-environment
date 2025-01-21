#!/bin/bash

set -e

# Configure Bash
cat <<EOF >> /home/vscode/.bashrc
source <(fzf --bash)
alias kubectl=kubecolor
alias k=kubectl
complete -o default -F __start_kubectl k
export PATH="${KREW_ROOT:-/home/vscode/.krew}/bin:$PATH"
EOF
sudo sh -c 'task --completion bash > /etc/bash_completion.d/task'

# Deploy and configure cluster
task cluster-kind-deploy
task platform-install-with-gitops-mode

# Install pre-commit
task pre-commit-install
