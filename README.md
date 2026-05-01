# Kronos

A production-grade Kubernetes platform built with **Infrastructure-as-Code**, deployed on **Azure Kubernetes Service (AKS)** with **automated CI/CD**.

## Overview

Kronos is a complete end-to-end deployment solution featuring:

- **Infrastructure**: Azure VNet, subnets, and AKS cluster managed by Terraform
- **Application**: Python Flask app containerized with Docker, deployed to Kubernetes
- **Automation**: Azure DevOps pipeline for build, test, and deploy
- **Production-Ready**: Health checks, resource limits, security context, pod anti-affinity

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Subscription                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐    ┌──────────────────┐              │
│  │  Resource Groups │    │   Container      │              │
│  ├──────────────────┤    │   Registry (ACR) │              │
│  │ • Kronos         │    │ • kronos:latest  │              │
│  │ • Network        │    │ • kronos:buildID │              │
│  │ • Cluster        │    └──────────────────┘              │
│  └──────────────────┘              │                        │
│         │                           │                        │
│  ┌──────▼──────────────────────────▼──────┐               │
│  │         AKS Cluster                     │               │
│  ├─────────────────────────────────────────┤               │
│  │  VNet: 10.0.0.0/16                     │               │
│  │  ┌──────────────────────────────────┐  │               │
│  │  │  Subnet: 10.0.2.0/24 (Nodes)     │  │               │
│  │  │  ┌────────────────────────────┐  │  │               │
│  │  │  │ Kronos Namespace           │  │  │               │
│  │  │  │ ┌──────────────────────┐   │  │  │               │
│  │  │  │ │ Deployment (2 pods)  │   │  │  │               │
│  │  │  │ │ • Pod 1: Flask App   │   │  │  │               │
│  │  │  │ │ • Pod 2: Flask App   │   │  │  │               │
│  │  │  │ └──────────────────────┘   │  │  │               │
│  │  │  │ ┌──────────────────────┐   │  │  │               │
│  │  │  │ │ Service: LoadBalancer│   │  │  │               │
│  │  │  │ │ Port 80 → :5000      │   │  │  │               │
│  │  │  │ └──────────────────────┘   │  │  │               │
│  │  │  └────────────────────────────┘  │  │               │
│  │  └──────────────────────────────────┘  │               │
│  └─────────────────────────────────────────┘               │
│                       │                                     │
│                       ▼                                     │
│              LoadBalancer (Public IP)                      │
│                    http://[IP]                             │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

### Local Development

- **Terraform** >= 1.5.0: [Install Terraform](https://www.terraform.io/downloads)
- **Azure CLI**: [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- **kubectl** >= 1.26: [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- **Docker** (optional, for local testing): [Install Docker](https://www.docker.com/products/docker-desktop)
- **Azure subscription** with Contributor or Owner role

### CI/CD Pipeline

- **Azure DevOps organization** with the project set up
- **Azure Container Registry (ACR)** in your subscription
- **Service connections** in Azure DevOps:
  - Azure Resource Manager connection (for Terraform + kubectl)
  - Docker Registry connection (for ACR push)

## Quick Start

### 1. Prepare Azure Prerequisites

```bash
# Login to Azure
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create resource group for Terraform remote state
az group create --name rg-terraform-state --location eastasia

# Create storage account for Terraform state
az storage account create \
  --name tfstateaccount \
  --resource-group rg-terraform-state \
  --location eastasia \
  --sku Standard_LRS

# Create storage container
az storage container create \
  --name tfstate \
  --account-name tfstateaccount
```

### 2. Deploy Infrastructure

```bash
cd terraform/azure

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply
```

**Outputs** (exported for CI/CD):
- `aks_cluster_id`: AKS cluster resource ID
- `kube_config`: Kubernetes configuration
- `resource_group_names`: Created resource groups

### 3. Get Kubeconfig

```bash
# Download kubeconfig locally
terraform output kube_config > ~/.kube/kronos-config.yaml
export KUBECONFIG=~/.kube/kronos-config.yaml

# Verify cluster access
kubectl get nodes
kubectl get ns
```

### 4. Deploy Application

```bash
# Option A: Manual deployment with kubectl
kubectl apply -f k8s/

# Option B: Deploy with Kustomize
kubectl apply -k k8s/

# Verify deployment
kubectl get deployment -n kronos
kubectl get svc -n kronos

# Get external IP
kubectl get svc kronos-app -n kronos -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### 5. Test the Application

```bash
# Port-forward for local testing
kubectl port-forward svc/kronos-app -n kronos 8080:80

# Visit http://localhost:8080 in your browser
```

## CI/CD Pipeline

### Pipeline Structure

**Triggers**: `main` branch push or pull request

**Stages**:

1. **Build** (parallel)
   - Docker build
   - Push to Azure Container Registry
   
2. **Terraform** (parallel with Build)
   - Terraform plan (all branches)
   - Terraform apply (main only)
   
3. **Deploy** (after Build + Terraform)
   - Get AKS credentials
   - Deploy manifests (namespace, configmap, service, deployment)
   - Verify rollout

### Setting Up Azure DevOps Pipeline

1. **Create service connections** in Azure DevOps:
   ```
   Project Settings → Service Connections → New Service Connection
   ```
   - **Azure Resource Manager** (for Terraform + kubectl)
   - **Docker Registry** (for ACR)

2. **Create pipeline**:
   - New Pipeline → Azure Repos Git
   - Select repository
   - Review and save `azure-pipelines.yml`

3. **Update pipeline variables**:
   - `acrLoginServer`: Your ACR login server (e.g., `myacr.azurecr.io`)
   - `containerRegistry`: Same as above
   - Update service connection names in pipeline YAML

4. **Run pipeline**:
   - Commit to `main` or create a PR
   - Pipeline auto-triggers

## Customization

### Change Region

```bash
cd terraform/azure

# Override region variable
terraform plan -var="azure_region=West US 2"
terraform apply -var="azure_region=West US 2"
```

### Scale Nodes

```bash
# Increase node count
terraform plan -var="aks_node_count=3"
terraform apply -var="aks_node_count=3"
```

### Update App Deployment

Edit [k8s/deployment.yaml](k8s/deployment.yaml):
- Change replica count
- Adjust resource limits
- Modify health check settings

```bash
kubectl apply -f k8s/deployment.yaml
kubectl rollout status deployment/kronos-app -n kronos
```

## Terraform Variables

[See variables.tf](terraform/azure/variables.tf) for all customizable parameters:

| Variable | Default | Description |
|----------|---------|-------------|
| `azure_region` | East Asia | Azure region for resources |
| `aks_node_count` | 1 | Number of AKS nodes |
| `aks_vm_size` | Standard_B2ls_v2 | Node VM size |
| `vnet_address_space` | 10.0.0.0/16 | Virtual Network CIDR |

## Monitoring & Debugging

### Check Deployment Status

```bash
# Deployment status
kubectl rollout status deployment/kronos-app -n kronos

# Pod logs
kubectl logs -n kronos -l app=kronos-app -f

# Pod details
kubectl describe pod -n kronos -l app=kronos-app

# Service endpoint
kubectl get svc kronos-app -n kronos
```

### Troubleshooting

**Pods not starting?**
```bash
# Check pod events
kubectl describe pod -n kronos <pod-name>

# Check resource requests vs node capacity
kubectl describe nodes
```

**Service not getting LoadBalancer IP?**
```bash
# AKS LoadBalancer may take 2-3 minutes
watch kubectl get svc kronos-app -n kronos

# Check service status
kubectl get svc kronos-app -n kronos -o yaml
```

**Terraform apply fails?**
```bash
# Check Azure CLI authentication
az account show

# Check Terraform state
terraform state list

# Manually refresh state
terraform refresh
```

## Project Structure

```
Kronos/
├── app/                          # Python Flask application
│   ├── app.py                    # Main app entry point
│   ├── requirements.txt           # Python dependencies
│   └── wsgi.py                    # WSGI entry point
├── terraform/
│   └── azure/                    # Azure infrastructure
│       ├── provider.tf            # Provider config + backend
│       ├── variables.tf           # Input variables
│       ├── locals.tf              # Local values & naming
│       ├── rg.tf                  # Resource Groups
│       ├── network.tf             # VNet + subnets
│       ├── cluster.tf             # AKS cluster
│       └── outputs.tf             # Exported values
├── k8s/                          # Kubernetes manifests
│   ├── namespace.yaml            # Kronos namespace
│   ├── configmap.yaml            # App configuration
│   ├── deployment.yaml           # Flask app deployment
│   ├── service.yaml              # LoadBalancer service
│   └── kustomization.yaml        # Kustomize overlay
├── Dockerfile                    # Multi-stage Docker build
├── .dockerignore                 # Docker build exclusions
├── azure-pipelines.yml           # CI/CD pipeline
└── README.md                     # This file
```

## Clean Up

### Destroy All Resources

```bash
# Remove Kubernetes resources
kubectl delete namespace kronos

# Destroy Azure infrastructure (via Terraform)
cd terraform/azure
terraform destroy
```

**Cost**: Destroying the infrastructure prevents ongoing Azure charges.

## Support & Contributing

- **Issues**: Create an issue in the repository
- **Documentation**: Update [README.md](README.md)
- **Testing**: Verify changes on a feature branch before merge

---

**Last Updated**: May 2, 2026
