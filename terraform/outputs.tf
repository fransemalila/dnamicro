output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_security_group_id" {
  description = "The security group for the EKS cluster."
  value       = module.eks.cluster_security_group_id
}