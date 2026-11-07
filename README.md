# Kubernetes Stack

## Késako ?

Fully isolated Kubernetes environment (*container level via **[VS Code DevContainer][vs-code-dev-container-doc]***), for try and test components of the Kubernetes ecosystem.

![](images/k8s-env-arch.svg)

## Content

It contains configurations and examples for the following components:

- Ingress
  - [Nginx](ingress/nginx)
  - [Ngrok](ingress/ngrok)
- Gateway
  - [Nginx](gateway/nginx)
  - [Kgateway](gateway/kgateway)
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
  - [AWS Secrets Manager Agent](security/aws-secret-manager-agent)
  - [Vault](security/vault)
- Control Plane
  - [Crossplane](control-plane/crossplane)
  - [AWS](control-plane/aws)
- Serverless
  - [Knative](serverless/knative)
  - [KEDA](serverless/keda)
- Discovery
  - [Sidecar Container Support v1.29 [beta]](discovery/sidecar-container-support-1.29-beta)
  - [Ephemeral Container - v1.25 [stable]](discovery/ephemeral-container-1.25-stable)
  - [Use an Image Volume With a Pod - v1.31 [alpha]](discovery/image-volume-with-pod-1.31-alpha)
  - [In-Place Resource Resize - v1.27 [alpha]](discovery/in-place-resource-resize-1.27-alpha)
- Workflows
  - [Temporal IO](workflows/temporal)
  - [Kestra](workflows/kestra)
- API Management (apim)
  - [Microcks](apim/microcks)
- AI
  - [agentgateway](ai/agentgateway)
  - [LiteLLM](ai/litellm)
- Datastores
  - [PostgreSQL](datastores/postgresql)
  - [Redis](datastores/redis)
  - [Elasticsearch](datastores/elasticsearch)
  - [Kafka (Strimzi)](datastores/kafka)
- CI/CD
  - [GitLab Runner](ci-cd/gitlab-runner)
- Kubernetes UI
  - [Radar](k8s-ui/radar)
- Internal Developer Platform
  - [Backstage](idp/backstage)
- Service Mesh
  - [Istio](mesh/istio)
- Policies
  - [Kyverno](policies/kyverno)
- [JVM in Kubernetes](jvm)
- [Trash](trash/) : one-shot manifests, used on various occasions

## Launch DevContainer

> 📌 **prerequisite :**
>
> - Docker
> - VS Code *(1)*
> - DevContainer CLI *(1)*
>
> *(1) One of these two*

### Open in Visual Studio Code ⤵️

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/nzuguem/kubernetes-sandbox-environment)

### Start DevContainer without VS Code

```bash
git clone https://github.com/nzuguem/kubernetes-sandbox-environment
cd kubernetes-sandbox-environment

devcontainer up --remove-existing-container=true --workspace-folder ./
CONTAINER_ID=$(docker ps -f "ancestor=ghcr.io/nzuguem/kubernetes-sandbox-environment:latest" -q)
docker exec -it -u vscode $CONTAINER_ID bash
cd /workspaces/kubernetes-sandbox-environment
```

Or, if [mise](https://mise.jdx.dev/) is installed on your host : `mise run sandbox:devcontainer:run`

If you need a version of VS Code that you can access via your browser :

```bash
mise run sandbox:code-server:start
# http://localhost:8088/?folder=/workspaces/kubernetes-sandbox-environment
```

### Browse the cluster services

The UIs exposed by the ingress (`*.127.0.0.1.nip.io`) are reachable directly from your host browser, as ports `80`/`443` are published on the host.

What only lives on the `kind` Docker network (LoadBalancer IPs from cloud-provider-kind, container names such as `kind-registry`) goes through a SOCKS5 proxy, published on `127.0.0.1:1080`

The [kind-proxy.pac](.devcontainer/config/kind-proxy.pac) file lets the browser decide: only container names, `172.16.0.0/12` IPs and the `nip.io` names embedding one (`app.172.19.0.5.nip.io`) go through the proxy, everything else (`*.127.0.0.1.nip.io`, internet) stays direct.

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

## Tasks

Tasks are run with [mise](https://mise.jdx.dev/tasks/) :

- On the host, [mise.toml](mise.toml) only declares the tasks to build and launch the devcontainer (`sandbox:devcontainer:*`).
- Inside the devcontainer, [mise.devcontainer.toml](mise.devcontainer.toml) adds the global tasks (sandbox, cluster, environment) and includes the tasks of each module, declared in `<module>/tasks.toml` and named `<module>:<component>:<action>`. They are only visible there (`MISE_ENV=devcontainer`).

```bash
# Inside the devcontainer
mise tasks                              # List tasks
mise run gitops:argocd:install          # Run a task
mise run cluster:socat-expose --help    # Show the arguments of a task
```

## Tools

Tools are installed with [mise](https://mise.jdx.dev/) :

- [mise.toml](mise.toml) : tools needed on the host (`devcontainer-cli`, `usage`).
- [.devcontainer/config/tools.toml](.devcontainer/config/tools.toml) : the devcontainer toolbox (kubectl, helm, kind, k9s, argocd, ...). It is the container's global mise config (`MISE_GLOBAL_CONFIG_FILE`), so tools work from any directory, and tools are installed by `mise install` in `postCreateCommand` into the `mise-data-volume` Docker volume, so they survive rebuilds.
- [.github/.devcontainer](.github/.devcontainer) : the base image keeps only what mise cannot install (docker-in-docker, git, code-server, vim, mise itself). Rebuild it with `mise run sandbox:devcontainer:build-push` when it changes.

To add a tool : `mise use -g <tool>@<version>` inside the devcontainer (or edit `.devcontainer/config/tools.toml`).

[.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) follows the layout of `mise generate devcontainer --mount-mise-data`.

<!-- Links -->
[kind-doc]:https://kind.sigs.k8s.io/
[vs-code-dev-container-doc]: https://code.visualstudio.com/docs/devcontainers/containers
