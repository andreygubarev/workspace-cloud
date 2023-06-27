.PHONY: install
install:
	kustomize build src | kubectl apply -f -

.PHONY: delete
delete:
	kustomize build src | kubectl delete -f -
