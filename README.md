# Kubernetes Deployment with Terraform, Canary Deployment, and CI/CD

## Prerequisites

- Terraform
- AWS CLI
- kubectl

## Setup

1. **Clone the repository**:
    ```bash
    git clone https://github.com/fransemalila/dnamicro.git
    cd dnamicro
    ```

2. **Provision the Kubernetes cluster with Terraform**:
    ```bash
    cd terraform/
    terraform init
    terraform apply
    ```

3. **Deploy applications to the cluster**:
    ```bash
      kubectl apply -f kubernetes/whoami-deployment.yaml
      kubectl apply -f kubernetes/whoami-service.yaml
      kubectl apply -f kubernetes/canary-deployment.yaml
      kubectl apply -f kubernetes/canary-service.yaml
    ```

4. **Access the service**:
    - Find the external IP of the service:
      ```bash
      kubectl get services
      ```
    - Open your browser and access the service using the external IP.

## CI/CD Pipeline

This project includes:
- A **GitHub Actions workflow** for continuous integration and deployment to the Kubernetes cluster.
- An **optional GitLab CI/CD pipeline** for performing the same task using GitLab runners.

Push changes to `master`, and the pipeline will automatically deploy the latest changes to your Kubernetes cluster.

### Canary Deployment

A canary deployment is set up using the `whoami-canary` deployment with a single replica. It routes a small portion of traffic to the canary release using `kubectl apply -f kubernetes/canary-deployment.yaml`.

## Clean Up

To delete the infrastructure provisioned by Terraform, run:
```bash
terraform destroy
```
	
