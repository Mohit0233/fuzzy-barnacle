#!/bin/bash
LOG_FILE="/home/ubuntu/log.txt"

exec > >(tee -a "$LOG_FILE") 2>&1

# Function to log and execute commands
execute_command() {
    echo -e "\n--- Executing: $* ---\n"
    eval "$@" >> "$LOG_FILE" 2>&1
    local status=$?
    if [ $status -eq 0 ]; then
        echo -e "\033[32m\n--- Completed successfully: $* ---\033[0m\n"
    else
        echo -e "\033[31m\n--- Error (exit status: $status) during: $* ---\033[0m\n"
    fi
    return $status
}

execute_command sudo apt update -y
execute_command sudo apt install -y curl tar jq git

echo -e "RUNNER_CFG_PAT=$${RUNNER_CFG_PAT:0:4}****$${RUNNER_CFG_PAT: -4}\n" >> "$LOG_FILE"

# Set environment variable for GitHub Runner authentication
export RUNNER_CFG_PAT="${RUNNER_TOKEN}"

execute_command mkdir -p /home/ubuntu/actions-runner
execute_command cd /home/ubuntu/actions-runner

LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | cut -c2-)
execute_command curl -L -o actions-runner-linux-arm64-$${LATEST_VERSION}.tar.gz https://github.com/actions/runner/releases/download/v$${LATEST_VERSION}/actions-runner-linux-arm64-$${LATEST_VERSION}.tar.gz

execute_command tar xzf ./actions-runner-linux-arm64-$${LATEST_VERSION}.tar.gz

RUNNER_NAME="aws-runner-${INSTANCE_TYPE}"

 curl -s -X POST "https://api.github.com/repos/Mohit0233/fuzzy-barnacle/actions/runners/registration-token"

base_api_url="https://api.github.com"
orgs_or_repos="repos"

export RUNNER_TOKEN=$(curl -s -X POST $${base_api_url}/$${orgs_or_repos}/${GITHUB_REPO}/actions/runners/registration-token -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token $${RUNNER_CFG_PAT}" | jq -r '.token')


execute_command sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
execute_command sudo -u ubuntu ./config.sh --url https://github.com/${GITHUB_REPO} --token $RUNNER_TOKEN --unattended --name "$RUNNER_NAME" --labels "$RUNNER_NAME"
execute_command ./svc.sh install
execute_command ./svc.sh start
