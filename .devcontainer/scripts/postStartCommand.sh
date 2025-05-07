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

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

### Enable KUBERC (v1.33 [Alpha])
export KUBECTL_KUBERC=true
EOF

# Configure task completion
sudo sh -c 'task --completion bash > /etc/bash_completion.d/task'

# Install Helm Plugins
helm plugin install https://github.com/databus23/helm-diff

# Deploy and configure cluster
task cluster-kind-deploy

# Configure KUBERC
# Default config file -> $HOME/.kube/kuberc
cp $PWD/kuberc $HOME/.kube/

task platform-install-with-gitops-mode

# Install pre-commit
task pre-commit-install
