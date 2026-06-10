output "bucket_name" {
  description = "Name of the GCS bucket used for cross-cloud log archiving"
  value       = google_storage_bucket.security_logs.name
}

output "bucket_url" {
  description = "gs:// URL of the bucket"
  value       = google_storage_bucket.security_logs.url
}
