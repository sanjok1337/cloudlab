module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                         = "vpc-045abe4175f60560a"
  subnet_ids                     = ["subnet-0ca3b7f2f0a48deba","subnet-034b2836c2e3fcb48"]
  cluster_endpoint_public_access = true

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = var.node_instance_types

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    main = {
      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = var.environment
      }

      tags = {
        Environment = var.environment
      }
    }
  }

  # Надати доступ створювачу кластера
  enable_cluster_creator_admin_permissions = true

  # Видалити автоматичний тег кластера з node security group
  # щоб уникнути конфлікту з AWS Load Balancer Controller
  node_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = null
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
