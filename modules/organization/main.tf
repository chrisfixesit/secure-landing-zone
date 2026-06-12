terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_organizations_organization" "this" {}

locals {
  root_id = data.aws_organizations_organization.this.roots[0].id
}

# ---------- Organizational Units ----------

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = local.root_id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = local.root_id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

# ---------- Service Control Policies ----------

resource "aws_organizations_policy" "deny_root_user" {
  name        = "deny-root-user"
  description = "Block root-account actions across the organization"
  content     = file("${path.module}/../../policies/deny-root-user.json")
}

resource "aws_organizations_policy" "deny_unapproved_regions" {
  name        = "deny-unapproved-regions"
  description = "Restrict activity to the approved region list"
  content = replace(
    file("${path.module}/../../policies/deny-unapproved-regions.json"),
    "\"$${approved_regions}\"",
    jsonencode(var.approved_regions)
  )
}

resource "aws_organizations_policy" "require_imdsv2" {
  name        = "require-imdsv2"
  description = "Deny EC2 launches without IMDSv2"
  content     = file("${path.module}/../../policies/require-imdsv2.json")
}

resource "aws_organizations_policy" "protect_security_services" {
  name        = "protect-security-services"
  description = "Deny disabling CloudTrail, Config, GuardDuty, Security Hub"
  content     = file("${path.module}/../../policies/protect-security-services.json")
}

# ---------- Attachments ----------

locals {
  org_wide_policies = {
    deny_root_user            = aws_organizations_policy.deny_root_user.id
    deny_unapproved_regions   = aws_organizations_policy.deny_unapproved_regions.id
    protect_security_services = aws_organizations_policy.protect_security_services.id
  }
}

resource "aws_organizations_policy_attachment" "root" {
  for_each  = local.org_wide_policies
  policy_id = each.value
  target_id = local.root_id
}

resource "aws_organizations_policy_attachment" "workloads_imdsv2" {
  policy_id = aws_organizations_policy.require_imdsv2.id
  target_id = aws_organizations_organizational_unit.workloads.id
}
