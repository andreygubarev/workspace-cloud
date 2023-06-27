#!/usr/bin/env bash
set -euxo pipefail

NS=rook-ceph-cluster

for CRD in $(kubectl -n $NS get crd | awk '/ceph.rook.io/ {print $1}'); do
    kubectl -n $NS get "$CRD" -o name | \
    xargs -I {} kubectl -n $NS patch {} --type merge -p '{"metadata":{"finalizers": []}}'
    kubectl -n $NS delete "$CRD" --all
done
