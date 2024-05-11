# Serverless - [Knative][knative-doc]

## Késako ?

Knative is a Kubernetes-based platform to build deploy, and manage modern serverless workloads.

It's a Google project, originally initiated for the Cloud Run service, and later opensourced so that anyone can run serverless on any Kubernetes distribution.

Knative consists of 3 components :

- **[Knative Serving](serving/README.md)**
- **[Knative Eventing](eventing/README.md)**
- Knative Build : Serverless Pipelines (*It's now a separate project called **Tekton***)

## Resources

- [Knative Tutorial By RedHat Developer][knative-tutorial-redhat-developer]
- [Knative Tutorial By Mete Atamel][knative-tutorial-meteatamel]
- [Knative Blog By Piotr][knative-piotr-blog]
- [Knative on Kind][knative-on-kind]

<!-- Links -->
[knative-doc]: https://knative.dev/docs/
[knative-tutorial-redhat-developer]: https://redhat-developer-demos.github.io/knative-tutorial/knative-tutorial/index.html
[knative-tutorial-meteatamel]:https://github.com/meteatamel/knative-tutorial
[knative-piotr-blog]:https://rogulski.it/tags/knative/
[knative-on-kind]: https://github.com/csantanapr/knative-kind