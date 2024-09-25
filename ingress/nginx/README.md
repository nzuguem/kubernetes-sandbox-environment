# Ingress - Nginx

## Install
```bash
task ingress:nginx-install
```

## Test
```bash
## Deploy Worload Nginx
kubectl apply -f ingress/nginx/nginx.yml
```

Visit http://nginx.127.0.0.1.nip.io

## Uninstall
```bash
task ingress:nginx-uninstall

kubectl delete -f ingress/nginx/nginx.yml
```