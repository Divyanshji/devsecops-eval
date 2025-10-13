variable "region" { default = "us-east-1" }
variable "env" { default = "dev" }
variable "cluster_name" { default = "devsecops-eval-cluster" }
variable "private_subnets" { type = list(string) }
