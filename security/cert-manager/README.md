# Security - Cert-Manager

## Késako ?

It's the successor of ***kube-lego*** (obtaining TLS certificates **only from Let's Encrypt**)

Cert-Manager is a very popular open source *certificate management tool*, specifically designed to work with Kubernetes. It can handle all the required operations for obtaining, renewing and using SSL/TLS certificates. Cert-Manager is able to talk with various certificate authorities (or CAs), like: Let’s Encrypt, HashiCorp Vault, and Venafi, and issue valid certificates for you automatically. On top of that, it can also take care of automatic certificate renewal before expiration.

## Install

```bash
task security:cert-manager-install
```

## Deploy ClusterIssuer
```bash
## Deploy Self Signed Cluster Issuer
kubectl apply -f security/cert-manager/self.clusterissuer.yml
```

## Test
```bash
## ClusterIssuer certificate request for our Nginx workload
kubectl apply -f security/cert-manager/nginx.certificate.yml

## Deploy Workload Nginx With TLS
kubectl apply -f security/cert-manager/nginx.yml
```

Visit this URL https://nginx-cert-manager.127.0.0.1.nip.io (⚠️ Make sure the ingress controller is properly installed)

> ⚠️ It's normal for the browser to raise an alert. The certificate is self-signed.
> <br/> <br/>
> You can use others [Issuers or CAs][cert-manager-issuers-list] as Cluster Issuer, BUT you must have control of the DNS zone.

If you don't want to create the certificate yourself for the domains in the ingress resource, you can delegate this task to CertManager. Simply use [the annotations][cert-manager-ingress-annotations] provided for this purpose : this function is provided by a CertManager sub-component called ***ingress-shim***

```bash
# Check that the certificate "nginx-cert-manager-ing-shim.127.0.0.1.nip.io-tls" has been created by ingress-shim
kubectl get certificate
```

Visit this URL https://nginx-cert-manager-ing-shim.127.0.0.1.nip.io (⚠️ Make sure the ingress controller is properly installed)

## Uninstall

```bash
task security:cert-manager-uninstall

kubectl delete -f security/cert-manager/self.clusterissuer.yml
kubectl delete -f security/cert-manager/nginx.certificate.yml
kubectl delete -f security/cert-manager/nginx.yml
kubectl delete  secret/nginx-cert-manager.127.0.0.1.nip.io-tls
```

## Resources
- [Générez automatiquement vos certificats Let’s Encrypt dans Kubernetes][cert-manager-lets-encrypt-blog]
- [Cert Manager - Ingress][cert-manager-ingress]

<!-- Links -->
[cert-manager-lets-encrypt-blog]: https://blog.zwindler.fr/2018/03/27/generez-automatiquement-vos-certificats-lets-encrypt-dans-kubernetes/
[cert-manager-ingress]: https://cert-manager.io/docs/usage/ingress/
[cert-manager-ingress-annotations]:https://cert-manager.io/docs/usage/ingress/#supported-annotations
[cert-manager-issuers-list]:https://cert-manager.io/docs/configuration/issuers/ 