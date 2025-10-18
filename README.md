# 🛒 E-Commerce DevOps Project

A complete **DevOps pipeline** demonstration — from app code to infrastructure, CI/CD, containerisation, and monitoring.

---

## 🚀 Tech Overview

| Layer | Tools Used | Description |
|-------|-------------|--------------|
| **App** | Node.js (Express) | REST API for product management with `/metrics` endpoint |
| **Containers** | Docker | Application + Prometheus + Grafana |
| **CI/CD** | GitHub Actions | Multi-stage build, scan, push, deploy pipeline |
| **Infrastructure** | Terraform + AWS EC2 | Automated provisioning and configuration |
| **Monitoring** | Prometheus & Grafana | Real-time metrics and dashboards |
| **Security** | Trivy | Vulnerability scanning for Docker images |

---

## 🧱 Architecture

Developer → GitHub Actions → DockerHub → AWS EC2 (Docker)
↘ Prometheus + Grafana ↙

yaml
Copy code

---

## ⚙️ CI/CD Pipeline (GitHub Actions)

| Stage | Description |
|--------|--------------|
| **Build & Test** | Installs dependencies, runs Jest tests |
| **Scan Image** | Scans Docker image with Trivy |
| **Push Image** | Builds and pushes image to DockerHub |
| **Deploy** | SSHs into EC2 → Pulls → Runs latest container |
| **Auto-Update** | Commits deployment metadata to repo |

Secrets required:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `SSH_PRIVATE_KEY`
- `EC2_USER`
- `EC2_INSTANCE_IP`
- `GH_PAT` (for README auto-updates)

---

## 🌍 URLs After Deployment

| Service | Port | URL |
|----------|------|------|
| E-Commerce App | 80 | `http://<EC2_IP>/` |
| Prometheus | 9090 | `http://<EC2_IP>:9090` |
| Grafana | 3001 | `http://<EC2_IP>:3001` |

> Grafana login: `admin / admin`

---

## 📊 Monitoring Stack

- **Prometheus** scrapes `/metrics` from the Node.js app every 15s  
- **Grafana** visualises metrics and supports custom dashboards  
- Metrics include event loop lag, heap usage, HTTP latency, etc.  

To verify:
```bash
curl http://localhost:5000/metrics

🧠 Learning Highlights
- End-to-end CI/CD using GitHub Actions and Terraform

- Secure DockerHub authentication with GitHub Secrets

- Auto-healing EC2 deployments using user-data

- Cloud-native monitoring with Prometheus + Grafana

- DevSecOps integration through vulnerability scanning

🗓️ Deployment Info
Automatically updated in DEPLOYMENT_INFO.md

💬 Author
Kevin Gachiri Wanjiku
AWS Cloud Practitioner | DevOps Enthusiast | Nairobi, Kenya
