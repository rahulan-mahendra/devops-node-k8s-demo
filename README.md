# DevOps Node.js Kubernetes CI/CD Demo

This project demonstrates an end-to-end DevOps workflow using a simple Node.js application, Docker containerization, GitHub Actions for Continuous Integration, GitHub Container Registry for image storage, and Kubernetes (Kind) for orchestration. Continuous Deployment is implemented using a self-hosted GitHub Actions runner, with the entire setup running locally at zero cloud cost.

The objective of this project is to be reproducible, portable, and easy to explain, making it suitable for learning, demonstrations, and portfolio presentation.

---

## Project Overview

This repository showcases the complete lifecycle of a containerized application:

- Application development
- Container build and optimization
- Automated testing and image validation
- Image publishing to a registry
- Kubernetes deployment
- Continuous Deployment using a self-hosted runner
- Deterministic environment verification

---

## Features

### Application
- Lightweight Node.js REST application
- Health, information, and crash simulation endpoints
- Environment-based configuration

### Containerization
- Multi-stage Docker build
- Minimal production image
- Runtime configuration via environment variables

### Continuous Integration
- Triggered on push, pull request, or manual dispatch
- Dependency installation and unit tests
- Docker image build and runtime validation
- Automatic image push to GitHub Container Registry

### Continuous Deployment
- Kubernetes manifests stored in version control
- Deployment to a local Kind cluster
- Self-hosted GitHub Actions runner for cluster access
- Automated and repeatable deployments

---

## Technology Stack

| Layer          | Technology                |
|---------------|--------------------------|
| Application   | Node.js                  |
| Container     | Docker                   |
| CI/CD         | GitHub Actions           |
| Registry      | GitHub Container Registry|
| Orchestration | Kubernetes (Kind)        |
| Runner        | GitHub Self-Hosted Runner|
| OS            | Ubuntu (VirtualBox VM)   |

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yaml
│       └── cd.yaml
├── kubernetes/
│   ├── configmap.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── scripts/
│    └── bootstrap-runner.sh
├── src/                    # Node.js source code
├── tests/                  # Unit tests
├── .dockerignore 
├── Dockerfile
├── package-lock.json
├── package.json
└── README.md
```

---

## Docker Image

The application is packaged into a Docker image and published to GitHub Container Registry.

### Runtime Environment Variables

| Variable     | Description              |
|-------------|--------------------------|
| APP_NAME    | Application name         |
| APP_ENV     | Environment (dev/prod)   |
| APP_VERSION | Application version      |

---

## Continuous Integration Pipeline

### CI Flow
1. Checkout source code
2. Install dependencies
3. Execute unit tests
4. Build Docker image
5. Run container health check (`/health`)
6. Push image to container registry

### Purpose of Image Testing
- Ensures the container starts correctly
- Detects runtime configuration issues
- Simulates production-like execution

---

## Kubernetes Deployment

### Cluster
- Local Kubernetes cluster using Kind
- Runs inside Docker on an Ubuntu virtual machine

### Kubernetes Resources
- **ConfigMap** – Stores application configuration
- **Deployment** – Manages application pods
- **Service (NodePort)** – Exposes the application

### Apply Order

```bash
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```
---

## Continuous Deployment (CD)

### Approach

* CD runs on a **self-hosted GitHub Actions runner**
* Runner is installed on the same VM where Kind is running
* No public IP or cloud Kubernetes required

### Why Self-Hosted Runner?

* GitHub cloud runners cannot access local clusters
* Self-hosted runner runs **inside the same network** as Kind
* Realistic production-style deployment flow with **zero cloud cost**.

### Deployment Trigger

* Manual (`workflow_dispatch`)

---

## Self-Hosted Runner Bootstrap

To ensure reproducibility, the CD workflow runs a **bootstrap script** before deploying Kubernetes manifests. This script:

* Verifies Docker, kubectl, and Kind are installed
* Displays warnings if dependencies are missing
* Ensures the Kind cluster exists (creates it if absent)
* Sets the correct kube context

This allows the CD pipeline to be safe to re-run after VM restarts without reinstalling tools automatically.

---

## Accessing the Application (Kind-Compatible)

Kind runs inside Docker, so NodePort does **not always map directly to localhost**. Use **port-forwarding** to access services from your host.

```bash
# Forward service port to localhost
kubectl port-forward svc/devops-demo-service 3000:3000

# Test the app
curl http://localhost:3000/health
curl http://localhost:3000/info
```

This works reliably on any host running the Kind cluster.

---

## Application Endpoints

| Endpoint  | Description                 |
| --------- | --------------------------- |
| `/health` | Health check                |
| `/info`   | App metadata                |
| `/crash`  | Intentional crash (testing) |

---

## Possible Next Improvements

* Helm chart
* Ingress controller
* GitOps with ArgoCD or Flux
