# DevOps Node.js Kubernetes CI/CD Demo

This project demonstrates an **end-to-end DevOps workflow** using a simple Node.js application, Docker, GitHub Actions (CI), GitHub Container Registry (GHCR), Kubernetes (Kind), and a **self-hosted GitHub Actions runner** for Continuous Deployment — all running locally with **zero cloud cost**.

The goal of this project is to be **reproducible** and easy to explain.

---

## 🚀 What This Project Covers

### ✅ Application

* Simple Node.js app
* Exposes health, info and crash endpoints
* Environment-driven configuration

### ✅ Containerization

* Multi-stage Docker build
* Lightweight production image
* Runtime configuration via environment variables

### ✅ CI (GitHub Actions)

* Triggered on push, PR, or manual dispatch
* Unit tests
* Docker image build
* Container health validation
* Push image to **GitHub Container Registry (GHCR)**

### ✅ CD (Kubernetes)

* Kubernetes manifests committed to GitHub
* Deployment to a **local Kind cluster**
* Automated deployment using a **self-hosted GitHub Actions runner**

---

## 🧱 Tech Stack

| Layer         | Technology                |
| ------------- | ------------------------- |
| App           | Node.js                   |
| Container     | Docker                    |
| CI            | GitHub Actions            |
| Registry      | GHCR (ghcr.io)            |
| Orchestration | Kubernetes (Kind)         |
| CD Runner     | GitHub Self-Hosted Runner |
| OS            | Ubuntu (VirtualBox VM)    |

---

## 📂 Repository Structure

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

## 🐳 Docker Image

The application is packaged as a Docker image and published to GHCR.

### Runtime Environment Variables

* `APP_NAME`
* `APP_ENV`
* `APP_VERSION`

---

## ⚙️ CI Pipeline (GitHub Actions)

### CI Flow

1. Checkout code
2. Install dependencies
3. Run unit tests
4. Build Docker image
5. Run container health check (`/health`)
6. Push image to GHCR

### Why Image Testing in CI?

* Verifies the container actually starts
* Catches runtime issues early
* Mimics real production behavior

---

## ☸️ Kubernetes Deployment

### Cluster

* **Kind (Kubernetes in Docker)**
* Runs locally on an Ubuntu VM

### Resources

* **ConfigMap** – application configuration
* **Deployment** – Node.js app pods
* **Service (NodePort)** – external access

### Apply Order

```bash
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```

> ConfigMap is applied first to ensure it exists before the Deployment starts.

---

## 🔁 Continuous Deployment (CD)

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

## 🧪 Self-Hosted Runner Bootstrap

To ensure reproducibility, the CD workflow runs a **bootstrap script** before deploying Kubernetes manifests. This script:

* Verifies Docker, kubectl, and Kind are installed
* Installs missing tools if necessary
* Ensures the Kind cluster exists
* Sets the correct kube context

Example workflow step:

```yaml
- name: Bootstrap runner dependencies
  run: |
    bash ./scripts/bootstrap-runner.sh
```

This makes the CD pipeline **deterministic** and **re-runnable** even after VM reboots.

---

## 🌐 Accessing the Application (Kind-Compatible)

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

## 🧪 Application Endpoints

| Endpoint  | Description                 |
| --------- | --------------------------- |
| `/health` | Health check                |
| `/info`   | App metadata                |
| `/crash`  | Intentional crash (testing) |

---

## 🔮 Possible Next Improvements

* Helm chart
* Ingress controller
* GitOps with ArgoCD or Flux
* Prometheus + Grafana
* Canary or blue-green deployments
