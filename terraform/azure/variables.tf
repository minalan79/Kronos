variable "azure_region" {
  description = "Azure region for resources"
  type        = string
  default     = "East Asia"
}

variable "environment" {
  description = "Environment name (e.g., production, staging, dev)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "kronos"
}

variable "organization" {
  description = "Organization name for resource naming"
  type        = string
  default     = "vervea"
}

variable "aks_node_count" {
  description = "Number of nodes in AKS default node pool"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2ls_v2"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for AKS cluster"
  type        = string
  default     = "aks-ea-vervea-cluster"
}

variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "node_subnet_address_prefixes" {
  description = "Address prefixes for node subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "aks_service_cidr" {
  description = "Service CIDR for AKS cluster"
  type        = string
  default     = "10.0.1.0/24"
}

variable "aks_dns_service_ip" {
  description = "DNS service IP for AKS cluster"
  type        = string
  default     = "10.0.1.10"
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "Kronos"
    Managed_By  = "Terraform"
  }
}
