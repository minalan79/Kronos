terraform {
  required_providers {
    aws = {
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
    region = "us-east-1"
}

data "aws_availability_zones" "az_ue" {
}