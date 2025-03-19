variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "instance_types" {
  description = "List of EC2 instance types to create"
  type = list(string)
}

variable "runner_token" {
  description = "GitHub token for registering self-hosted runner"
  type        = string
  sensitive = "true"
}

variable "github_repo" {
  description = "GitHub repository (org/repo)"
  type        = string
}

variable "security_group" {
  description = "Security group ID for the EC2 instance"
  type        = string
  default     = "sg-0db0b78a919fb1799"
}
