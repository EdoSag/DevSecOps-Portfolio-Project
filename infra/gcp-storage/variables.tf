variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "devsecops-portfolio"
}

variable "location" {
  description = "GCS bucket location"
  type        = string
  default     = "EU"
}

variable "bucket_name" {
  description = "Globally-unique GCS bucket name for cross-cloud immutable log archiving (Falco runtime alerts, CI evidence)"
  type        = string
  default     = "devsecops-portfolio-security-logs"
}

variable "retention_period_seconds" {
  description = "Minimum retention period for objects in the bucket (immutability window). Default: 7 days."
  type        = number
  default     = 604800
}

variable "ci_service_account_email" {
  description = "Email of the GitHub Actions CI service account (from infra/bootstrap/gcp-oidc), granted read access to this bucket for OIDC verification and CI evidence retrieval."
  type        = string
  default     = "gh-actions-ci@devsecops-portfolio.iam.gserviceaccount.com"
}
