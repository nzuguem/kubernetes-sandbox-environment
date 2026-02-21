# Ingress - Nginx

## Install
```bash
task ingress:ingress-nginx:install
```

## Test
```bash
## Deploy Worload Nginx
kubectl apply -f ingress/nginx/nginx.yml
```

Visit http://nginx.127.0.0.1.nip.io

> 🚨 Kubernetes [announced the retirement](https://kubernetes.io/blog/2025/11/11/ingress-nginx-retirement/) of [ingress-nginx](https://github.com/kubernetes/ingress-nginx) in March 2026.
>
> Several alternatives, such as the [Gateway API](../../gateway/) or simply another Ingress Controller ([nginx-ingress](https://docs.nginx.com/nginx-ingress-controller/), for example)

## Uninstall
```bash
task ingress:ingress-nginx:uninstall

kubectl delete -f ingress/nginx/nginx.yml
```