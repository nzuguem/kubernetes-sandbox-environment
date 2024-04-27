default: help

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

cluster-kind-deploy: cluster-kind-undeploy ## Create kubernetes cluster with Kind
	@kind create cluster --config kind.yml

cluster-kind-undeploy: ## Delete Kind kubernetes cluster
	@kind delete cluster --name kubernetes-stack

ingress-nginx-install: ## Install Ingress Nginx
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@kubectl wait -n ingress-nginx \
  			--for=condition=ready pod \
  			--selector=app.kubernetes.io/component=controller \
  			--timeout=90s

ingress-nginx-uninstall: ## Unistall Ingress Nginx
	@kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

gitops-argocd-install: ## Install ArgoCD
	@kubectl create namespace argocd
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	# To expose the ArgoCD service in an Ingress/HTTPRoute, you will certainly need to disable TLS
	@kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge --patch '{"data": {"server.insecure": "true"}}'
	# Create Ingress Resources
	@kubectl apply -n argocd -f gitops/argocd/argocd.ingress.yml
	@kubectl wait -n argocd \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/name=argocd-repo-server \
		--timeout=90s

gitops-argocd-uninstall: ## Uninstall ArgoCD
	@kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@kubectl delete -n argocd -f gitops/argocd/argocd.ingress.yml
	@kubectl delete ns/argocd

argocd-get-credentials: ## Get Credentials of ArgoCD
	@echo 'admin/$(shell kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)'

observability-opentelemetry-install: ## Install OTel Operator
	@helm repo add otel https://open-telemetry.github.io/opentelemetry-helm-charts
	@helm repo update otel
	@helm install \
		--create-namespace \
		--namespace otel-system otel otel/opentelemetry-operator \
		--set admissionWebhooks.certManager.enabled=false

observability-opentelemetry-uninstall: ## Uninstall OTel Operator
	@helm del -n otel-system otel

observability-coroot-install: ## Install Coroot Observability
	@helm repo add coroot https://coroot.github.io/helm-charts
	@helm repo update coroot
	@helm install --namespace coroot-system --create-namespace coroot coroot/coroot
	@kubectl apply -n coroot-system -f observability/coroot/coroot.ingress.yml

observability-coroot-uninstall: ## Uninstall Coroot Observability
	@helm del -n coroot-system coroot
	@kubectl delete -n coroot-system -f observability/coroot/coroot.ingress.yml

security-cert-manager-install: ## Install Cert Manager
	@helm repo add jetstack https://charts.jetstack.io
	@helm repo update jetstack
	@helm install cert-manager jetstack/cert-manager \
		--create-namespace \
		--namespace cert-manager-system \
		--set installCRDs=true

security-cert-manager-uninstall: ## Uninstall Cert Manager
	@helm del -n cert-manager-system cert-manager

platform-crossplane-install: ## Install Crossplane
	@helm repo add crossplane-stable https://charts.crossplane.io/stable
	@helm repo update crossplane-stable
	@helm install crossplane \
		--namespace crossplane-system \
		--create-namespace crossplane-stable/crossplane

platform-crossplane-uninstall: ## Install Crossplane
	@helm del -n crossplane-system crossplane

platform-localstack-install: ## Deploy LocalStack
	@helm repo add localstack-charts https://localstack.github.io/helm-charts
	@helm repo update localstack-charts
	@helm install localstack \
		--set service.type=ClusterIP \
		localstack-charts/localstack
	@kubectl apply -f platform/aws/localstack.ingress.yml

platform-localstack-uninstall: ## Undeploy LocalStack
	@helm del localstack
	@kubectl delete -f platform/aws/localstack.ingress.yml

observability-prometheus-install: ## Install Prometheus Operator
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update prometheus-community
	@helm install prometheus-operator \
		prometheus-community/kube-prometheus-stack  \
		--namespace monitoring \
		--create-namespace \
		-f observability/prometheus/helm.values.yml

observability-prometheus-uninstall: ## Uninstall Prometheus Operator
	@helm del -n monitoring prometheus-operator

grafana-get-credentials: ## Get credentials of Grafana
	@echo 'User=$(shell kubectl -n monitoring get secret prometheus-operator-grafana -o jsonpath="{.data.admin-user}" | base64 -d)'
	@echo 'Password=$(shell kubectl -n monitoring get secret prometheus-operator-grafana -o jsonpath="{.data.admin-password}" | base64 -d)'