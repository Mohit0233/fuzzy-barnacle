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

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y curl tar jq git

    # Set environment variable for GitHub Runner authentication
    export RUNNER_CFG_PAT="${runner_token}"

    # Install & Configure GitHub Runner
    mkdir -p /home/ubuntu/actions-runner
    cd /home/ubuntu/actions-runner

    LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | cut -c2-)
    curl -L -o actions-runner-linux-arm64-${LATEST_VERSION}.tar.gz https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-arm64-${LATEST_VERSION}.tar.gz

    tar xzf ./actions-runner-linux-arm64-${LATEST_VERSION}.tar.gz

    # Define the runner name and label dynamically
    RUNNER_NAME="aws-runner-${var.instance_types[count.index]}"

    # Configure the runner with the same name as a label
    ./config.sh --url https://github.com/${github_repo} --token $RUNNER_CFG_PAT --unattended --name "$RUNNER_NAME" --labels "$RUNNER_NAME"

    # Install and start the runner as a service
    ./svc.sh install
    ./svc.sh start

  EOF
}

