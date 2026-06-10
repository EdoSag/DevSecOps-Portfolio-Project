# Phase 1 — Checkov Pre-Commit Hook Blocks Insecure Security Group

A deliberately insecure `aws_security_group` (SSH open to `0.0.0.0/0`, not attached to
any resource) was added at `infra/aws-eks/main.tf` to verify the Checkov pre-commit hook.

Command: `git commit -m "Initial scaffold: vulnerable demo app, pre-commit config"`

```
Checkov (IaC scan).......................................................Failed
- hook id: checkov
- exit code: 1

terraform scan results:

Passed checks: 5, Failed checks: 2, Skipped checks: 0

Check: CKV_AWS_24: "Ensure no security groups allow ingress from 0.0.0.0:0 to port 22"
	FAILED for resource: aws_security_group.bad_example
	File: \infra\aws-eks\main.tf:1-12
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/networking-1-port-security

Check: CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
	FAILED for resource: aws_security_group.bad_example
	File: \infra\aws-eks\main.tf:1-12
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/ensure-that-security-groups-are-attached-to-ec2-instances-or-elastic-network-interfaces-enis
```

**Source of the finding** — `infra/aws-eks/main.tf`:
```hcl
resource "aws_security_group" "bad_example" {
  name        = "bad-example-sg"
  description = "Temporary insecure SG to demonstrate Checkov pre-commit scanning"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

The commit was rejected before it ever reached the repository. The temporary snippet
was removed; the real `infra/aws-eks` module (built in Phase 2) does not expose SSH
to the internet — cluster access is via the EKS-managed API endpoint and AWS SSM
Session Manager only.
