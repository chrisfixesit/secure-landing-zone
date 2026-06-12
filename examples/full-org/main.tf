terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Run from the organization's management account.
provider "aws" {
  region = "us-east-1"
}

module "organization" {
  source = "../../modules/organization"

  approved_regions = ["us-east-1", "ca-central-1"]
}

output "organization" {
  value = {
    security_ou  = module.organization.security_ou_id
    workloads_ou = module.organization.workloads_ou_id
    sandbox_ou   = module.organization.sandbox_ou_id
  }
}
