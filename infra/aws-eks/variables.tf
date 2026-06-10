variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "devsecops-portfolio"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane. Check currently supported versions with: aws eks describe-cluster-versions --query \"clusterVersions[?clusterVersionStatus=='STANDARD_SUPPORT'].clusterVersion\""
  type        = string
  default     = "1.31"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = <<-EOT
    CIDR blocks allowed to reach the public EKS API endpoint, e.g. ["<your-public-ip>/32"].
    Find your current public IP with: curl ifconfig.me
    To update later (e.g. after an ISP IP change), edit this value and re-run
    `tofu apply` - this updates the EKS cluster's endpoint access config in
    place and does NOT require recreating the cluster.
    If your IP changes between sessions and you can't re-apply immediately,
    use AWS SSM Session Manager port-forwarding to a node as a fallback path
    to reach the cluster API without relying on this CIDR list at all.
  EOT
  type        = list(string)
}

variable "node_instance_types" {
  description = "Instance types for the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
