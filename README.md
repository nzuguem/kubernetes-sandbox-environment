# Kubernetes Stack
## Késako ?
Fully isolated Kubernetes environment (*container level via **[VS Code DevContainer][vs-code-dev-container-doc]***), for try and test components of the Kubernetes ecosystem.

It contains configurations and examples for the following components:
- Ingress
    - [Nginx](ingress/nginx)
    - [Ngrok](ingress/ngrok)
- GitOps
    - [ArgoCD](gitops/argocd)
- Observability
    - [OpenTelemetry](observability/otel)
    - [Coroot](observability/coroot)
    - [Prometheus](observability/prometheus)
- Security
    - [Cert Manager](security/cert-manager)
    - [External Secrets Operator](security/ESO)
- Plaform
    - [Crossplane](platform/crossplane)
- Serverless
    - [Knative](serverless/knative)

## Launch DevContainer

> 📌 **The only prerequisite is to have Docker installed on your workstation**

To start the environment :

1. Clone this repo : `git clone https://github.com/nzuguem/kubernetes-sandbox-environment.git`
2. Open it in VS Code
3. `Shift`+ `Cmd` + `p`
    - Type : *`open in container`*
    - Choose ***`Dev Containers: Reopen in Container`***

### Troubleshooting
From my experience at this sandbox, 90% of its boot failures were due to ports on my host machine already in use.

Make sure that the following ports are available :

- `80` : Ingress Controller Nginx - HTTP
- `443`: Ingress Controller Nginx - HTTPS
- `8080`: Kourier for Knative - HTTP
- `8443`: Kourier for Knative - HTTPS

Execute the command `lsof -i:<PORT>` to identify the PID occupying one of these ports. Then execute the command `kill -9 <PID>` to kill the process

## Manage cluster in DevContainer
### [Kind][kind-doc]

- Start cluster

> ℹ️ Cluster deployed after devContainer startup

```bash
## Deploy CLuster
task cluster-kind-deploy

## Assert 🎉🎉🎉
kubectl cluster-info --context kind-kubernetes-stack 
```

- Delete cluster

> ℹ️ The DevContainer associated with this environment is deleted when the VS Code Dev Container mode is disconnected.

```bash
task cluster-kind-undeploy
```

<!-- Links -->
[kind-doc]:https://kind.sigs.k8s.io/
[vs-code-dev-container-doc]: https://code.visualstudio.com/docs/devcontainers/containers