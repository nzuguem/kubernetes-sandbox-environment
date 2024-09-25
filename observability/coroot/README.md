# Observability - Coroot

## Install

```bash
task observability:coroot-install
```

Visit http://coroot.127.0.0.1.nip.io

## Deploy OTel Collector for Traces and Profiling Telemetry (for Clickhouse)

> ⚠️ OTel Operator MUST BE installed

```bash
## Deploy Sidecar OTel Collector 
kubectl apply -f observability/coroot/otelcol.sidecar.yml

## Deploy Instrumentation Object
kubectl apply -f observability/coroot/otel.inst.yml

## Deploy Example Workload
kubectl apply -f observability/coroot/hello.deploy.yml
```

Visit this URL to generate Traces http://hello-coroot.127.0.0.1.nip.io/hello/Kevin

## Uninstall

```bash
task observability:coroot-uninstall

kubectl delete -f observability/coroot/otelcol.sidecar.yml
kubectl delete -f observability/coroot/otel.inst.yml
kubectl delete -f observability/coroot/hello.deploy.yml
```

## Resources

- [Coroot Community Edition Doc][coroot-doc]

<!-- Links -->
[coroot-doc]: https://coroot.com/docs/coroot-community-edition/getting-started/installation