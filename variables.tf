variable "aws_region" {
  description = "AWS регіон для розгортання"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Назва EKS кластера"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Версія Kubernetes"
  type        = string
  default     = "1.28"
}

variable "vpc_cidr" {
  description = "CIDR блок для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Середовище (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "node_instance_types" {
  description = "Типи інстансів для worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Бажана кількість worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Мінімальна кількість worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Максимальна кількість worker nodes"
  type        = number
  default     = 3
}
