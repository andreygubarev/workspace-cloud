ROOK_OPERATOR_NAMESPACE := rook-ceph
ROOK_CLUSTER_NAMESPACE := rook-ceph-cluster

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: helm-repo
helm-repo: ## Add Rook Helm repository
	helm repo add rook-release https://charts.rook.io/release

.PHONY: rook-operator-install
rook-operator-install: helm-repo ## Install Rook Operator
	helm install --create-namespace --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph rook-release/rook-ceph -f values-operator.yml

.PHONY: rook-operator-upgrade
rook-operator-upgrade: ## Upgrade Rook Operator
	helm upgrade --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph rook-release/rook-ceph -f values-operator.yml

.PHONY: rook-operator-delete
rook-operator-delete: ## Delete Rook Operator
	helm delete --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph || true

.PHONY: rook-operator-delete-crds
rook-operator-delete-crds: ## Delete Rook Operator CRDs
	@bash scripts/rook-rook-operator-crds-cleanup.sh

.PHONY: rook-operator-delete-cleanup
rook-operator-delete-cleanup: ## Delete Rook Operator
	@bash scripts/rook-rook-operator-cleanup.sh

.PHONY: rook-operator-delete-all
rook-operator-delete-all: rook-operator-delete rook-operator-delete-cleanup rook-operator-delete-crds ## Delete Rook Operator (all)

.PHONY: rook-cluster-install
rook-cluster-install: helm-repo ## Install Rook Cluster
	helm install --create-namespace --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster \
	   --set operatorNamespace=$(ROOK_OPERATOR_NAMESPACE) rook-release/rook-ceph-cluster -f values-cluster.yml

.PHONY: rook-cluster-upgrade
rook-cluster-upgrade: ## Upgrade Rook Cluster
	helm upgrade --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster \
	   --set operatorNamespace=$(ROOK_OPERATOR_NAMESPACE) rook-release/rook-ceph-cluster -f values-cluster.yml

.PHONY: rook-cluster-template
rook-cluster-template: ## Render Rook Cluster template
	helm template --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster \
	   --set operatorNamespace=$(ROOK_OPERATOR_NAMESPACE) rook-release/rook-ceph-cluster -f values-cluster.yml

.PHONY: rook-cluster-delete
rook-cluster-delete: ## Delete Rook Cluster
	helm delete --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster || true

.PHONY: rook-cluster-delete-force
rook-cluster-delete-cleanup: ## Delete Rook Cluster (cleanup)
	@bash scripts/rook-rook-cluster-cleanup.sh

.PHONY: rook-cluster-delete-all
rook-cluster-delete-all: rook-cluster-delete rook-cluster-delete-cleanup ## Delete Rook Cluster (all)

.PHONY: dashboard-password
dashboard-password: ## Get Rook Dashboard password
	kubectl -n $(ROOK_CLUSTER_NAMESPACE) get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode | pbcopy

.PHONY: rook-delete
rook-delete: rook-cluster-delete-all rook-operator-delete-all ## Delete Rook (all)
