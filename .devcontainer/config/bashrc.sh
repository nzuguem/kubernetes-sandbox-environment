# Sandbox shell configuration, sourced from ~/.bashrc (see `mise run env:shell:configure`).
# Keep this file idempotent: it is evaluated by every new shell.

export PATH="/usr/local/krew/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

command -v mise >/dev/null && eval "$(mise activate bash)" && source <(mise completion bash)
command -v fzf >/dev/null && source <(fzf --bash)
command -v argocd >/dev/null && source <(argocd completion bash)
command -v pluto >/dev/null && source <(pluto completion bash)

alias kubectl=kubecolor
alias k=kubectl
alias argocd="KUBECONFIG=$HOME/.kube/config-argocd argocd --core"
complete -o default -F __start_kubectl k

# Per-component environment written by install tasks (vault, temporal, ...)
for f in "$HOME"/.sandbox.d/*.sh; do
  [ -r "$f" ] && source "$f"
done
unset f
