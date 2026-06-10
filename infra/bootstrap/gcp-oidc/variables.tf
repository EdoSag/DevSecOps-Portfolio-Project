variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "devsecops-portfolio"
}

variable "gcp_project_number" {
  description = "GCP project number (numeric), required for the Workload Identity principalSet resource name"
  type        = string
  default     = "777909808392"
}

variable "github_org" {
  description = "GitHub organization/user that owns the repository, used to scope the Workload Identity attribute condition"
  type        = string
  default     = "EdoSag"
}

variable "github_repo" {
  description = "GitHub repository name, used to scope the Workload Identity attribute condition"
  type        = string
  default     = "DevSecOps-Portfolio-Project"
}
