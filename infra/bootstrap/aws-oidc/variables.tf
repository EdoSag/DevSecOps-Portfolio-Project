variable "aws_region" {
  description = "AWS region for the provider"
  type        = string
  default     = "eu-north-1"
}

variable "github_repository" {
  description = "GitHub repository in the form <owner>/<repo>, used to scope the OIDC trust policy"
  type        = string
  default     = "EdoSag/DevSecOps-Portfolio-Project"
}
