NAMESPACE := istio-system
HELM_CHART_RELEASE := istiod
HELM_VALUES := values.sops.yml

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: helm-repo
helm-repo: ## Add Istio Helm repository
	helm repo add istio https://istio-release.storage.googleapis.com/charts

.PHONY: install
install: helm-repo ## Install Istio
	kustomize build gateway | kubectl apply -f -

	kubectl create namespace istio-system || true
	kubectl create namespace istio-ingress || true

	sops -d values/base.sops.yml | \
	helm -n istio-system upgrade -i istio-base istio/base --version 1.18.0 --wait -f - \
		--set defaultRevision=default

	sops -d values/istiod.sops.yml | \
	helm -n istio-system upgrade -i istiod istio/istiod --version 1.18.0 --wait -f -

.PHONY: delete
delete: ## Delete Istio
	helm -n istio-system delete istio-base || true
	helm -n istio-system delete istiod || true
	kubectl delete namespace istio-system || true
	kubectl delete namespace istio-ingress || true
	kustomize build gateway | kubectl delete -f -
