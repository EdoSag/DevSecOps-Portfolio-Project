# GitHub Actions OIDC trust for AWS.
#
# AWS validates the GitHub OIDC issuer's TLS chain against its own trusted CA
# bundle (not the thumbprint_list) since 2023, but the field is still required
# by the provider. The well-known GitHub Actions root CA thumbprint is supplied
# via the tls_certificate data source so this stays correct if it ever changes.
data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}

# Trust policy: only this repo's workflows (any branch/ref) may assume this role.
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_ci" {
  name               = "gh-actions-devsecops-ci"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

# Minimal starting policy - just enough to prove the OIDC trust works end to
# end (Phase 2 verification). Expand only if a later phase's CI job needs more.
data "aws_iam_policy_document" "github_actions_ci_minimal" {
  statement {
    effect    = "Allow"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions_ci_minimal" {
  name   = "minimal-sts"
  role   = aws_iam_role.github_actions_ci.id
  policy = data.aws_iam_policy_document.github_actions_ci_minimal.json
}
