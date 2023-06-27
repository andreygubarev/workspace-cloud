.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: helm-repo
helm-repo: ## Add Istio Helm repository
	helm repo add jetstack https://charts.jetstack.io

.PHONY: install
install: helm-repo ## Install Istio
	kubectl create namespace cert-manager || true

	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.2/cert-manager.crds.yaml

	sops -d values.sops.yml | \
	helm -n cert-manager upgrade -i cert-manager jetstack/cert-manager --version v1.12.2 --wait -f -

.PHONY: delete
delete: ## Delete Istio
	helm -n cert-manager delete cert-manager
	kubectl delete namespace cert-manager
