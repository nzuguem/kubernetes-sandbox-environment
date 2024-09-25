# [Knative Serving][knative-serving-doc]

## Késako ?

Knative Serving is ideal for running your application services inside Kubernetes by providing a more simplified deployment syntax with automated scale-to-zero and scale-out ***based on HTTP load***. The Knative platform will manage your service’s deployments, revisions, networking and scaling. Knative Serving exposes your service via an HTTP URL and has a lot of sane defaults for its configurations.

## Install

```bash
task serverless:knative-serving-install
```

## Test

```bash
# Deploy Knative Service
kubectl apply -f serverless/knative/serving/hello.service.yml

# Verify that the service is deployed and ready for use. (⚠️ Wait until Ready equals True)
kubectl get ksvc -w
# NAME    URL                                     LATESTCREATED   LATESTREADY   READY     REASON
# hello   http://hello.default.127.0.0.1.nip.io   hello-00001     hello-00001   True
```

Visit this URL http://hello.default.127.0.0.1.nip.io:8080/hello/KnativeServing

To observe the “Scale Up” and “Scale Down (To Zero)” properties
```bash
# Pods Watch
watch kubectl get po

# Execute this command in a different terminal and return to the watch terminal to observe the scaling action
for i in {1..1000}; do curl http://hello.default.127.0.0.1.nip.io:8080/hello/KnativeServing & done; wait
```

By default, the PA (Pod Autoscaler) used is the one integrated into Knative Serving: KPA Autoscaler. It supports **concurrency** (*default metric*) and **rps** (*request per second*) [metrics][knative-serving-metrics-doc].

> ℹ️ The soft limit linked to the [concurrency metric][knative-serving-metrics-concurrency-doc] is set to 100 by default

## Uninstall

```bash
kubectl delete -f serverless/knative/serving/hello.service.yml

task serverless:knative-serving-uninstall
```

<!-- Links -->
[knative-serving-doc]: https://knative.dev/docs/serving/
[knative-serving-metrics-doc]: https://knative.dev/docs/serving/autoscaling/autoscaling-metrics/
[knative-serving-metrics-concurrency-doc]:https://knative.dev/docs/serving/autoscaling/concurrency/