# security-baseline (Phase 2 — in progress)

Provisions the organization's detective baseline:

- Organization CloudTrail delivering to a locked S3 bucket in the log-archive account
- AWS Config recorder in every account with the CIS AWS Foundations conformance pack
- Security Hub enabled org-wide, findings aggregated into the audit account

Interface sketch:

```hcl
module "security_baseline" {
  source = "./modules/security-baseline"

  log_archive_account_id = "111111111111"
  audit_account_id       = "222222222222"
  home_region            = "us-east-1"
}
```
