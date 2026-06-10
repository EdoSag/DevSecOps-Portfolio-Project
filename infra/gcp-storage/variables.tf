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
