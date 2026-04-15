terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0"
    }
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = ">= 0.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
  cloud {
    organization = "Vervea"

    workspaces {
      name = "state-kronos"
    }
  }
}

provider "minikube" {}

provider "kubernetes" {
    host = minikube_cluster.kube_cluster.host
    client_certificate     = minikube_cluster.kube_cluster.client_certificate
    client_key             = minikube_cluster.kube_cluster.client_key
    cluster_ca_certificate = minikube_cluster.kube_cluster.cluster_ca_certificate
}

provider "helm" {
    kubernetes = {
        host = minikube_cluster.kube_cluster.host
        client_certificate     = minikube_cluster.kube_cluster.client_certificate
        client_key             = minikube_cluster.kube_cluster.client_key
        cluster_ca_certificate = minikube_cluster.kube_cluster.cluster_ca_certificate
    }
}