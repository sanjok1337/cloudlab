output "cluster_id" {
  description = "ID EKS кластера"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint EKS кластера"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Назва EKS кластера"
  value       = module.eks.cluster_name
}

output "cluster_security_group_id" {
  description = "Security group ID кластера"
  value       = module.eks.cluster_security_group_id
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnets"
  value       = module.vpc.public_subnets
}

output "region" {
  description = "AWS регіон"
  value       = var.aws_region
}

output "configure_kubectl" {
  description = "Команда для налаштування kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "nginx_ingress_controller_load_balancer" {
  description = "Load Balancer URL для Nginx Ingress Controller"
  value       = "Виконайте: kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
