# EKS Cluster

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.0"
  
  cluster_name    = "dnamicro"
  cluster_version = "1.21"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets  # Correct argument for subnets

  # Managed node groups
  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 4
      min_capacity     = 2
      instance_type    = "t3.medium"
    }
  }
}


# VPC for EKS

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "dnamicro-vpc"
  cidr   = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}
