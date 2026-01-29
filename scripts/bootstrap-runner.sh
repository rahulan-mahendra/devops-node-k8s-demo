#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrapping self-hosted runner..."

# ---- Docker ----
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker $USER
fi

# ---- kubectl ----
if ! command -v kubectl &> /dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
fi

# ---- kind ----
if ! command -v kind &> /dev/null; then
  echo "Installing kind..."
  curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
  chmod +x kind
  sudo mv kind /usr/local/bin/kind
fi

# ---- Kubernetes cluster ----
CLUSTER_NAME="devops-demo"
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
  echo "🚀 Creating Kind cluster: $CLUSTER_NAME"
  kind create cluster --name $CLUSTER_NAME
else
  echo "Kind cluster already exists"
fi

# ---- Context ----
kubectl config use-context kind-$CLUSTER_NAME

echo "Runner bootstrap completed"
