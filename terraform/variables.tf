variable "aws_region" { default = "us-east-1" }
variable "cluster_name" { default = "devsecops-eks" }
variable "vpc_id" {}
variable "subnets" { type = list(string) }
