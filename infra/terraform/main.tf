terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Example: create an IAM role for EKS node group with limited permissions (skeleton)
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Add minimum policies as attachments (example - attach AmazonEKSWorkerNodePolicy etc.)
resource "aws_iam_role_policy_attachment" "worker_attach_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Create EKS cluster (you can swap to terraform-aws-modules/eks for production)
resource "aws_eks_cluster" "this" {
  name     = "${var.cluster_name}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config { subnet_ids = var.private_subnets }
  # endpoint privateAccess/publicAccess settings for least-exposure
}

# ... fill in node groups, security group rules, and IRSA for service accounts
