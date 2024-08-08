# [Nginx Gateway Frabric][nginx-gateway-fabric-doc]

## Késako ?

NGINX Gateway Fabric is an open source project that provides an implementation of the Gateway API using NGINX as the data plane. The goal of this project is to implement the core Gateway APIs – Gateway, GatewayClass, HTTPRoute, GRPCRoute, TCPRoute, TLSRoute, and UDPRoute – to configure an HTTP or TCP/UDP load balancer, reverse proxy, or API gateway for applications running on Kubernetes. NGINX Gateway Fabric supports a subset of the Gateway API.

![Nginx Gateway Fabric High Level](../images/ngf-high-level.png)

## Install

```bash
## Install CRD and Implementation (Nginx Gateway Fabric) of Kubernetes Gateway API -  By Cluster Operator
task gateway:nginx-install
```

> ℹ️ When Nginx Gateway Fabric is installed, a **GatewayClass** `nginx` is provisioned for us.
> To show it : `kubectl describe gc/nginx`

## Test

### Hello World 👋🏼

```bash
## Deploy Workload - By Application Developer
kubectl apply -f gateway/nginx/coffee.workload.yml

## Deploy Gateway - By Cluster Operator
kubectl apply -f gateway/nginx/coffee.gateway.yml

## Deploy Routes HTTP - By Application Developer
kubectl apply -f gateway/nginx/coffee.routes.yml

## Call API - /coffee
curl --connect-to coffee.nzuguem.me:80:localhost:9080 http://coffee.nzuguem.me/coffee
## or
curl -H "Host: coffee.nzuguem.me" localhost:9080/coffee

## Call API - /tea
curl --connect-to coffee.nzuguem.me:80:localhost:9080 http://coffee.nzuguem.me/tea
## or
curl -H "Host: coffee.nzuguem.me" localhost:9080/tea
```

> ℹ️ Using the `--connect-to` option with curl is closely related to the `--resolve` option. This command instructs `curl` to resolve the domain name in the URL by replacing it with the specified one. In the case of an HTTPS request, this option also sends the `SNI` (*the domain name specified in the URL*). The use of the `Host` header will also work, but only for unencrypted requests, as in the case of HTTPS requests, this header will not be considered as SNI (Cf. [Name resolve tricks][curl-name-resolve-tricks])

## Uninstall

```bash
task gateway:nginx-uninstall
```
<!-- Links -->
[nginx-gateway-fabric-doc]: https://docs.nginx.com/nginx-gateway-fabric/
[curl-name-resolve-tricks]: https://everything.curl.dev/usingcurl/connections/name.html
