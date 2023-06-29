.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install external-dns
	kubectl create namespace external-dns || true

	sops -d values.sops.yml | \
	helm -n external-dns upgrade -i external-dns ./chart --wait -f -

	sops -d values.hiddenservice.sops.yml | \
	helm -n external-dns upgrade -i hiddenservice ./chart --wait -f -

.PHONY: uninstall
uninstall: ## Uninstall external-dns
	helm -n external-dns delete external-dns
	helm -n external-dns delete hiddenservice
	kubectl delete namespace external-dns
