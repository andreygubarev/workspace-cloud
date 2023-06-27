#!/usr/bin/env bash
set -euxo pipefail

NS=rook-ceph-cluster

if kubectl -n $NS get secret rook-ceph-mon; then
    kubectl -n $NS patch secrets rook-ceph-mon --type merge -p '{"metadata":{"finalizers": []}}'
fi

if kubectl -n $NS get configmap rook-ceph-mon-endpoints; then
    kubectl -n $NS patch configmap rook-ceph-mon-endpoints --type merge -p '{"metadata":{"finalizers": []}}'
fi

for NODE in $(kubectl get nodes -l 'rook.io/cluster=rook-ceph-cluster' -o name); do
    NODE=$(basename "$NODE")
    ssh "$NODE" "sudo rm -rf /var/lib/rook/rook-ceph"
done

kubectl delete ns "$NS"
