HELM_REPO := twuni
NAMESPACE := docker-registry
HELM_RELEASE := docker-registry
HELM_VALUES := values.sops.yml

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Helm ######################################################################

.PHONY: helm-repo
helm-repo: ## Add Rook Helm repository
	helm repo add $(HELM_REPO) https://helm.twun.io

### Rook Operator #############################################################

.PHONY: install
install: helm-repo ## Install Docker Registry
	sops -d $(HELM_VALUES) | \
	helm upgrade --install --create-namespace --namespace $(NAMESPACE) \
		$(HELM_RELEASE) $(HELM_REPO)/docker-registry -f -

.PHONY: delete
delete: ## Delete Docker Registry
	helm delete --namespace $(NAMESPACE) $(HELM_RELEASE) || true
	@bash hooks/post-delete.sh
