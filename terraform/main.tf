terraform {
  cloud {

    organization = "test-terafrom-cloud"

    workspaces {
      name = "github-self-runner-pipeline-flow"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "github_runners" {
  count = length(var.instance_types)
  ami = "ami-09773b29dffbef1f2"
  instance_type = var.instance_types[count.index]
  key_name      = "aws-test-github-self-hosted-runner"
  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "github-ephemeral-runner-${var.instance_types[count.index]}"
  }

  user_data = base64encode(templatefile("${path.module}/install-runner.sh.tpl", {
    RUNNER_TOKEN  = var.runner_token
    INSTANCE_TYPE = var.instance_types[count.index]
    GITHUB_REPO   = var.github_repo
  }))
}