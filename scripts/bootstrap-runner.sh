#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrapping self-hosted runner environment..."

# ---- Verify tools ----
for tool in docker kubectl kind; do
  if ! command -v $tool; then
    echo "ERROR: $tool is not installed on runner."
    exit 1
  fi
done

echo "All required tools are present."

# ---- Kubernetes cluster ----
CLUSTER_NAME="devops-demo"

if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
  echo "Creating Kind cluster: $CLUSTER_NAME"
  kind create cluster --name $CLUSTER_NAME
else
  echo "Kind cluster already exists"
fi

# ---- Context ----
kubectl config use-context kind-$CLUSTER_NAME

echo "Runner bootstrap completed."
