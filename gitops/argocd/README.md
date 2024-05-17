# GitOps - ArgoCD

## Install
```bash
task gitops:argocd-install

## Get credentials
task gitops:argocd-get-credentials
```

Visit http://argocd.127.0.0.1.nip.io


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

## Uninstall

```bash
task gitops:argocd-uninstall
```

## Resources
- [ArgoCD de A à Y][argocd-blog-1]

<!-- Links -->
[argocd-blog-1]: https://une-tasse-de.cafe/blog/argocd/