#!/usr/bin/env bash
set -euxo pipefail

NS=docker-registry

kubectl delete ns "$NS" || true
