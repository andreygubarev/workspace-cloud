#!/usr/bin/env bash
set -euxo pipefail

# delete namespaces
kubectl delete ns rook-ceph || true

DISK="/dev/sdb"

for NODE in $(kubectl get nodes -l 'rook.io/cluster=rook-ceph-cluster' -o name); do
    NODE=$(basename "$NODE")
    ssh "$NODE" "sudo rm -rf /var/lib/rook"

    ssh "$NODE" "sudo apt-get update && sudo apt-get install -yq --no-install-recommends gdisk parted"
    ssh "$NODE" "sudo sgdisk --zap-all $DISK"
    ssh "$NODE" "sudo dd if=/dev/zero of=$DISK bs=1M count=100 oflag=direct,dsync"
    ssh "$NODE" "sudo partprobe $DISK"
done

for CRD in $(kubectl get crd | awk '/ceph.rook.io/ {print $1}'); do
    kubectl delete crd "$CRD"
done
