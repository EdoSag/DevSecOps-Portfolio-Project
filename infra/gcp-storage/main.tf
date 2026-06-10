# Cross-cloud immutable log archive: Falco runtime alerts (Phase 5) and CI
# evidence land here. Versioning + a retention policy give an append-only,
# tamper-evident store independent of the AWS account.
resource "google_storage_bucket" "security_logs" {
  #checkov:skip=CKV_GCP_62: This bucket is itself the cross-cloud security/audit log destination (Falco + CI evidence); a separate access-log sink bucket is out of scope for this portfolio.
  name     = var.bucket_name
  project  = var.gcp_project_id
  location = var.location

  force_destroy               = false
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  retention_policy {
    retention_period = var.retention_period_seconds
  }
}
