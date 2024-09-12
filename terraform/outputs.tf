# outputs.tf

output "cluster_endpoint" {
  description = "Kubernetes Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "kubeconfig" {
  description = "EKS kubeconfig"
  value       = module.eks.kubeconfig
}

output "node_iam_role" {
  description = "IAM role of the worker nodes"
  value       = module.eks.node_groups["eks_nodes"].iam_role_arn
}
