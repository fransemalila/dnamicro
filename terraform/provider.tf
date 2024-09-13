provider "aws" {
  region = "us-east-2"  
}

provider "kubectl" {
  host                   = aws_eks_cluster.dnamicro.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.dnamicro.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.dnamicro.token
}
