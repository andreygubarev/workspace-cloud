VERSION ?= 0.7.1

.PHONY: install
install:
	kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v$(VERSION)/standard-install.yaml


.PHONY: delete
delete:
	kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v$(VERSION)/standard-install.yaml
