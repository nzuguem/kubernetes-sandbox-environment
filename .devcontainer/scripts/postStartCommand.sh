#!/bin/bash

set -e

# Configure Bash
cat <<EOF >> /home/vscode/.bashrc

## Completion
source <(fzf --bash)
source <(argocd completion bash)
source <(pluto completion bash --no-footer)

## Aliases
### Using ArgoCD CLI on Core Mode (https://docs.openshift.com/gitops/1.12/gitops_cli_argocd/argocd-gitops-cli-reference.html#core-mode)
alias argocd="KUBECONFIG=$HOME/.kube/config-argocd argocd --core"
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
