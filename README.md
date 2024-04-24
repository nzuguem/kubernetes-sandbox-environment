# Kubernetes Stack
## Késako ?
Fully isolated Kubernetes environment (*container level via **[VS Code DevContainer][vs-code-dev-container-doc]***), for try and test components of the Kubernetes ecosystem.

It contains configurations and examples for the following components:
- Ingress
    - [Nginx](ingress/nginx)
- GitOps
    - [ArgoCD](gitops/argocd)
- Observability
    - [OpenTelemetry](observability/otel)
    - [Coroot](observability/coroot)

## Launch DevContainer
There are 2 ways to start the environment:
- Local with VS Code
- GitHub CodeSpace

## Manage cluster in DevContainer
### [Kind][kind-doc]
- Start cluster

> ℹ️ Cluster deployed after devContainer startup

```bash
## Deploy CLuster
make cluster-kind-deploy

## Assert 🎉🎉🎉
kubectl cluster-info --context kind-kubernetes-stack 
```

- Delete cluster

> ℹ️ The DevContainer associated with this environment is deleted when the VS Code Dev Container mode is disconnected.

```bash
make cluster-kind-undeploy
```
 
<!-- Links -->
[kind-doc]:https://kind.sigs.k8s.io/
[vs-code-dev-container-doc]: https://code.visualstudio.com/docs/devcontainers/containers