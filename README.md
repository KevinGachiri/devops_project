# E‑Commerce Web App with DevOps Pipeline

This repository contains the source code and infrastructure as code for a simple
e‑commerce API written in Node.js.  It is designed to demonstrate an
end‑to‑end DevOps pipeline complete with containerisation, continuous
integration and deployment, infrastructure provisioning with Terraform,
monitoring with Prometheus and Grafana and basic security scanning with Trivy.

## Features

- **Node.js E‑Commerce API** – A lightweight Express application that exposes
  RESTful endpoints for listing, creating and viewing products.  The app
  exports a `/metrics` endpoint using the [`prom-client`](https://github.com/siimon/prom-client)
  library so that Prometheus can collect runtime metrics.  The quick start
  guide from Grafana shows how `prom-client` exposes default Node.js metrics
  such as garbage collection duration and event loop lag via the `/metrics`
  endpoint【987865156857817†L693-L703】.
- **Docker & Docker Compose** – All services run inside containers.  A
  single `Dockerfile` defines the application image, and `docker‑compose.yml`
  orchestrates the application, a PostgreSQL database, Prometheus and Grafana.
- **Continuous Integration & Deployment with GitHub Actions** – A multi‑stage
  workflow runs tests, builds the Docker image, scans the image with Trivy and
  pushes it to Docker Hub.  On pushes to the `main` branch, the workflow
  deploys the latest image to an Amazon EC2 instance via SSH.  The
  deployment steps mirror the example from S3CloudHub where the workflow
  checks out the repository, sets up Docker Buildx, logs in to Docker Hub,
  builds and pushes the image, and then connects to the EC2 host to pull and
  run the container【67982732464428†L288-L329】.
- **Infrastructure as Code** – A Terraform module provisions an EC2 instance,
  attaches a security group allowing SSH (22) and HTTP (port 80) and
  installs Docker via a user‑data script.  The HashiCorp documentation notes
  that infrastructure objects such as EC2 instances and security groups are
  represented by the `aws_instance` and `aws_security_group` resource types
  respectively【178956359311519†L117-L129】.
- **Monitoring & Alerting** – The application exposes metrics via
  `prom-client`.  A `prometheus.yml` configuration tells Prometheus to
  scrape the `/metrics` endpoint of the Node.js service every 15 seconds.  A
  Grafana container is included and preconfigured to read Prometheus as a
  datasource.  Grafana dashboards provide visual insight into the app’s
  behaviour.  The Grafana quickstart describes how `prom-client` collects
  default metrics and how Prometheus scrapes them【987865156857817†L633-L741】.
- **DevSecOps** – The CI workflow uses the [Trivy GitHub Action](https://github.com/aquasecurity/trivy-action)
  to scan the built Docker image for operating system and library
  vulnerabilities.  Trivy is an open‑source tool that can scan container
  images, file systems and Git repositories for CVEs and misconfigurations
  【684136687498836†L24-L29】.

## Project Structure

```
devops_project/
├── app.js                # Express application entrypoint
├── package.json
├── routes/               # API route handlers
│   └── products.js
├── tests/                # Jest test files
│   └── products.test.js
├── docker-compose.yml    # Multi‑service orchestration
├── Dockerfile            # Application container definition
├── prometheus.yml        # Prometheus scrape configuration
├── .github/workflows/    # GitHub Actions workflows
│   └── ci-cd.yml
├── terraform/            # Infrastructure as code
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── user_data.sh
└── docs/
    ├── architecture.png  # System architecture diagram
    └── monitoring_dashboard.png  # Example monitoring dashboard
```

## Getting Started

### Prerequisites

1. **Docker & Docker Compose:** Install Docker Engine and Docker Compose.
2. **Node.js:** A recent LTS version (18+).
3. **AWS Account:** Required if you intend to deploy to EC2.  Create an
   SSH key pair and store the private key in GitHub Secrets.
4. **Terraform:** Install Terraform 1.5+.

### Running Locally with Docker Compose

```bash
# Clone the repository
git clone https://github.com/your‑username/ecommerce-devops.git
cd ecommerce-devops

# Build and run the stack
docker compose up --build

# The API will be available on http://localhost:5000
# Prometheus will be accessible on http://localhost:9090
# Grafana will be accessible on http://localhost:3001 (admin/admin default login)
```

Prometheus scrapes the Node.js app every 15 seconds as configured in
`prometheus.yml`.  You can import the official Node.js dashboard into
Grafana or create your own.

### Running Tests

```bash
npm install
npm test
```

### Docker Image

Build the Docker image manually using:

```bash
docker build -t your‑dockerhub‑username/ecommerce-app:latest .
```

### Terraform Deployment

Terraform scripts in the `terraform/` directory provision an EC2 instance and
configure a security group.  Before running Terraform, set the required
variables in a `terraform.tfvars` file:

```hcl
aws_region     = "us-east-1"
instance_type  = "t2.micro"
key_name       = "my-key"
public_key_path = "~/.ssh/my-key.pub"
server_port    = 80
```

Then run:

```bash
cd terraform
terraform init
terraform apply
```

After provisioning, Terraform will output the public IP of the instance.  Use
the CI/CD workflow or SSH to deploy the container to the instance.

### CI/CD Pipeline

GitHub Actions automation resides in `.github/workflows/ci-cd.yml`.  The
pipeline has three jobs:

1. **build-test:** Checks out the code, installs dependencies, runs unit tests,
   builds the Docker image and scans it with Trivy.
2. **push-image:** Logs in to Docker Hub and pushes the image tagged
   `ecommerce-app:latest` when the commit is on the `main` branch.
3. **deploy:** Connects to the EC2 instance via SSH and runs Docker commands
   to pull and run the latest image【67982732464428†L288-L329】.

Secrets such as `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `EC2_USER`,
`EC2_INSTANCE_IP` and `SSH_PRIVATE_KEY` must be added to the GitHub
repository under **Settings → Secrets**.  The deployment job uses these
secrets to authenticate to Docker Hub and the EC2 host.

## Monitoring

The Node.js app exposes a `/metrics` endpoint that returns Prometheus metrics.
Grafana is included in the docker-compose stack to visualise these metrics.
The Grafana quickstart demonstrates how default Node.js metrics can be
collected via `prom-client` and scraped by Prometheus【987865156857817†L693-L741】.
You can import dashboards from Grafana’s dashboard catalog or create your own
visualisations.  An example dashboard is provided in `docs/monitoring_dashboard.png`.

## DevSecOps

The CI workflow uses the [Trivy](https://github.com/aquasecurity/trivy) action
to scan the Docker image for vulnerabilities.  Trivy is an open‑source
security scanner that can inspect container images, filesystems, Git
repositories and more for CVEs and misconfigurations【684136687498836†L24-L29】.
Vulnerabilities are reported in the GitHub Actions logs.  You can optionally
configure Trivy to fail the build on high‑severity findings.

## Architecture

See `docs/architecture.png` for a high‑level overview of the system.  At a
glance, users interact with the Node.js API through a load balancer or
directly on port 80.  The API runs in a Docker container on an EC2 instance
provisioned via Terraform.  The CI/CD pipeline builds and scans the Docker
image, pushes it to Docker Hub and deploys it to EC2.  Prometheus scrapes
metrics from the API and Grafana visualises them.  Trivy scans the Docker
image for vulnerabilities during the CI phase.
retry build
Triggering deploy at Sat Sep 20 13:10:53 EAT 2025
