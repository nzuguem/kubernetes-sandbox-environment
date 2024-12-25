# Kubernetes Stack

## Késako ?

Fully isolated Kubernetes environment (*container level via **[VS Code DevContainer][vs-code-dev-container-doc]***), for try and test components of the Kubernetes ecosystem.

It contains configurations and examples for the following components:

- Ingress
  - [Nginx](ingress/nginx)
  - [Ngrok](ingress/ngrok)
- Gateway
  - [Nginx](gateway/nginx)
- GitOps
  - [ArgoCD](gitops/argocd)
- Observability
  - [OpenTelemetry](observability/otel)
  - [Coroot](observability/coroot)
  - [Prometheus](observability/prometheus)
- Security
  - [Cert Manager](security/cert-manager)
  - [External Secrets Operator](security/ESO)
  - [Falco](security/falco)
  - [Neuvector](security/neuvector)
  - [Sealed Secret](security/sealed-secret)
- Control Plane
  - [Crossplane](platform/crossplane)
- Serverless
  - [Knative](serverless/knative)
- Discovery
  - [Sidecar Container Support v1.29 [beta]](discovery/sidecar-container-support-1.29-beta)
  - [Ephemeral Container - v1.25 [stable]](discovery/ephemeral-container-1.25-stable)
  - [Use an Image Volume With a Pod - v1.31 [alpha]](discovery/image-volume-with-pod-1.31-alpha)
  - [Temporal IO](discovery/temporal)

## Launch DevContainer

> 📌 **prerequisite :**
>
> - Docker
> - VS Code

### Open in Visual Studio Code ⤵️

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/nzuguem/kubernetes-sandbox-environment)

### Troubleshooting

From my experience at this sandbox, 90% of its boot failures were due to ports on my host machine already in use.

Make sure that the following ports are available :

- `80` : Ingress Controller Nginx - HTTP
- `443`: Ingress Controller Nginx - HTTPS
- `8080`: Kourier for Knative - HTTP
- `8443`: Kourier for Knative - HTTPS
- `9080`: Nginx Gateway Fabric - HTTP
- `9443`: Nginx Gateway Fabric - HTTPS

Execute the command `lsof -i:<PORT>` to identify the PID occupying one of these ports. Then execute the command `kill -9 <PID>` to kill the process

## Manage cluster in DevContainer

### [Kind][kind-doc]

- Start cluster

> ℹ️ Cluster deployed after devContainer startup

```bash
## Deploy CLuster
task cluster-kind-deploy
```

- Delete cluster

> ℹ️ The DevContainer associated with this environment is deleted when the VS Code Dev Container mode is disconnected.

```bash
task cluster-kind-undeploy
```

## Try [Gitpod Flex][gitpod-flex-introduction]

⏳⏳⏳

<!-- Links -->
[kind-doc]:https://kind.sigs.k8s.io/
[vs-code-dev-container-doc]: https://code.visualstudio.com/docs/devcontainers/containers
[gitpod-flex-introduction]: https://www.gitpod.io/docs/flex/introduction
