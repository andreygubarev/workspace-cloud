.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

MANIFESTS := $(shell ls *.sops.yml)

.PHONY: install-%
install-%: ## Install manifest
	sops -d $*.sops.yml | kubectl apply -f -

.PHONY: uninstall-%
uninstall-%: ## Uninstall manifest
	sops -d $*.sops.yml | kubectl delete -f -

.PHONY: install
install: $(MANIFESTS:%.sops.yml=install-%) ## Install manifests

