output "instance_ids" {
  value = aws_instance.github_runners[*].id
}

output "public_ips" {
  value = aws_instance.github_runners[*].public_ip
}
