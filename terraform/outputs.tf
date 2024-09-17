output "cluster_endpoint" {
  value = aws_eks_cluster.dnamicro.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.dnamicro.certificate_authority.0.data
}
