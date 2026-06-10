data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  #checkov:skip=CKV_TF_1: Registry module pinned by version constraint (.terraform.lock.hcl); commit-hash pinning applies to git sources, not registry modules.
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 4, i + 8)]

  # A single NAT gateway is enough for this demo and keeps cost down. It MUST
  # stay enabled: Kyverno's verifyImages policy (Phase 4) calls the public
  # Rekor transparency log (rekor.sigstore.dev) from these private subnets.
  # Without NAT egress, the admission webhook times out and blocks ALL
  # deployments to the cluster.
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  #checkov:skip=CKV_TF_1: Registry module pinned by version constraint (.terraform.lock.hcl); commit-hash pinning applies to git sources, not registry modules.
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Private + public API endpoint, restricted to the CIDRs in
  # var.cluster_endpoint_public_access_cidrs (see variables.tf for how to
  # update this when your IP changes, and the SSM fallback access path).
  endpoint_private_access      = true
  endpoint_public_access       = true
  endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }
}
