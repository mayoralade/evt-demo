output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "Base64 Encoded Cluster Certificate Authority"
}

output "cluster_endpoint" {
  value      = module.eks.cluster_endpoint
  description = "Cluster Endpoint"
}

output "cluster_id" {
  value       = module.eks.cluster_id
  description = "Cluster ID"
}

output "oidc_provider" {
  value      = module.eks.oidc_provider
  description = "OIDC Issuer URL"
}

output "oidc_provider_arn" {
  value      = module.eks.oidc_provider_arn
  description = "IODC Provider ARN"
}
