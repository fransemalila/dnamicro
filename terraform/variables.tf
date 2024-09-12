provider "aws" {
  region = "us-east-2"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-cluster"
  cluster_version = "1.19"
  subnets         = ["subnet-xxxx", "subnet-yyyy"]

  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 4
      min_capacity     = 2
    }
  }
}
