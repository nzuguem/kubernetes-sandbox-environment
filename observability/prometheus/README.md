# Observability - Prometheus
## Késako ?
Prometheus is a popular open-source monitoring and alerting solution, and has over time become an indispensable tool for managing and observing Kubernetes clusters.

## Install
```bash
make observability-prometheus-install

## Get Grafana credentials
make grafana-get-credentials
```

> ⚠️ Make sure the ingress controller is properly installed

Grafana : http://grafana.127.0.0.1.nip.io

Prometheus Dashboard : http://prometheus.127.0.0.1.nip.io

Alert Manager Dashboard : http://alert-manager.127.0.0.1.nip.io

## Uninstall

```bash
make observability-prometheus-uninstall
```

## Resources
- [Prometheus Operator Doc][prometheus-operator-doc]
- [Prometheus Operator Helm Chart][prometheus-operator-helm-gh]

<!-- Links -->
[prometheus-operator-doc]: https://prometheus-operator.dev/
[prometheus-operator-helm-gh]: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack