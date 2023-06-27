ROOK_OPERATOR_NAMESPACE := rook-ceph-system
ROOK_CLUSTER_NAMESPACE := rook-ceph

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: helm-repo
helm-repo: ## Add Rook Helm repository
	helm repo add rook-release https://charts.rook.io/release

.PHONY: operator-install
operator-install: helm-repo ## Install Rook Operator
	helm install --create-namespace --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph rook-release/rook-ceph -f values-operator-overrides.yml

.PHONY: operator-upgrade
operator-upgrade: ## Upgrade Rook Operator
	helm upgrade --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph rook-release/rook-ceph -f values-operator-overrides.yml

.PHONY: operator-delete
operator-delete: ## Delete Rook Operator
	helm delete --namespace $(ROOK_OPERATOR_NAMESPACE) rook-ceph

.PHONY: operator-delete-cleanup
operator-delete: ## Delete Rook Operator
	@bash scripts/rook-operator-cleanup.sh

.PHONY: cluster-install
cluster-install: helm-repo ## Install Rook Cluster
	helm install --create-namespace --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster \
	   --set operatorNamespace=$(ROOK_CLUSTER_NAMESPACE) rook-release/rook-ceph-cluster -f values-cluster-overrides.yml

.PHONY: cluster-upgrade
cluster-upgrade: ## Upgrade Rook Cluster
	helm upgrade --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster \
	   --set operatorNamespace=$(ROOK_OPERATOR_NAMESPACE) rook-release/rook-ceph-cluster -f values-cluster-overrides.yml

.PHONY: cluster-delete
cluster-delete: ## Delete Rook Cluster
	helm delete --namespace $(ROOK_CLUSTER_NAMESPACE) rook-ceph-cluster

.PHONY: cluster-delete-force
cluster-delete-cleanup: ## Delete Rook Cluster (cleanup)
	@bash scripts/rook-cluster-cleanup.sh

.PHONY: patch-csi
patch-csi: ## Patch CSI DaemonSet
	kubectl -n $(ROOK_CLUSTER_NAMESPACE) patch daemonset csi-cephfsplugin --type='json' -p="$(shell cat patch-csi-daemonset.json)"
	kubectl -n $(ROOK_CLUSTER_NAMESPACE) patch daemonset csi-rbdplugin --type='json' -p="$(shell cat patch-csi-daemonset.json)"

.PHONY: dashboard-password
dashboard-password: ## Get Rook Dashboard password
	kubectl -n $(ROOK_CLUSTER_NAMESPACE) get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode | pbcopy
