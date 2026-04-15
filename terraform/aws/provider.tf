terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/aws"
      version = "=6.40.0"
    }
}
  cloud {
    organization = "Vervea"

    workspaces {
      name = "state-kronos"
    }
  }
}

provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}