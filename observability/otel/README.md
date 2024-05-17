# Observability - OpenTelemetry

## Install
```bash
task observability:opentelemetry-install
```

## Test

### Create OTel Collector
```bash
kubectl apply -f observability/otel/otelcol.sidecar.yml

## Get All OTel Collectors in Cluster
kubectl get otelcol,svc
```

> ℹ️ The OpenTelemetry operator analyzes the recievers and their ports in the configuration and creates corresponding services (standard and headless).

### Injecting the sidecar on a kubernetes workload
```bash
## This workload uses the OpenTracing SDK to push traces to Jeager
kubectl apply -f observability/otel/jaegertracing.deploy.yml

## Observe the injected sidecar
kubectl get pods -l app=jaegertracing -o jsonpath={.items[*].spec.containers[*].name}

## Follow and Observe Logs of Injected OTel Collector
kubectl logs deploy/jaegertracing -c otc-container -f
```

Visit this URL to generate telemetry http://jaegertracing.127.0.0.1.nip.io

### Workload Auto-Instrumentation
```bash
kubectl apply -f observability/otel/otel.inst.yml

## Get All OTel Instrumentation in Cluster
kubectl get otelinst

## Deploy OTel Collector as Deployment
kubectl apply -f observability/otel/otelcol.deployment.yml

## Deploy Instrumented Workload
kubectl apply -f observability/otel/hello.deploy.yml

## Follow and Observe Logs of Injected OTel Collector
kubectl logs deploy/collector-deployment-collector -f
```

Visit this URL to generate Traces http://hello.127.0.0.1.nip.io/hello/Kevin (⚠️ Make sure the ingress controller is properly installed)


### Deploy OTel Collector as DaemonSet
```bash
## It displays the logs of the jaegertracing workload in debug mode.
kubectl apply -f observability/otel/otelcol.daemonset.yml

kubectl logs -l app.kubernetes.io/instance=default.collector-daemonset -f
```

Visit this URL to generate Logs http://jaegertracing.127.0.0.1.nip.io (⚠️ Make sure the ingress controller is properly installed)


## Uninstall
```bash
task observability:opentelemetry-uninstall

kubectl delete -f observability/otel/otelcol.sidecar.yml
kubectl delete -f observability/otel/jaegertracing.deploy.yml
kubectl delete -f observability/otel/otel.inst.yml
kubectl delete -f observability/otel/otelcol.deployment.yml
kubectl delete -f observability/otel/hello.deploy.yml
kubectl delete -f observability/otel/otelcol.daemonset.yml
```

## Resources
- [OpenTelemetry Operator][otel-operator-gh]

<!-- Links -->
[otel-operator-gh]: https://github.com/open-telemetry/opentelemetry-operator