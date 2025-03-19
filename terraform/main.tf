
# terraform {
#   cloud {
#
#     organization = "test-terafrom-cloud"
#
#     workspaces {
#       name = "github-self-runner-pipeline-flow"
#     }
#   }
# }
#
# provider "aws" {
#   region = var.aws_region
# }
#
# locals {
#   instance_type_list = tolist(var.instance_types)  # Ensure it's a list
# }
#
# resource "aws_instance" "github_runners" {
#   count = length(local.instance_type_list)
#
#   ami             = "ami-09773b29dffbef1f2"
#   instance_type   = local.instance_type_list[count.index]  # Extract single value
#   key_name        = "aws-test-github-self-hosted-runner"
#   vpc_security_group_ids = [var.security_group]
#
#   tags = {
#     Name = "github-ephemeral-runner-${local.instance_type_list[count.index]}"
#   }
#
#   user_data = base64encode(templatefile("${path.module}/install-runner.sh.tpl", {
#     RUNNER_TOKEN  = var.runner_token
#     INSTANCE_TYPE = local.instance_type_list[count.index]  # Now Terraform gets only a single value per instance
#     GITHUB_REPO   = var.github_repo
#   }))
# }

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "null" {}

# Define a local variable that holds the runner names
locals {
  runners = [
    "aws-runner-t4g.small",
    "aws-runner-t4g.medium"
  ]
}

# Output the runner names as a JSON array
output "runner_names" {
  value = local.runners
}