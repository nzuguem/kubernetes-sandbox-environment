# [GitOps - ArgoCD][argocd-web-site]

## Késako ?

GitOps is a methodological approach that places Git at the center of delivery automation processes. It acts as the “source of truth” and relies on programs to continuously ensure consistency between the current infrastructure and the one defined in the Git repository.

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

![](../images/cicd-gitops-architecture.png)

## Install

```bash
task gitops:argocd-install

## Get credentials
task gitops:argocd-get-credentials
```

Visit <http://argocd.127.0.0.1.nip.io>

## Test

```bash
## Create ArgoCD Application
kubectl apply -f gitops/argocd/spring-native.application.yml

# OR

## Create ArgoCD ApplicationSet
### Auto Sync Activated
kubectl apply -f gitops/argocd/spring-native.applicationset.yml
```

Go to ArgoCD Web UI, access the application and force synchronization 🏆

> ℹ️ By default, ArgoCD will refresh the repository contents every ***3 minutes***. You can change this behavior to reduce the load on the cluster if ArgoCD is used for many projects (or if the cluster is very busy). \
ℹ️ *Note that refreshing the repository does not imply reconciling the application. You'll need to activate the **auto-sync** option for this*.

## [Argo CD Image Updater][argocd-image-updater-web-site]

## Uninstall

```bash
task gitops:argocd-uninstall
```

## Resources

- [ArgoCD de A à Y][argocd-blog-1]

<!-- Links -->
[argocd-blog-1]: https://une-tasse-de.cafe/blog/argocd/
[argocd-web-site]: https://argo-cd.readthedocs.io/en/stable/
[argocd-image-updater-web-site]: https://argocd-image-updater.readthedocs.io/en/stable/
