HELM_REPO := rook-release
ROOK_OPERATOR_NAMESPACE := rook-ceph
ROOK_OPERATOR_HELM_RELEASE := rook-ceph
ROOK_OPERATOR_HELM_VALUES := values/rook-operator.sops.yml
ROOK_CLUSTER_NAMESPACE := rook-ceph-cluster
ROOK_CLUSTER_HELM_RELEASE := rook-ceph-cluster
ROOK_CLUSTER_HELM_VALUES := values/rook-cluster.sops.yml

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Helm ######################################################################

.PHONY: helm-repo
helm-repo: ## Add Rook Helm repository
	helm repo add $(HELM_REPO) https://charts.rook.io/release

### Rook Operator #############################################################

.PHONY: rook-operator-install
rook-operator-install: helm-repo ## Install Rook Operator
	sops -d $(ROOK_OPERATOR_HELM_VALUES) | \
	helm upgrade --install --create-namespace --namespace $(ROOK_OPERATOR_NAMESPACE) \
		$(ROOK_OPERATOR_HELM_RELEASE) $(HELM_REPO)/rook-ceph -f -

.PHONY: rook-operator-delete-helm
rook-operator-delete-helm: ## Delete Rook Operator Helm
	helm delete --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph || true

.PHONY: rook-operator-hook-post-delete
rook-operator-hook-post-delete: ## Post-delete Rook Operator
	@bash hooks/rook-operator-hook-post-delete.sh

.PHONY: rook-operator-delete
rook-operator-delete: rook-operator-delete-helm rook-operator-hook-post-delete ## Delete Rook Operator

### Rook Cluster ##############################################################

.PHONY: rook-cluster-install
rook-cluster-install: helm-repo ## Install Rook Cluster
	sops -d $(ROOK_CLUSTER_HELM_VALUES) | \
	helm upgrade --install --create-namespace --namespace $(ROOK_CLUSTER_NAMESPACE) \
		$(ROOK_CLUSTER_HELM_RELEASE) $(HELM_REPO)/rook-ceph-cluster -f - \
		--set operatorNamespace=$(ROOK_OPERATOR_NAMESPACE)

.PHONY: rook-cluster-template
rook-cluster-template: ## Render Rook Cluster template
	sops -d $(ROOK_CLUSTER_HELM_VALUES) | \
	helm template --namespace $(ROOK_CLUSTER_NAMESPACE) \
		$(ROOK_CLUSTER_HELM_RELEASE) $(HELM_REPO)/rook-ceph-cluster -f - \
	   --set operatorNamespace=$(ROOK_OPERATOR_NAMESPACE)

.PHONY: rook-cluster-delete-helm
rook-cluster-delete-helm: ## Delete Rook Cluster Helm
	helm delete \
		--namespace $(ROOK_CLUSTER_NAMESPACE) \
		$(ROOK_CLUSTER_HELM_RELEASE) || true

.PHONY: rook-cluster-hook-pre-delete
rook-cluster-hook-pre-delete: ## Pre-delete Rook Cluster
	@bash hooks/rook-cluster-hook-pre-delete.sh

.PHONY: rook-cluster-hook-post-delete
rook-cluster-hook-post-delete: ## Post-delete Rook Cluster
	@bash hooks/rook-cluster-hook-post-delete.sh

.PHONY: rook-cluster-delete
rook-cluster-delete: rook-cluster-hook-pre-delete rook-cluster-delete-helm rook-cluster-hook-post-delete ## Delete Rook Cluster

### Rook ######################################################################

.PHONY: rook-install
rook-install: rook-operator-install rook-cluster-install ## Install Rook

.PHONY: rook-upgrade
rook-upgrade: rook-operator-upgrade rook-cluster-upgrade ## Upgrade Rook

.PHONY: rook-delete
rook-delete: rook-cluster-delete rook-operator-delete ## Delete Rook (all)

### Rook Dashboard ############################################################

.PHONY: dashboard-password
dashboard-password: ## Get Rook Dashboard password
	kubectl -n $(ROOK_CLUSTER_NAMESPACE) get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode | pbcopy
