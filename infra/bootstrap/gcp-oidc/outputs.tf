output "workload_identity_provider" {
  description = "Full resource name of the Workload Identity Provider, for use as `workload_identity_provider` in google-github-actions/auth"
  value       = "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github_actions.workload_identity_pool_provider_id}"
}

output "github_actions_ci_service_account_email" {
  description = "Email of the service account GitHub Actions impersonates"
  value       = google_service_account.github_actions_ci.email
}
