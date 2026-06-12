output "security_ou_id" {
  description = "ID of the Security OU"
  value       = aws_organizations_organizational_unit.security.id
}

output "workloads_ou_id" {
  description = "ID of the Workloads OU"
  value       = aws_organizations_organizational_unit.workloads.id
}

output "sandbox_ou_id" {
  description = "ID of the Sandbox OU"
  value       = aws_organizations_organizational_unit.sandbox.id
}

output "scp_ids" {
  description = "IDs of the guardrail SCPs"
  value = {
    deny_root_user            = aws_organizations_policy.deny_root_user.id
    deny_unapproved_regions   = aws_organizations_policy.deny_unapproved_regions.id
    require_imdsv2            = aws_organizations_policy.require_imdsv2.id
    protect_security_services = aws_organizations_policy.protect_security_services.id
  }
}
