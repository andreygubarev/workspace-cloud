.PHONY: install
install:
	kubectl kustomize github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.4.3 | kubectl apply -f -

.PHONY: delete
delete:
	kubectl kustomize github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.4.3 | kubectl delete -f -
