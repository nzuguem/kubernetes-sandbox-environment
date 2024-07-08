# Security - [Falco][falco-docs]

## Késako ?

Falco is a cloud-native security tool. It provides near real-time threat detection for cloud, container, and Kubernetes workloads by leveraging runtime insights. Falco can monitor events from various sources, including the Linux kernel, and enrich them with metadata from the Kubernetes API server, container runtime, and more.

Once Falco has received these events, it compares them to a set of **rules** to determine if the actions being performed need further investigation. If they do, Falco can forward the **output** to multiple different endpoints either natively (*syslog, stdout, HTTPS, and gRPC endpoints*) or with the help of **Falcosidekick**, a companion tool that offers integrations to several different applications and services.

![Falco Ecosystem](../images/falco-complete-archi.png)

Falco operates in both *kernel and user space*. In kernel space, Linux system calls (**syscalls**) are collected by a **driver**, for example, the Falco kernel module or Falco eBPF probe. Next, syscalls are placed in a ring buffer from which they are moved into user space for processing. The events are filtered using a rules engine with a Falco rule set. Falco ships with a default set of rules, but operators can modify or turn off those rules and add their own. If Falco detects any suspicious events those are forwarded to various endpoints.

![Falco Architecture](../images/falco-architecture.png)

## Install

```bash
task security:falco-install
```

### Details of how to install rules and plugins

Falco's installation includes a set of predefined [macros][falco-default-macros] and [rules][falco-default-rules].

[**Falcoctl**][falcoctl-docs] are component responsible to install and manage (*follow and update*) your rules and plugins (a.k.a *Artifacts*). All these artifacts are referenced in an [Index](https://falcosecurity.github.io/falcoctl/index.yaml).

In a Kubernetes context, 2 sidecars are associated with each instance of Falco :

- **falcoctl-artifact-install** : Installing artifacts (plugins and rules)
- **falcoctl-artifact-follow** : Follow and updating artifacts (*Default every 6 hours*)

The configuration of the artifacts to be managed by Falcoctl is defined in the [Helm values file](./helm.values.yml).

> ⚠️ You don't just need to install the artifacts, you also need to ask Falco to consider them: `falco.load_plugins` and `falco.rules_file`.

The [plugins][falco-registed-plugins] and rules are maintained by the Falco community and maintainer. And a plugin is generally associated with a set of rules

## Test

### Hello World Falco

```bash
## Start an Alpine container.
kubectl run alpine --image alpine -- sh -c "sleep infinity"

## Shell into the running container and run the uptime command. This will trigger Falco to send an Alert.
kubectl exec -it alpine -- sh -c "uptime"

## Examine Falco's output 
kubectl logs -l app.kubernetes.io/name=falco -n falco-system -c falco | grep Notice
# {"hostname":"kubernetes-stack-worker","output":"19:39:32.856027382: Notice A shell was spawned in a ... }
```

> The output to FalcoSidekick is also configured, so visit http://falcosidekick-ui.127.0.0.1.nip.io

Falco's output (*STDOUT and HTTP Falcosidekick*) is the result of rule [Terminal shell in container](https://github.com/falcosecurity/rules/blob/28b98b6f5f2fd1c1a82fc96c07bc844db33eb7cd/rules/falco_rules.yaml#L710)

## Uninstall

```bash
task security:falco-uninstall
```

## Resources

- [Faclco GitHub Chart Helm][falco-gh-chart-helm]
- [Réagir à temps aux menaces dans Kubernetes avec Falco (Rachid Zarouali, Thomas Labarussias)][falco-youtube]
- [Falco de A à Y][falco-blog-by-quentin-joly]

<!-- Links -->
[falco-docs]: https://falco.org/
[falco-youtube]: https://youtu.be/Mx28fhyKX7Q?si=GIQsPn2UOCsBl1JO
[falco-blog-by-quentin-joly]: https://une-tasse-de.cafe/blog/falco/
[falco-default-macros]: https://falco.org/docs/reference/rules/default-macros/
[falco-default-rules]: https://falco.org/docs/reference/rules/default-rules/
[falcoctl-docs]: https://falco.org/blog/falcoctl-install-manage-rules-plugins/
[falco-registed-plugins]: https://falco.org/docs/plugins/registered-plugins/
[falco-gh-chart-helm]: https://github.com/falcosecurity/charts/blob/master/charts/falco/README.md 