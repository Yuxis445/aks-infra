# AKS Infrastructure Deployment with Terraform and Argo CD

## Overview

This project sets up a multi-environment infrastructure on Azure using Terraform. It includes the deployment of Azure Kubernetes Service (AKS) clusters, Argo CD for continuous deployment, and network configurations. The infrastructure is designed to be highly available, scalable, and managed via a CI/CD pipeline.

## Features

- **Multi-Environment Support**: Separate configurations for development, staging, and production environments.
- **Modular Terraform Code**: Reusable modules for AKS, Argo CD, network, and PostgreSQL.
- **CI/CD Integration**: Automated deployments using GitHub Actions (or your preferred CI/CD tool).
- **GitOps Workflow**: Argo CD and Helm are used for deploying containerized microservices.
- **High Availability and Auto-Scaling**: Configured for both the infrastructure and applications.
- **Stateful Backend Support**: Includes deployment of a managed Azure Database for PostgreSQL.

## Repository Structure

```plaintext
├── env/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── vars.tf
│   │   └── versions.tf
├── modules/
│   ├── aks/
│   ├── argo_cd/
│   ├── network/
├── .gitignore
└── README.md
```

## Getting Started

### Prerequisites

- **Azure Subscription**: Access to an Azure account with appropriate permissions.
- **Terraform**: Installed on your local machine (version >= 1.0.0).
- **Azure CLI**: For authentication and managing Azure resources.
- **kubectl**: To interact with the Kubernetes clusters.
- **Helm**: For package management within Kubernetes.

### Installation and Deployment

1. **Clone the Repository**

   ```bash
   git clone https://github.com/Yuxis445/aks-infra.git
   cd aks-infra
   ```

2. **Authenticate with Azure**

   Make sure you are logged in to Azure CLI:

   ```bash
   az login
   ```

3. **Select the Environment**

   Navigate to the environment you wish to deploy (e.g., development):

   ```bash
   cd env/dev
   ```

4. **Initialize Terraform**

   ```bash
   terraform init
   ```

5. **Configure Variables**

   Edit the `variables.tf` file to customize variables like resource group names, locations, and other settings.

6. **Plan the Deployment**

   ```bash
   terraform plan -out=tfplan
   ```

7. **Apply the Deployment**

   ```bash
   terraform apply tfplan
   ```

8. **Access the AKS Cluster**

   Get the Kubernetes configuration:

   ```bash
   az aks get-credentials --resource-group <resource_group_name> --name <cluster_name>
   ```

9. **Verify the Cluster**

   ```bash
   kubectl get nodes
   ```

## Deploying Applications with Argo CD and Helm

### Setup Argo CD

1. **Install Argo CD**

   Argo CD is deployed via the `argo_cd` module in Terraform. It will be available in the `argocd` namespace.

2. **Access Argo CD UI**

   - **Port Forwarding**:

     ```bash
     kubectl port-forward svc/argocd-server -n argocd 8080:443
     ```

   - Open `https://localhost:8080` in your browser.

3. **Login Credentials**

   - **Username**: `admin`
   - **Password**: Retrieve the initial password:

     ```bash
     kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo
     ```

### Deploy Microservices

1. **Prepare Helm Charts**

   Ensure your microservices are packaged as Helm charts and accessible via a repository.

2. **Create Argo CD Applications**

   Use Argo CD to create applications that point to your Helm charts in the Git repository.

3. **Sync Applications**

   Argo CD will monitor the Git repository and automatically deploy updates to the cluster.

## High Availability and Auto-Scaling

### AKS Cluster Configuration

- **Auto-Scaling Enabled**: The cluster autoscaler adjusts node counts between the specified `min_count` and `max_count`.
- **Availability Zones**: Nodes are distributed across multiple zones for resilience.

### Application Scaling

- **Horizontal Pod Autoscaler (HPA)**: Scales the number of pod replicas based on CPU utilization or other custom metrics.

## Infrastructure Components

### Modules

- **AKS Module**: Provisions the Kubernetes cluster with autoscaling and availability zone support.
- **Argo CD Module**: Deploys Argo CD for GitOps workflows.
- **Network Module**: Sets up virtual networks and subnets.
