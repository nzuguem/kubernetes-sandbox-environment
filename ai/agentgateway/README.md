# [Agentgateway](https://agentgateway.dev/)

## Késako ?

An open source HTTP and gRPC gateway that handles traditional application traffic and AI-native protocols in one data plane. Route, secure, observe, and govern services, LLM provider traffic, MCP tools, and agent-to-agent communication without stitching together separate gateways.

![](../images/agentgateway.archi.png)

## Install - Version 1.4

```bash
task ai:agentgateway:install

# Create a Gateway that uses the agentgateway GatewayClass
k apply -f ai/agentgateway/agentgateway-proxy.yml -n agentgateway-system
export INGRESS_GW_ADDRESS=$(kubectl get svc -n agentgateway-system agentgateway-proxy -o jsonpath="{.status.loadBalancer.ingress[0]['hostname','ip']}")
echo $INGRESS_GW_ADDRESS

# Replace "INGRESS_GW_ADDRESS" in mcp.json with the IP address obtained above
```

## Test

### [MCP Servers](https://agentgateway.dev/docs/kubernetes/latest/mcp/)

```bash
# Deploy k8s MCP Server
k apply -f ai/agentgateway/mcp

# Show Tools/Resources/Prompts via MCP Inspector (TUI)
task ai:mcp-inspector:start
```

## Alternatives

- [LiteLLM](https://www.litellm.ai/)
