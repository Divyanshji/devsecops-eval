terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.28"
  subnets         = var.subnets
  vpc_id          = var.vpc_id

  # node groups - use spot + on-demand mix for cost optimization
  node_groups = {
    ondemand = {
      desired_capacity = 2
      instance_types   = ["t3.medium"]
      min_capacity     = 1
      max_capacity     = 3
    }
    spot = {
      desired_capacity = 2
      instance_types   = ["t3.medium"]
      capacity_type    = "SPOT"
      min_capacity     = 0
      max_capacity     = 4
    }
  }

  manage_aws_auth = true
}
