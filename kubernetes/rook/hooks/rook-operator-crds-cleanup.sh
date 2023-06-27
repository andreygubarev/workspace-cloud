#!/usr/bin/env bash
set -euxo pipefail

for CRD in $(kubectl get crd | awk '/ceph.rook.io/ {print $1}'); do
    kubectl delete crd "$CRD"
done

