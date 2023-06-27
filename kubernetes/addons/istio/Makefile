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
	kubectl create namespace istio-system || true

	sops -d values/base.sops.yml | \
	helm -n istio-system upgrade -i istio-base istio/base --version 1.18.0 --wait -f - \
		--set defaultRevision=default

	sops -d values/istiod.sops.yml | \
	helm -n istio-system upgrade -i istiod istio/istiod --version 1.18.0 --wait -f -

	kubectl create namespace istio-ingress || true

	# FIXME: istio/gateway is disabled in favor of gateway-api
	# sops -d values/gateway.sops.yml | \
	# helm -n istio-ingress upgrade -i istio-ingress istio/gateway --version 1.18.0 --wait -f -

.PHONY: delete
delete: ## Delete Istio
	helm -n istio-system delete istio-base || true
	helm -n istio-system delete istiod || true
	helm -n istio-inress delete istio-ingress || true
	kubectl delete namespace istio-system || true
	kubectl delete namespace istio-ingress || true
