# Workload Identity Federation pool/provider trusting GitHub Actions OIDC
# tokens, scoped to this repository only.
resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions"
  description               = "Workload Identity Pool for GitHub Actions OIDC tokens"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "GitHub Actions"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  # Restrict tokens to workflow runs on this repo's main branch only.
  attribute_condition = "assertion.repository == '${var.github_org}/${var.github_repo}' && assertion.sub == 'repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_actions_ci" {
  account_id   = "gh-actions-ci"
  display_name = "GitHub Actions CI"
}

# Allow only this repo's GitHub Actions workflows to impersonate the CI service account.
resource "google_service_account_iam_member" "github_actions_wif" {
  service_account_id = google_service_account.github_actions_ci.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/attribute.repository/${var.github_org}/${var.github_repo}"
}
