output "cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  value       = aws_eks_cluster.example.endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for connecting to the cluster"
  value       = aws_eks_cluster.example.kubeconfig
}
