locals {
  deployment_prefix = "test"
  region        = "eu-north-1"

  default_tags = {
    "TerminationDate"  = "Permanent",
    "Environment"      = "Test",
    "Team"             = "DevOps",
    "DeployedBy"       = "Terraform",
    "OwnerEmail"       = "artembryhynets@gmail.com"
    "DeploymentPrefix" = local.deployment_prefix
  }

}
# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "tfstate-infra-reflection21"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    s3_bucket_tags = local.default_tags
    use_lockfile   = true
  }
}
# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}
variable "region" {
  type        = string
  description = "aws region"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource."
}
EOF
}

retryable_errors = [
  "(?s).*Error.*Required plugins are not installed.*"
]

inputs = {
  region        = local.region
  deployment_prefix = local.deployment_prefix
  default_tags      = local.default_tags
}
