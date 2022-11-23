terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "remote" {
    organization = "ibt-learning"

    workspaces {
      name = "ibt-infra"
    }
  }
}

